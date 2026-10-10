#!/usr/bin/env python3
"""Ghi toạ độ/kích thước/chữ mới cho control theo tên, giữ nguyên mọi dòng khác của file.

Dùng như thư viện:

    from apply import apply
    apply('Data/Interface/GameTools/GameTools.layout.xml',
          {'GameTools_Frame': {'x': -337, 'w': 874},
           'GameTools_Addition8': {'x': 138, 'w': 68}},
          {'GameTools_Addition8': 'Chuyển đổi'})

hoặc dòng lệnh với file JSON:

    python3 tools/ui_layout/apply.py spec.json [--dry]

    spec.json = {"file": "Data/Interface/.../X.layout.xml",
                 "controls": {"TênControl": {"x": 10, "y": 3, "w": 60, "h": 18, "text": "..."}}}

Quy ước:
- x, y, w, h là toạ độ CỤC BỘ (tính từ góc control cha), đơn vị px.
- Toạ độ ghi vào đúng property đang có (UnifiedPosition/AbsolutePosition, UnifiedSize/AbsoluteSize).
  Khi ghi x vào UnifiedPosition, phần tỉ lệ trục x đặt về 0 (control neo theo mép phải như
  {{1,-44}} sẽ thành neo mép trái); y giữ nguyên tỉ lệ cũ. Riêng khung chính (*_Frame,
  dạng {{0.5,-230},{0.5,-185}}) giữ tỉ lệ 0.5 để vẫn căn giữa màn hình.
- Control nằm trong <!-- --> bị bỏ qua. BOM và kiểu xuống dòng (CRLF/LF) được giữ nguyên.
- Mục nào không áp được (sai tên, control không có property tương ứng) sẽ được in ra.
"""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import mask_comments  # noqa: E402

PROP_RE = re.compile(r'(\s*<Property Name=")([^"]+)(" Value=")([^"]*)(".*)$')


def _f(v):
    return f'{v:.6f}'


def _new_value(cur, prop, val, sp):
    if prop == 'UnifiedPosition' and ('x' in sp or 'y' in sp):
        m = re.match(r'\{\{([-\d.]+),([-\d.]+)\},\{([-\d.]+),([-\d.]+)\}', val.replace(' ', ''))
        a, b, c, d = (float(x) for x in m.groups())
        is_frame = cur.endswith('_Frame')
        if 'x' in sp:
            b = sp['x']
            if not is_frame and not sp.get('keepscale'):
                a = 0.0
        if 'y' in sp:
            d = sp['y']
        if is_frame:
            return '{{%g,%d},{%g,%d}}' % (a, b, c, d)
        return '{{%s,%s},{%s,%s}}' % (_f(a), _f(b), _f(c), _f(d))
    if prop == 'AbsolutePosition' and ('x' in sp or 'y' in sp):
        m = re.search(r'x:([-\d.]+)\s+y:([-\d.]+)', val)
        x, y = sp.get('x', float(m.group(1))), sp.get('y', float(m.group(2)))
        return f'x:{_f(x)} y:{_f(y)}'
    if prop == 'UnifiedSize' and ('w' in sp or 'h' in sp):
        m = re.match(r'\{\{([-\d.]+),([-\d.]+)\},\{([-\d.]+),([-\d.]+)\}', val.replace(' ', ''))
        a, b, c, d = (float(x) for x in m.groups())
        if 'w' in sp:
            a, b = 0.0, sp['w']
        if 'h' in sp:
            c, d = 0.0, sp['h']
        return '{{%s,%s},{%s,%s}}' % (_f(a), _f(b), _f(c), _f(d))
    if prop == 'AbsoluteSize' and ('w' in sp or 'h' in sp):
        m = re.search(r'w:([-\d.]+)\s+h:([-\d.]+)', val)
        w, h = sp.get('w', float(m.group(1))), sp.get('h', float(m.group(2)))
        if re.match(r'w:\d+ h:\d+$', val):
            return f'w:{int(w)} h:{int(h)}'
        return f'w:{_f(w)} h:{_f(h)}'
    return None


def apply(path, spec, texts=None, dry=False):
    """spec: {tên: {x,y,w,h,keepscale}}; texts: {tên: chữ mới}. Trả về danh sách mục không áp được."""
    texts = dict(texts or {})
    for name, sp in spec.items():
        if 'text' in sp:
            texts[name] = sp['text']
    raw = open(path, 'rb').read()
    bom = raw.startswith(b'\xef\xbb\xbf')
    t = (raw[3:] if bom else raw).decode('utf-8')
    lines = t.split('\n')
    masked = mask_comments(lines)
    out, stack, seen = [], [], set()
    for i, line in enumerate(lines):
        s = masked[i].strip()
        m = re.match(r'<Window Type="[^"]+" Name="([^"]+)"', s)
        if m:
            stack.append(m.group(1))
            out.append(line)
            if s.endswith('/>'):
                stack.pop()
            continue
        if s.startswith('</Window'):
            if stack:
                stack.pop()
            out.append(line)
            continue
        cur = stack[-1] if stack else None
        pm = PROP_RE.match(line) if s else None
        if pm and cur in spec:
            nv = _new_value(cur, pm.group(2), pm.group(4), spec[cur])
            if nv is not None:
                line = pm.group(1) + pm.group(2) + pm.group(3) + nv + pm.group(5)
                seen.add((cur, pm.group(2)))
        if pm and cur in texts and pm.group(2) == 'Text':
            line = pm.group(1) + 'Text' + pm.group(3) + texts[cur] + pm.group(5)
            seen.add((cur, 'Text'))
        out.append(line)
    props = {'x': ('UnifiedPosition', 'AbsolutePosition'), 'y': ('UnifiedPosition', 'AbsolutePosition'),
             'w': ('UnifiedSize', 'AbsoluteSize'), 'h': ('UnifiedSize', 'AbsoluteSize')}
    missing = [(n, k) for n, sp in spec.items() for k in sp
               if k in props and not any((n, p) in seen for p in props[k])]
    missing += [(n, 'text') for n in texts if (n, 'Text') not in seen]
    if missing:
        print('  KHÔNG áp được:', missing)
    if not dry:
        open(path, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + '\n'.join(out).encode('utf-8'))
    return missing


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    cfg = json.load(open(sys.argv[1], encoding='utf-8'))
    left = apply(cfg['file'], cfg['controls'], dry='--dry' in sys.argv)
    sys.exit(1 if left else 0)
