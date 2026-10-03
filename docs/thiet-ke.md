# Tài liệu thiết kế Island Hero

## Ý tưởng

Game idle RPG chạy trên Dynamic Island của iPhone. Người chơi "liếc xem" đội anh hùng tự đánh quái, mở rương, rèn đồ, chọn đội hình. Thế giới lấy từ thần thoại, cổ tích và truyền thuyết Việt Nam; giọng điệu phiêu lưu, anh hùng.

## Cốt truyện

Kẻ trộm đeo mặt nạ **Hắc Y** đánh cắp các báu vật giữ nước. Các anh hùng truyền thuyết lần lượt lên đường tìm lại.

- **Chương 60**: Hắc Y lộ mặt là **Rùa Vàng Kim Quy**. Ông thu báu vật để dựng lại phong ấn dưới Hồ Tây.
- **Hồi 9**: phong ấn vỡ. **Cô bán trà** dẫn đường và bán hàng cho đội từ đầu game chính là **Hồ Tinh**. Cô lợi dụng đội đánh Kim Quy để thoát ra.
- **Hồi 10**: **Cửu Vĩ Hồ Tinh** hiện nguyên hình; chương 91 đến 99 mỗi chương chặt một đuôi.
- **Âm Phủ**: Hồ Tinh kéo bóng tối xuống âm phủ; có kẻ đã ban sức mạnh cho cô ta.
- **Thiên Giới**: kẻ đứng sau là **Thủy Tinh**. Trận cuối Sơn Tinh – Thủy Tinh.

## Cấu trúc

| Tầng | Số lượng | Ghi chú |
|---|---|---|
| Độ khó | 3 | Nhân Gian (cấp 1–150), Âm Phủ (150–320), Thiên Giới (320–500) |
| Hồi | 10 mỗi độ khó | Mỗi hồi một vùng đất, một báu vật |
| Chương | 100 mỗi độ khó, 300 tổng | |
| Màn | 10 mỗi chương, 3.000 tổng | Ký hiệu `chương-màn`, ví dụ `57-3` |

Trong một chương: màn 1–9 có 5–8 quái, con cuối là **tinh anh** (máu x3,5, thưởng x3). Màn 10 là **boss chương** (60 giây). Màn 10 của chương 10, 20, 30… là **boss hồi** (90 giây). Mở Âm Phủ cần thắng 100-10 và hero cấp 150; Thiên Giới cần thắng 200-10 và cấp 320.

## Anh hùng

Đội tối đa 4, mở ô ở chương 10, 30, 60. Hero dự bị nhận 30% kinh nghiệm.

| Hero | Vai trò | Mở ở | Skill | Nội tại |
|---|---|---|---|---|
| Thánh Gióng | Chắn đòn | Hồi 1 | Roi sắt | Đội nhận ít hơn 20% sát thương |
| Thạch Sanh | Đánh xa | Hồi 2 | Tiếng đàn thần | Quái choáng 2 giây |
| Sơn Tinh | Phép | Hồi 3 | Bốc đồi dời núi | Đòn phép 6 lần công |
| Chử Đồng Tử | Hồi máu | Hồi 4 | Cắm gậy úp nón | Hồi 25% máu đội |
| Mai An Tiêm | Hỗ trợ | Hồi 5 | Mùa dưa đỏ | +25% vàng |
| Cao Lỗ | Bạo kích | Hồi 6 | Mười mũi Liên Châu | +20% bạo kích |
| Mỵ Châu | Che chắn | Hồi 6 | Áo lông ngỗng | Khiên 20% máu đội |
| Lê Lợi | Diệt boss | Hồi 7 | Thuận Thiên trảm | +30% sát thương lên boss |
| Lạc Long Quân | Diện rộng | Hồi 8 | Rồng cuộn sóng | Sóng hạ luôn quái yếu máu |
| Âu Cơ | Phép hồi | Hồi 8 | Trăm trứng nở trăm con | Hồi 15% máu, +20% công |
| Hai Bà Trưng | Chỉ huy | Hồi 9 | Hai Bà cùng xuất trận | +15% công cả đội |
| Bà Triệu | Phá giáp | Hồi 10 | Cưỡi voi xung trận | Quái nhận thêm 30% sát thương |

**Cộng hưởng**: Gióng + Lê Lợi (Đánh giặc giữ nước), Thạch Sanh + Cao Lỗ (Cung nỏ thần), Chử Đồng Tử + Mai An Tiêm (Đất lành), Sơn Tinh + Lạc Long Quân (Non nước), Cao Lỗ + Mỵ Châu (Thành Cổ Loa), Lạc Long Quân + Âu Cơ (Con Rồng cháu Tiên), Hai Bà Trưng + Bà Triệu (Nữ tướng).

## Quái và boss

| Hồi | Vùng | Quái thường | Boss hồi |
|---|---|---|---|
| 1 | Làng Phù Đổng | Lính giặc Ân, Cung thủ giặc Ân, Chó săn | Tướng giặc Ân |
| 2 | Rừng đa cổ thụ | Rắn độc, Nhện tinh, Rắn hổ mang | Chằn Tinh |
| 3 | Núi Tản Viên | Thuồng luồng con, Cá sấu, Thuồng luồng đỏ | Thuồng luồng chúa |
| 4 | Bãi Tự Nhiên | Ma da, Cóc ma, Ma da tím | Ma da chúa |
| 5 | Đảo hoang | Cua đá, Khỉ đảo, Cua xanh | Đại Bàng tinh |
| 6 | Thành Cổ Loa | Bạch Kê ma, Quạ đen, Gà ma lửa | Hắc Y |
| 7 | Hồ Lục Thủy | Ma cây, Lính giặc Minh, Ma cây đỏ | Mộc Tinh |
| 8 | Biển Đông | Tôm binh, Sứa độc, Tôm hùm tướng | Ngư Tinh |
| 9 | Hồ Tây | Hồ ly con, Dơi quỷ, Hồ ly bạc | Hồ Tinh |
| 10 | Chín đuôi | Ma trơi, Quỷ lửa, Ma trơi tím | Cửu Vĩ Hồ Tinh |

