# Makes the app's fonts: static instances of the variable Fraunces and Figtree
# from github.com/google/fonts (ofl/fraunces, ofl/figtree), cut down to the
# Latin letters the five app languages need.
#
#   pip install fonttools
#   python3 tool/fonts.py <folder with Fraunces.ttf, Fraunces-Italic.ttf, Figtree.ttf> assets/fonts
import sys
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont
from fontTools import subset

src, out = sys.argv[1], sys.argv[2]
unicodes = "U+0020-007E,U+00A0-017F,U+2013-2014,U+2018-201E,U+2022,U+2026,U+2039-203A,U+20AC"
jobs = [
    ("Fraunces.ttf", "Fraunces-Light.ttf", {"wght": 300, "opsz": 72, "SOFT": 0, "WONK": 0}),
    ("Fraunces.ttf", "Fraunces-Regular.ttf", {"wght": 400, "opsz": 30, "SOFT": 0, "WONK": 0}),
    ("Fraunces-Italic.ttf", "Fraunces-LightItalic.ttf", {"wght": 300, "opsz": 72, "SOFT": 0, "WONK": 0}),
    ("Fraunces-Italic.ttf", "Fraunces-Italic.ttf", {"wght": 400, "opsz": 30, "SOFT": 0, "WONK": 0}),
    ("Figtree.ttf", "Figtree-Regular.ttf", {"wght": 400}),
    ("Figtree.ttf", "Figtree-Medium.ttf", {"wght": 500}),
    ("Figtree.ttf", "Figtree-SemiBold.ttf", {"wght": 600}),
]
for name, target, axes in jobs:
    font = instantiateVariableFont(TTFont(f"{src}/{name}"), axes, updateFontNames=False)
    options = subset.Options()
    options.layout_features = ["kern", "liga", "calt", "tnum", "lnum", "pnum", "case"]
    options.name_IDs = ["*"]
    sub = subset.Subsetter(options)
    sub.populate(unicodes=subset.parse_unicodes(unicodes))
    sub.subset(font)
    font.save(f"{out}/{target}")
    print(target)
