"""Standalone native Lua 5.0 behavior and runtime asset checks."""
from pathlib import Path
import argparse
import os
import re
import shutil
import struct
import subprocess

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--lua50', default=os.environ.get('LUA50'))
args = parser.parse_args()
lua = args.lua50 or shutil.which('lua5.0') or shutil.which('lua50')
if not lua:
    parser.error('Supply native Lua 5.0 with --lua50 PATH or LUA50.')
subprocess.run([lua, '-e', 'assert(_VERSION == "Lua 5.0" or string.find(_VERSION, "^Lua 5%.0%."), _VERSION)'], check=True)
toc = (root/'AzerothCursor.toc').read_text(encoding='utf-8')
version = re.search(r'## Version: (\S+)', toc).group(1)
assert f'version = "{version}"' in (root/'Core.lua').read_text(encoding='utf-8')
for entry in toc.splitlines():
    if entry.strip() and not entry.startswith('#'):
        assert (root/entry).is_file(), entry
        subprocess.run([lua, '-e', f'assert(loadfile("{entry}"))'], cwd=root, check=True)
subprocess.run([lua, 'tests/scenarios.lua'], cwd=root, check=True)
assets = list((root/'Media').glob('*.tga'))
assert len(assets) == 11
for path in assets:
    data = path.read_bytes()
    assert len(data) == 18 + 128*128*4
    assert struct.unpack_from('<HH', data, 12) == (128, 128)
    alpha = data[21::4]
    assert min(alpha) == 0 and max(alpha) > 100, path
print(f'{version}: TOC, native Lua 5.0 and 11 TGA assets OK')
