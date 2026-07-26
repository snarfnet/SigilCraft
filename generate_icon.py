"""Sigil Craft - dark arcane icon: a golden sigil glyph on a magic wheel."""
from PIL import Image, ImageDraw
import math, os, random

SIZE = 1024
img = Image.new('RGB', (SIZE, SIZE), (13, 13, 18))
draw = ImageDraw.Draw(img)

# radial dark gradient
cx, cy = SIZE // 2, SIZE // 2
for y in range(SIZE):
    for band in range(1):
        pass
# cheap radial: draw concentric rectangles darkening outward
for r in range(SIZE // 2, 0, -2):
    t = 1 - r / (SIZE / 2)
    val = int(10 + 18 * t)
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(val, val, int(val * 1.2)))

gold = (212, 174, 89)
gold_bright = (242, 209, 115)
crimson = (166, 38, 51)

# outer wheel rings
draw.ellipse([cx-380, cy-380, cx+380, cy+380], outline=gold, width=4)
draw.ellipse([cx-360, cy-360, cx+360, cy+360], outline=(150, 120, 60), width=1)
draw.ellipse([cx-300, cy-300, cx+300, cy+300], outline=(120, 95, 45), width=1)

# 26 tick marks
R = 360
for i in range(26):
    a = -math.pi/2 + i/26*2*math.pi
    p1 = (cx + math.cos(a)*R, cy + math.sin(a)*R)
    p2 = (cx + math.cos(a)*(R-18), cy + math.sin(a)*(R-18))
    draw.line([p1, p2], fill=(150, 120, 60), width=2)

# a sigil-like glyph: connect a fixed set of letter positions
letters = [3, 7, 12, 18, 22, 9, 15, 1]  # indices around the wheel
pts = []
for idx in letters:
    a = -math.pi/2 + idx/26*2*math.pi
    pts.append((cx + math.cos(a)*260, cy + math.sin(a)*260))

# crimson glow underlay
for i in range(len(pts)-1):
    draw.line([pts[i], pts[i+1]], fill=crimson, width=16)
# gold line
for i in range(len(pts)-1):
    draw.line([pts[i], pts[i+1]], fill=gold_bright, width=7)

# vertices
for p in pts:
    draw.ellipse([p[0]-7, p[1]-7, p[0]+7, p[1]+7], fill=gold_bright)

# start circle
s = pts[0]
draw.ellipse([s[0]-20, s[1]-20, s[0]+20, s[1]+20], outline=gold_bright, width=6)

# end crossbar
last, prev = pts[-1], pts[-2]
dx, dy = last[0]-prev[0], last[1]-prev[1]
ln = math.hypot(dx, dy) or 1
nx, ny = -dy/ln, dx/ln
bl = 26
draw.line([(last[0]-nx*bl, last[1]-ny*bl), (last[0]+nx*bl, last[1]+ny*bl)], fill=gold_bright, width=7)

out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)),
    "SigilCraft", "Assets.xcassets", "AppIcon.appiconset")
os.makedirs(out_dir, exist_ok=True)
out = os.path.join(out_dir, "icon_1024.png")
img.save(out, "PNG")
img.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "AppIcon.png"))
print("Saved:", out)
