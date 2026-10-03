# Island Hero cho iOS

Yêu cầu: máy Mac có Xcode, iPhone chạy iOS 17 trở lên. Dynamic Island cần iPhone 14 Pro trở lên; máy khác chỉ hiện trên Lock Screen.

## Tạo project

1. Xcode → **File → New → Project → iOS App**, tên `IslandHero`, Interface **SwiftUI**.
2. Target IslandHero → **General → Minimum Deployments: iOS 17.0**.
3. Tab **Info** của target app → thêm **Supports Live Activities = YES**.
4. **File → New → Target → Widget Extension**, tên `IslandHeroWidget`, tick **Include Live Activity**, đặt iOS 17.0.

## Thêm mã

5. Xoá các file `.swift` Xcode tạo sẵn trong thư mục widget.
6. Kéo file vào Xcode:
   - `Shared/` → tick **cả hai target** ở Target Membership.
   - `App/` → chỉ target IslandHero, thay file cùng tên.
   - `Widget/` → chỉ target IslandHeroWidgetExtension.

## Cài lên iPhone

7. **Signing & Capabilities** của cả hai target → chọn Team là Apple ID của bạn.
8. iPhone: **Cài đặt → Quyền riêng tư & Bảo mật → Chế độ nhà phát triển → Bật**.
9. Cắm cáp, chọn iPhone trên Xcode, bấm ▶︎. Lần đầu vào **Cài đặt → Cài đặt chung → VPN & Quản lý thiết bị** để tin cậy.
10. Mở app, bấm **Bật trên Dynamic Island**.

Dùng Apple ID miễn phí thì app hết hạn sau 7 ngày, cắm máy bấm ▶︎ lại là xong.

Kiểm tra cân bằng: gọi `GameBalance.runSelfCheck()` một lần (ví dụ trong `onAppear`) và xem bảng in ra ở cửa sổ Console.
