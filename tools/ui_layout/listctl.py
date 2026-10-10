#!/usr/bin/env python3
"""In cây control của layout kèm toạ độ cục bộ L(x,y), kích thước và độ rộng chữ [px].

    python3 tools/ui_layout/listctl.py Data/Interface/GameTools5/GameTools5.layout.xml
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import load, text_width  # noqa: E402


def main(path):
    frame, wins = load(path)
    for w in wins:
        depth = sum(1 for a in w.ancestors() if a is not frame.parent) - 1
        t = w.props.get('Text', '')
        line = f"{'  ' * depth}{w.typ[:14]:14} {w.name:40} L({w.lx:.0f},{w.ly:.0f}) {w.w:.0f}x{w.h:.0f}"
        if t:
            line += f' | {t} [{text_width(t):.0f}]'
        print(line)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(1)
    main(sys.argv[1])
