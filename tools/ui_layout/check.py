#!/usr/bin/env python3
"""Kiểm tra chữ tràn/chồng trong layout và (tuỳ chọn) vẽ hình mô phỏng.

    python3 tools/ui_layout/check.py Data/Interface/GameTools/GameTools.layout.xml
    python3 tools/ui_layout/check.py --png /tmp/out Data/Interface/GameTools*/GameTools*.layout.xml

Độ rộng chữ đo bằng Schema/tahoma.ttf 12px (hơi rộng hơn font thật một chút).
Lưu ý báo nhầm hay gặp: các dòng chữ cách nhau 15px nhưng khung chữ cao 18–30px
(chữ thật không đè nhau), và nhãn có Size w:1.0 (rộng theo khung cha, chỉ chữ là hiện).
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import load, text_width, plain, font  # noqa: E402

LABEL_TYPES = {'SimpleMulitiTextFrame'}
TEXT_TYPES = {'SimpleText', 'StaticText', 'SimpleTextNoClip'}
SKIP_COLLIDE = {'DragTitle', 'Frame_Lace2', 'Frame_Lace', 'StaticImage'}


def issues(path):
    frame, wins = load(path)
    out = []
    for w in wins:
        txt = w.props.get('Text', '')
        if not txt or w is frame:
            continue
        L = text_width(txt)
        if w.typ in LABEL_TYPES or w.typ in TEXT_TYPES:
            if 'Centred' in w.props.get('HorzFormatting', ''):
                if L + 4 > w.w:
                    out.append((w.name, f'chữ {L:.0f}px > rộng {w.w:.0f}px (căn giữa)', txt))
                continue
            x0 = w.x + (4 if w.typ in LABEL_TYPES else 0)
            x1 = x0 + L
            for o in wins:
                if o is w or o is frame or o in w.ancestors() or o.typ in SKIP_COLLIDE:
                    continue
                if o.y < w.y + min(w.h, 16) and o.y + o.h > w.y + 2 and o.x < x1 + 2 and o.x + o.w > x0 and o.x >= x0 - 1:
                    out.append((w.name, f'chữ tới x={x1:.0f}, đè {o.name} (x={o.x:.0f})', txt))
                    break
            if w.typ not in LABEL_TYPES and w.w < L and w.props.get('Size', '') != 'w:1.0 h:1.0':
                out.append((w.name, f'chữ {L:.0f}px > rộng ô {w.w:.0f}px', txt))
            if w.typ in LABEL_TYPES and x1 > w.x + w.w:
                out.append((w.name, f'chữ vượt khung ({x1:.0f}>{w.x + w.w:.0f})', txt))
        elif w.typ.startswith('Button'):
            if L + 6 > w.w:
                out.append((w.name, f'chữ {L:.0f}px > nút {w.w:.0f}px', txt))
    for w in wins:
        if w is not frame and w.x + w.w > frame.w + 0.5 and w.typ != 'DragTitle' and w.props.get('Size', '') != 'w:1.0 h:1.0':
            out.append((w.name, f'tràn khung phải ({w.x + w.w:.0f}>{frame.w:.0f})', ''))
    return frame, out


def render(path, png, scale=1.5):
    from PIL import Image, ImageDraw
    frame, wins = load(path)
    im = Image.new('RGB', (int(frame.w * scale) + 4, int(frame.h * scale) + 4), (30, 30, 40))
    d = ImageDraw.Draw(im)
    f2 = font(int(12 * scale))
    colors = {'SimpleMulitiTextFrame': (90, 90, 120), 'EditBoxNormal': (70, 140, 70), 'ButtonCommon': (160, 110, 40),
              'ButtonAdd': (60, 120, 180), 'ButtonSub': (180, 60, 60), 'ButtonFenYe2': (120, 80, 160),
              'SimpleText': (80, 80, 80), 'ComboList': (60, 140, 140)}
    for w in wins:
        d.rectangle([w.x * scale, w.y * scale, (w.x + w.w) * scale, (w.y + w.h) * scale], outline=colors.get(w.typ, (70, 70, 70)))
        txt = plain(w.props.get('Text', '')).replace('#r', ' / ')
        if txt and w is not frame:
            if w.typ.startswith('Button') or 'Centred' in w.props.get('HorzFormatting', ''):
                tx = (w.x + w.w / 2) * scale - f2.getlength(txt) / 2
            elif 'RightAligned' in w.props.get('HorzFormatting', ''):
                tx = (w.x + w.w) * scale - f2.getlength(txt) - 2
            else:
                tx = (w.x + (4 if w.typ in LABEL_TYPES else 0)) * scale
            d.text((tx, (w.y + 2) * scale), txt, font=f2, fill=(255, 240, 120))
    im.save(png)


def main(argv):
    png_dir = None
    files = []
    it = iter(argv)
    for a in it:
        if a == '--png':
            png_dir = next(it)
        else:
            files.append(a)
    if not files:
        print(__doc__)
        return 1
    for f in files:
        frame, out = issues(f)
        print(f'=== {os.path.basename(f)} khung {frame.w:.0f}x{frame.h:.0f}: {len(out)} vấn đề')
        for name, msg, txt in out:
            print('  ', name, '|', msg, '|', txt[:60])
        if png_dir:
            os.makedirs(png_dir, exist_ok=True)
            p = os.path.join(png_dir, os.path.basename(f) + '.png')
            render(f, p)
            print('   ->', p)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
