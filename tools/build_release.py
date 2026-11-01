"""Build a reproducible player ZIP and SHA-256, excluding tests and tools."""
from pathlib import Path
import argparse
import hashlib
import re
import zipfile

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--output', type=Path, default=root/'dist')
args = parser.parse_args()
version = re.search(r'## Version: (\S+)', (root/'AzerothCursor.toc').read_text()).group(1)
args.output.mkdir(parents=True, exist_ok=True)
archive = args.output/f'AzerothCursor-{version}.zip'
files = [root/'AzerothCursor.toc', root/'Core.lua', root/'Options.lua', root/'README.md']
files += sorted((root/'Media').glob('*.tga'))
assert len(files) == 24, len(files)  # 4 sources + 11 rings + 9 class masks
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as z:
    for path in sorted(files):
        info = zipfile.ZipInfo('AzerothCursor/'+path.relative_to(root).as_posix(), (2026, 11, 1, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        info.external_attr = 0o100644 << 16
        z.writestr(info, path.read_bytes())
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None and len(z.namelist()) == 24
digest = hashlib.sha256(archive.read_bytes()).hexdigest()
archive.with_suffix('.zip.sha256').write_text(digest+'  '+archive.name+'\n', encoding='ascii')
print(archive)
print('SHA256 '+digest)