Âm Phủ và Thiên Giới dùng lại 10 vùng với màu khác và chỉ số cao hơn.

## Trang bị

12 ô mỗi hero: vũ khí chính, vũ khí phụ, mũ, áo giáp, găng tay, thắt lưng, quần, giày, dây chuyền, nhẫn trái, nhẫn phải, bùa hộ mệnh.

| Độ hiếm | Tên kim loại | Hệ số chỉ số chính | Số dòng phụ |
|---|---|---|---|
| Thường | sắt | 1 | 1 |
| Hiếm | đồng | 1,4 | 2 |
| Sử thi | bạc | 1,9 | 3 |
| Huyền thoại | vàng | 2,6 | 4 |
| Thần khí | thần | 3,5 | 5 (chỉ ở Thiên Giới) |

Dòng phụ: công %, máu %, giảm sát thương nhận, tốc đánh, bạo kích, sát thương bạo kích, hút máu, sát thương lên boss, giảm hồi chiêu, vàng, kinh nghiệm. Đồ càng hiếm, mỗi dòng càng cao (+25% mỗi bậc).

**Lò rèn**
- Cường hóa +1 đến +15: mỗi cấp chỉ số chính +10%, dòng phụ +5%. Tỉ lệ 100% tới +5, giảm dần tới khoảng 20% ở +14. Thất bại chỉ mất nguyên liệu.
- Ép đồ: 3 món cùng độ hiếm thành 1 món hiếm hơn. Ép ra Thần khí chỉ mở ở Thiên Giới.
- Rã đồ ra đá rèn.

## Rương

| Rương | Nguồn | Tỉ lệ Thường / Hiếm / Sử thi / Huyền thoại / Thần khí | Trứng thú |
|---|---|---|---|
| Gỗ | Quái thường, 4% | 65 / 28 / 6 / 1 / 0 | 0% |
| Đồng | Tinh anh, 50% | 35 / 42 / 18 / 5 / 0 | 2% |
| Bạc | Boss chương | 10 / 40 / 35 / 14 / 1 | 6% |
| Vàng | Boss hồi | 0 / 20 / 45 / 30 / 5 | 15% |

## Thú cưỡi và thú cưng

Thú cưỡi (chọn 1, cả đội hưởng, nuôi tới cấp 20): Ngựa sắt (hồi 1, tốc đánh), Trâu vàng (hồi 3, máu), Hạc tiên (hồi 5, vàng và kinh nghiệm), Rùa vàng (hồi 6, giảm sát thương), Voi chiến (hồi 9, công và máu), Rồng Lạc (hồi 10, công và tốc đánh). Thuần phục khi hạ boss hồi tương ứng.

Thú cưng (chọn 1, nở từ trứng trong rương, trùng thì lên cấp tới 10): Chim Lạc (kinh nghiệm), Mèo mướp (vàng), Gà trống Đông Hồ (bạo kích), Cóc tía (hồi máu khi hạ quái), Cá chép (tỉ lệ rương), Chó vàng (tự cắn quái).

## Cửa hàng

- Hiệu ứng tạm thời, 30 phút mỗi lần mua, tối đa 8 giờ: Trà sâm, Hương trầm, Rượu nếp, Bùa đỏ, Bùa đá, Bùa may. Giá theo vàng của màn hiện tại.
- Nâng cấp vĩnh viễn, giá cố định theo bậc: `100 × (bậc + 1)^2,6` vàng.
- Trước hồi 9 là quán của cô bán trà; sau khi cô lộ mặt, Kim Quy mở quầy mới.

## Công thức chính

`L` là cấp gợi ý của màn, tăng tuyến tính trong từng độ khó. `P(l) = ((l + 9) / 10)^2,3`.

- Hero: công `35 × P(cấp)`, máu `160 × P(cấp)`.
- Quái: máu `120 × P(L) × hồi × độ khó × (1 + 6 × r^1,2)`, công `24 × P(L) × hồi × độ khó × (1 + 30 × r)`, với `r = (màn toàn cục / 3000)^1,4`. Hồi: +8% mỗi hồi. Độ khó: 1 / 1,35 / 1,85.
- Boss chương: máu x2,8, công x1,35. Boss hồi: máu x6,5, công x2,2.
- Kinh nghiệm cần lên cấp: `100 × cấp^2,2`. Kinh nghiệm mỗi màn bám theo đường cấp mục tiêu của độ khó.
- Lực chiến hero: tính từ công hiệu dụng (có tốc đánh, bạo kích, sát thương boss, hồi chiêu), máu và giáp. Lực chiến đội là tổng 4 hero.

Bản web dùng nguyên các hằng số này; bản Swift nằm trong `ios/IslandHero/Shared/GameBalance.swift` (chưa có phần tăng độ khó cuối game).
