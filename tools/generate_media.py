"""Generate original antialiased, white RGBA TGA masks (no external libraries)."""
from pathlib import Path
import math
import struct

DEST = Path(__file__).resolve().parents[1] / 'Media'
DEST.mkdir(exist_ok=True)
N = 128


def mask(name, sample):
    pixels = bytearray()
    for y in range(N):
        for x in range(N):
            alpha = 0
            for sy in (.25, .75):
                for sx in (.25, .75):
                    alpha += max(0, min(1, sample((x+sx)/N-.5, (y+sy)/N-.5)))
            pixels.extend((255, 255, 255, round(alpha * 255 / 4)))
    # Uncompressed true-color, BGRA, top origin, 8 alpha bits.
    header = struct.pack('<BBBHHBHHHHBB', 0, 0, 2, 0, 0, 0, 0, 0, N, N, 32, 0x28)
    (DEST / (name + '.tga')).write_bytes(header + pixels)


for thickness, width in enumerate((.018, .032, .050), 1):
    mask('Ring' + str(thickness), lambda x, y, w=width: abs(math.hypot(x, y)-.445) <= w/2)
    mask('Outline' + str(thickness), lambda x, y, w=width: abs(math.hypot(x, y)-.445) <= w/2+.016)

mask('Halo', lambda x, y: math.exp(-((math.hypot(x, y)-.25)/.09)**2)*.7)
mask('Cross', lambda x, y: (abs(x) < .012 and .12 < abs(y) < .46) or (abs(y) < .012 and .12 < abs(x) < .46))
mask('CrossOutline', lambda x, y: (abs(x) < .030 and .102 < abs(y) < .478) or (abs(y) < .030 and .102 < abs(x) < .478))
mask('Dot', lambda x, y: math.hypot(x, y) < .25)
mask('DotOutline', lambda x, y: math.hypot(x, y) < .40)
print('Generated 11 original cursor masks')
