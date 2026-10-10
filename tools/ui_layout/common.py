"""Đọc layout CEGUI (*.layout.xml) của client TLBB và tính toạ độ tuyệt đối của từng control.

Dùng chung cho check.py, listctl.py và apply.py.
"""
import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
FONT_PATH = os.path.join(ROOT, 'Data', 'Interface', 'Schema', 'tahoma.ttf')
# Font tiếng Việt của client là Tahoma (CodePage 1258); 12px là ước lượng hơi rộng tay, an toàn.
FONT_SIZE = 12

_font = None


def font(size=FONT_SIZE):
    global _font
    try:
        from PIL import ImageFont
    except ImportError:
        raise SystemExit('Cần Pillow: pip3 install --user pillow '
                         '(hoặc pip3 install --target tools/ui_layout/.pylib pillow rồi đặt PYTHONPATH)')
    if size != FONT_SIZE:
        return ImageFont.truetype(FONT_PATH, size)
    if _font is None:
        _font = ImageFont.truetype(FONT_PATH, FONT_SIZE)
    return _font


COLOR_CODE = re.compile(r'#[cg][0-9A-Fa-f]{6}|#[A-Za-z]')


def plain(text):
    """Bỏ mã màu #Y/#cRRGGBB/#gRRGGBB và entity XML để đo chữ."""
    return COLOR_CODE.sub('', text.replace('&lt;', '<').replace('&gt;', '>').replace('&amp;', '&'))


def text_width(text):
    """Độ rộng (px) lớn nhất của các dòng (#r là xuống dòng)."""
    return max(font().getlength(plain(line)) for line in text.split('#r'))


def mask_comments(lines):
    """Trả về danh sách dòng đã xoá phần nằm trong <!-- -->, giữ nguyên số dòng (chỉ dùng để parse)."""
    out, inside = [], False
    for s in lines:
        res, i = '', 0
        while i < len(s):
            if inside:
                j = s.find('-->', i)
                if j < 0:
                    break
                inside, i = False, j + 3
            else:
                j = s.find('<!--', i)
                if j < 0:
                    res += s[i:]
                    break
                res += s[i:j]
                inside, i = True, j + 4
        out.append(res)
    return out


NUM = r'(-?[\d.]+)'


def parse_unified(v):
    m = re.match(r'\{\{' + NUM + ',' + NUM + r'\},\{' + NUM + ',' + NUM + r'\}', v.replace(' ', ''))
    return tuple(float(x) for x in m.groups()) if m else None


class Win:
    def __init__(self, typ, name, parent):
        self.typ, self.name, self.parent = typ, name, parent
        self.props, self.kids = {}, []
        self.lx = self.ly = self.x = self.y = 0.0
        self.w = self.h = 0.0

    def ancestors(self):
        a = self.parent
        while a is not None:
            yield a
            a = a.parent


def read_text(path):
    raw = open(path, 'rb').read()
    return raw[3:].decode('utf-8') if raw.startswith(b'\xef\xbb\xbf') else raw.decode('utf-8')


def load(path, screen=(1024, 768)):
    """Trả về (khung_gốc, danh_sách_mọi_control). Toạ độ x/y tính từ góc khung gốc."""
    root = Win('root', 'root', None)
    root.w, root.h = screen
    stack = [root]
    for s in mask_comments(read_text(path).split('\n')):
        s = s.strip()
        m = re.match(r'<Window Type="([^"]+)" Name="([^"]+)"', s)
        if m:
            w = Win(m.group(1).replace('TLBB_', ''), m.group(2), stack[-1])
            stack[-1].kids.append(w)
            stack.append(w)
            if s.endswith('/>'):
                stack.pop()
            continue
        if s.startswith('</Window'):
            if len(stack) > 1:
                stack.pop()
            continue
        pm = re.match(r'<Property Name="([^"]+)" Value="([^"]*)"', s)
        if pm and len(stack) > 1:
            stack[-1].props[pm.group(1)] = pm.group(2)

    def geo(w):
        p, P = w.parent, w.props
        x = y = 0.0
        ww = hh = None
        u = parse_unified(P.get('UnifiedSize', ''))
        if u:
            ww, hh = u[0] * p.w + u[1], u[2] * p.h + u[3]
        if 'AbsoluteSize' in P:
            m = re.search(r'w:' + NUM + r'\s+h:' + NUM, P['AbsoluteSize'])
            ww, hh = float(m.group(1)), float(m.group(2))
        if 'Size' in P:
            m = re.search(r'w:' + NUM + r'\s+h:' + NUM, P['Size'])
            ww, hh = float(m.group(1)) * p.w, float(m.group(2)) * p.h
        u = parse_unified(P.get('UnifiedPosition', ''))
        if u:
            x, y = u[0] * p.w + u[1], u[2] * p.h + u[3]
        if 'AbsolutePosition' in P:
            m = re.search(r'x:' + NUM + r'\s+y:' + NUM, P['AbsolutePosition'])
            x, y = float(m.group(1)), float(m.group(2))
        if 'Position' in P:
            m = re.search(r'x:' + NUM + r'\s+y:' + NUM, P['Position'])
            x, y = float(m.group(1)) * p.w, float(m.group(2)) * p.h
        if ww is None:
            ww, hh = p.w, p.h
        w.lx, w.ly = x, y
        w.x, w.y, w.w, w.h = p.x + x, p.y + y, ww, hh
        for k in w.kids:
            geo(k)

    for k in root.kids:
        geo(k)
    frame = root.kids[0]

    def walk(w):
        yield w
        for k in w.kids:
            yield from walk(k)

    wins = list(walk(frame))
    ox, oy = frame.x, frame.y
    for w in wins:
        w.x -= ox
        w.y -= oy
    return frame, wins
