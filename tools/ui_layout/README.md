# Công cụ chỉnh layout UI (CEGUI `*.layout.xml`)

Dùng để nới khung, dời control cho vừa chữ tiếng Việt mà không cần mở game.
Đã dùng cho bộ công cụ GM `Data/Interface/GameTools*`.

## Cài đặt

Cần Python 3 và Pillow (để đo độ rộng chữ, vẽ hình):

```
pip3 install --user pillow
```

Nếu không muốn cài vào máy: `pip3 install --target tools/ui_layout/.pylib pillow`
rồi chạy với `PYTHONPATH=tools/ui_layout/.pylib`.

Chữ được đo bằng chính font của client: `Data/Interface/Schema/tahoma.ttf`, cỡ 12px.
Font thật trong game hơi nhỏ hơn, nên kết quả đo dư một chút, an toàn.

Mọi lệnh chạy từ thư mục gốc repo client.

## 1. Xem cấu trúc layout

```
python3 tools/ui_layout/listctl.py Data/Interface/GameTools5/GameTools5.layout.xml
```

Lệnh in cây control. Mỗi dòng gồm:
- `L(x,y)`: toạ độ cục bộ, tính từ góc control cha.
- Kích thước của control.
- Chữ hiển thị, kèm `[độ rộng px]`.

## 2. Kiểm tra chữ tràn/chồng và vẽ hình mô phỏng

```
python3 tools/ui_layout/check.py --png /tmp/ui Data/Interface/GameTools*/GameTools*.layout.xml
```

Lệnh báo các lỗi sau:
- Nhãn đè lên ô nhập hoặc control bên cạnh.
- Chữ dài hơn nút.
- Chữ dài hơn ô chữ.
- Control tràn ra ngoài khung.

Có `--png` thì lệnh vẽ thêm hình từng layout: khung màu theo loại control, chữ vàng.

Hai kiểu báo nhầm hay gặp:
- **Các dòng chữ cách nhau 15–16px**: khung chữ cao 18–30px nên vùng chữ bị coi là chồng nhau, nhưng chữ thật không đè.
- **Nhãn có `Size w:1.0 h:1.0`**: nhãn rộng theo khung cha nên trông như tràn, nhưng trong game chỉ phần chữ là hiện.

## 3. Sửa toạ độ/kích thước/chữ theo tên control

Viết file JSON:

```json
{"file": "Data/Interface/GameTools/GameTools.layout.xml",
 "controls": {
   "GameTools_Frame":     {"x": -337, "w": 874},
   "GameTools_Addition8": {"x": 138, "w": 68, "text": "Chuyển đổi"}
 }}
```

rồi chạy `python3 tools/ui_layout/apply.py spec.json` (thêm `--dry` để chạy thử).

Cũng có thể gọi `apply(path, spec, texts)` từ Python (xem docstring trong `apply.py`).

Lưu ý khi sửa:
- `x, y, w, h` là toạ độ cục bộ, đơn vị px. Công cụ ghi vào đúng property mà control đang có.
- **Control neo theo mép phải** (`{{1,-44}}`):
  - Khi ghi `x`, công cụ chuyển control sang neo mép trái.
  - Nếu nới một khung bọc chứa control con kiểu này, phải ghi lại `x` cho control con. Nếu không, con sẽ trôi theo mép phải mới. Ví dụ: ô tích + chữ trong `GameTools5_AttrSecondN`.
- **Khung chính** (`*_Frame`, `{{0.5,-230},{0.5,-185}}`):
  - Công cụ giữ tỉ lệ 0.5 để khung vẫn căn giữa màn hình.
  - Khi nới khung từ 660 lên W thì đặt `x = -230 - (W-660)/2`.
- **Phần tử trong `<!-- -->`** bị bỏ qua.
- **Định dạng file**: BOM UTF-8 và kiểu xuống dòng được giữ nguyên.

## Quy trình đã dùng cho GameTools

1. Chạy `listctl.py` và `check.py --png` để xem chỗ chật.
2. Lên phương án theo cột: nới khung, đặt ô nhập ở x đủ chứa nhãn dài nhất, nới nút theo chữ.
3. Áp bằng `apply`, rồi chạy lại `check.py --png` và xem hình. Lặp đến khi chỉ còn báo nhầm.
4. Kiểm tra XML hợp lệ, ví dụ `python3 -c "import xml.dom.minidom,sys; xml.dom.minidom.parse(sys.argv[1])" file`.
5. Mở game xem thật lần cuối, vì font thật và cách cắt chữ của CEGUI có thể khác hình mô phỏng.

Chuỗi trong file `.lua` của client là **VISCII**, không phải UTF-8. Đừng mở rồi lưu bằng editor UTF-8. Hãy sửa theo byte (`iconv -f UTF-8 -t VISCII` cho chuỗi mới).
