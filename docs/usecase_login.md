2.3.10 Chức năng đăng nhập
Mô tả:
Chức năng Đăng nhập cho phép người dùng xác thực danh tính để truy cập vào tài khoản cá nhân đã đăng ký trên hệ thống. Người dùng có thể thực hiện đăng nhập bằng Email và Mật khẩu cá nhân, hoặc sử dụng phương thức đăng nhập nhanh thông qua tài khoản Google. Dữ liệu học tập và tiến trình của trẻ sẽ được đồng bộ và quản lý sau khi đăng nhập thành công.
Mục tiêu:
Xác thực chính xác danh tính người dùng, bảo vệ thông tin và dữ liệu cá nhân của tài khoản, đồng thời cho phép đồng bộ và khôi phục tiến trình học tập của trẻ từ cơ sở dữ liệu.

2.3.10.1 Đặc tả usecase chi tiết chức năng đăng nhập
Bảng 4.2 Đặc tả usecase chức năng đăng nhập
Tên Usecase
Đăng nhập tài khoản
Tác nhân
Người dùng
Mức
1
Điều kiện tiên quyết
Thiết bị di động có kết nối mạng Internet. Người dùng chưa đăng nhập bất kỳ tài khoản nào trên ứng dụng và đang ở màn hình Đăng nhập.
Điều kiện kích hoạt
Người dùng mở ứng dụng và hệ thống yêu cầu đăng nhập, hoặc người dùng chọn nút quay lại giao diện đăng nhập từ giao diện khác.
Điều kiện thành công
Xác thực tài khoản thành công. Hệ thống chuyển hướng người dùng tới màn hình trang chủ chính của ứng dụng (Home/Main).
Điều kiện thất bại
Đăng nhập thất bại do thông tin không chính xác, email chưa được xác thực, hoặc lỗi kết nối. Hệ thống giữ nguyên giao diện đăng nhập kèm thông báo lỗi tương ứng.
Luồng sự kiện chính
1. Hệ thống hiển thị giao diện Đăng nhập gồm: 
   - Email
   - Mật khẩu
   - Nút Đăng nhập
   - Nút Đăng nhập bằng Google
   - Nút Quên mật khẩu
   - Nút Đăng ký.
2. Người dùng nhập đầy đủ thông tin Email và Mật khẩu.
3. Người dùng chạm chọn nút "Đăng nhập".
4. Hệ thống ẩn bàn phím ảo và thực hiện xác thực tính hợp lệ của dữ liệu đầu vào.
5. Hệ thống hiển thị chỉ báo tải (Loading) và gửi yêu cầu đăng nhập lên Firebase Auth.
6. Firebase Auth xác thực thông tin tài khoản hợp lệ và email đã được kích hoạt.
7. Hệ thống tắt chỉ báo tải và chuyển hướng người dùng tới màn hình chính (Home/Main).
Luồng sự kiện ngoại lệ
Ngoại lệ 1: Thiếu thông tin bắt buộc
- Hệ thống phát hiện trường Email hoặc Mật khẩu bị bỏ trống.
- Hệ thống hiển thị thông báo yêu cầu người dùng nhập đầy đủ thông tin.

Ngoại lệ 2: Thông tin nhập không hợp lệ
- Hệ thống phát hiện Email sai định dạng hoặc mật khẩu dưới 6 ký tự.
- Hệ thống hiển thị thông báo lỗi tương ứng.

Ngoại lệ 3: Sai thông tin tài khoản hoặc mật khẩu
- Firebase Auth báo lỗi sai mật khẩu hoặc tài khoản không tồn tại.
- Hệ thống hiển thị thông báo tài khoản hoặc mật khẩu không chính xác.

Ngoại lệ 4: Tài khoản chưa xác thực email
- Firebase Auth báo đăng nhập thành công nhưng email chưa được xác minh.
- Hệ thống tự động đăng xuất tài khoản và hiển thị thông báo lỗi yêu cầu người dùng xác thực email trước khi đăng nhập, kèm nút chọn "Gửi lại email".
- Người dùng chạm chọn "Gửi lại email": Hệ thống thực hiện gửi lại email xác minh và hiển thị thông báo gửi thành công.

Ngoại lệ 5: Đăng nhập bằng Google thất bại
- Người dùng chọn "Đăng nhập bằng Google" nhưng hủy bỏ giữa chừng hoặc gặp lỗi xác thực Google.
- Hệ thống tắt chỉ báo tải, dừng quá trình đăng nhập và hiển thị thông báo lỗi.

Ngoại lệ 6: Quên mật khẩu
- Người dùng nhập Email vào trường Email và chạm chọn nút "Quên mật khẩu".
- Hệ thống kiểm tra Email:
  - Nếu email trống hoặc sai định dạng: Hiển thị thông báo yêu cầu nhập địa chỉ email hợp lệ để khôi phục mật khẩu.
  - Nếu email hợp lệ: Hệ thống gửi yêu cầu đặt lại mật khẩu lên Firebase, hiển thị thông báo hướng dẫn đặt lại mật khẩu đã được gửi đến email của người dùng.
