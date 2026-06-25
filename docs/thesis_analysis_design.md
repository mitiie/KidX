# CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG

## 2.1 Khảo sát yêu cầu

### 2.1.1 Khảo sát hệ thống tương tự
Trong quá trình nghiên cứu phát triển ứng dụng **KidX**, tác giả đã tiến hành khảo sát và đánh giá một số ứng dụng giáo dục sớm dành cho trẻ em nổi bật trên thị trường hiện nay nhằm tìm ra những điểm ưu việt cần kế thừa cũng như các mặt hạn chế cần khắc phục:

1. **Monkey Junior / Monkey Stories:**
   - *Ưu điểm:* Cung cấp kho nội dung học tiếng Anh phong phú với truyện tranh tương tác song ngữ, giọng đọc bản xứ chuẩn và hình vẽ sinh động.
   - *Nhược điểm:* Sự tương tác chủ yếu là một chiều thông qua việc "chạm và nghe" hoặc chọn các câu hỏi trắc nghiệm đơn giản. Ứng dụng chưa tích hợp công nghệ trí tuệ nhân tạo để nhận diện tương tác thực tế từ thế giới xung quanh của trẻ. Bên cạnh đó, dung lượng cài đặt rất lớn và yêu cầu tài nguyên cao để lưu trữ video.
2. **Duolingo ABC:**
   - *Ưu điểm:* Ứng dụng cơ chế Game hóa (Gamification) rất tốt, giao diện lôi cuốn và kích thích sự ham học của trẻ thông qua các trò chơi ghép chữ, phát âm cơ bản.
   - *Nhược điểm:* Đòi hỏi kết nối internet để tải dữ liệu bài học liên tục. Ứng dụng chưa hỗ trợ dạy tư duy toán học và thiếu tính năng kết nối với camera để nhận diện các đồ vật thực tế xung quanh trẻ.
3. **Khan Academy Kids:**
   - *Ưu điểm:* Chương trình học hoàn toàn miễn phí, tích hợp cả toán, tiếng Anh và kỹ năng logic với hệ thống nhân vật hoạt hình dễ thương, độ tương tác cao.
   - *Nhược điểm:* Nội dung giảng dạy hoàn toàn bằng tiếng Anh, chưa được bản địa hóa tối ưu cho trẻ em Việt Nam bắt đầu làm quen với song ngữ. Đồng thời ứng dụng chưa tích hợp các mô hình AI chạy trực tiếp trên thiết bị (on-device).

**=> Giải pháp đề xuất của KidX:** 
Ứng dụng hướng tới sự kết hợp độc đáo giữa **Giáo dục sớm song ngữ (Anh - Việt)** và **Tư duy Toán học trực quan** dựa trên nền tảng **Trí tuệ nhân tạo chạy hoàn toàn ngoại tuyến (Offline-first AI)**. Trẻ không chỉ tương tác với màn hình mà còn tương tác trực tiếp với thế giới thực qua ống kính camera (Smart Vocabulary) và rèn luyện kỹ năng viết tay số học trên bảng vẽ thông minh (Digital Math Canvas). Điều này giúp ứng dụng vừa sinh động, vừa bảo mật tối đa dữ liệu của trẻ.

---

### 2.1.2 Thu thập yêu cầu phía người dùng
Qua khảo sát thực tế hành vi sử dụng thiết bị di động của trẻ em và mong muốn của các bậc phụ huynh, các yêu cầu của hệ thống được xác định cụ thể cho hai nhóm đối tượng chính:

#### 1. Yêu cầu đối với nhóm người dùng Trẻ em (User)
* **Yêu cầu giao diện (UI/UX):** Giao diện phải sinh động, rực rỡ, sử dụng các gam màu bắt mắt phù hợp với tâm lý trẻ em dưới 8 tuổi. Các nút bấm, khu vực tương tác cần thiết kế to, rõ ràng và có âm thanh phản hồi vui nhộn. Các hiệu ứng hoạt hình (animations) phải chuyển động mượt mà để duy trì sự chú ý của trẻ.
* **Yêu cầu tính năng:** 
  - Cho phép học từ vựng một cách trực quan qua thẻ học (Flashcards) có âm thanh phát âm song ngữ Anh - Việt.
  - Cho phép tham gia trò chơi "Săn tìm đồ vật" bằng cách cầm điện thoại chụp ảnh các vật thể thực tế trong nhà, hệ thống AI sẽ tự động phân tích và phản hồi xem trẻ đã tìm đúng hay chưa.
  - Cho phép luyện viết số tay trên bảng vẽ kỹ thuật số và tham gia giải các câu đố toán học nhanh bằng nét vẽ trực tiếp.

#### 2. Yêu cầu đối với nhóm người dùng Phụ huynh (Admin / Parent)
* **Cổng bảo mật phụ huynh (Parental Gate):** Ngăn chặn trẻ em tự ý thoát ra màn hình cài đặt hoặc thực hiện các tác vụ quản lý tài khoản. Phụ huynh cần vượt qua một bài toán xác minh nhỏ để truy cập vùng quản trị.
* **Yêu cầu thống kê và quản lý:**
  - Cho phép quản lý tài khoản (Đăng ký, Đăng nhập, Đăng xuất) và đồng bộ dữ liệu tiến trình học tập của con lên đám mây.
  - Xem biểu đồ thống kê kết quả học tập chi tiết của trẻ theo thời gian thực (số sao tích lũy, số từ vựng đã mở khóa, tiến độ hoàn thành các thử thách toán học).
  - Quản lý cấu hình và danh sách các nhiệm vụ học tập (Missions) đồng bộ từ Firebase.

---

### 2.1.3 Xác định các USE CASE chính của hệ thống
Hệ thống **KidX** được xây dựng dựa trên sự tương tác giữa hai tác nhân (Actors) chính: **Người dùng Trẻ em** (tương tác với các tính năng học tập, AI) và **Phụ huynh / Quản trị viên** (quản lý tài khoản, cấu hình dữ liệu và theo dõi thống kê).

Dưới đây là bảng danh sách mô tả chi tiết các Use Case chính của ứng dụng KidX:

#### Bảng 2.1: Danh sách các usecase chính trong ứng dụng KidX

| STT | Tác nhân | Tính năng chính | Chi tiết tính năng / Use Case |
| :---: | :--- | :--- | :--- |
| **1** | **Phụ huynh / Quản trị viên** | **Quản lý tài khoản** | - Đăng ký tài khoản mới.<br>- Đăng nhập hệ thống (bằng Email hoặc Google Sign-In).<br>- Đăng xuất tài khoản.<br>- Đồng bộ và lưu trữ tiến trình học tập của trẻ lên Firebase. |
| | | **Cổng bảo mật (Parental Gate)** | - Yêu cầu xác minh phép tính số học dành riêng cho phụ huynh trước khi truy cập các tính năng quản lý. |
| | | **Quản lý dữ liệu nhiệm vụ học tập** | - Xem danh sách nhiệm vụ săn tìm đồ vật (Missions) được đồng bộ từ Firebase Realtime Database.<br>- Cập nhật dữ liệu từ khóa nhận diện từ hệ thống. |
| | | **Xem thống kê & Báo cáo** | - Xem biểu đồ phân tích thời gian học tập của trẻ (DGCharts).<br>- Xem thống kê số lượng từ vựng trẻ đã tìm thấy.<br>- Xem tiến độ và tỷ lệ hoàn thành thử thách toán học theo tuần. |
| **2** | **Trẻ em (Người dùng)** | **Học từ vựng song ngữ (Flashcards)** | - Chọn chủ đề học từ vựng (Con vật, Trái cây, Đồ dùng...).<br>- Nghe phát âm tiếng Anh - tiếng Việt chuẩn (AVFoundation).<br>- Xem hình ảnh minh họa sinh động. |
| | | **Khám phá thế giới qua Camera AI** | - Nhận nhiệm vụ săn tìm đồ vật thực tế.<br>- Sử dụng Camera chụp ảnh vật thể.<br>- Mô hình AI (MobileNet) nhận diện và so khớp từ khóa để chấm điểm hoàn thành. |
| | | **Luyện viết số & Học toán (Math Canvas)** | - Thực hành viết số tay theo nét vẽ trên bảng vẽ thông minh.<br>- Mô hình AI (mnistCNN) nhận diện nét vẽ số tự động.<br>- Tham gia giải các phép tính cộng, trừ toán học bằng cách viết đáp án trực tiếp lên màn hình. |
| | | Xem bộ sưu tập và huy hiệu thành tích | - Xem danh sách các hình ảnh đồ vật thực tế bé đã tự tay chụp và nhận diện thành công.<br>- Xem các huy hiệu danh dự đã đạt được (như Tráng sĩ Toán học, Nhà thám hiểm...) để thúc đẩy động lực học tập. |

---

### 2.1.4 Đặc tả chi tiết Use Case "Thêm mới thẻ ghi nhớ"

*   **Tên Use Case:** Thêm mới thẻ ghi nhớ
*   **Tác nhân (Actor):** Quản trị viên (Admin / Phụ huynh)
*   **Mức:** 2 (Mức người dùng - User Goal)
*   **Điều kiện tiên quyết:** Quản trị viên đăng nhập vào hệ thống.
*   **Điều kiện kích hoạt:** Sau khi đã chọn một chủ đề, Quản trị viên chọn chức năng "Thêm mới thẻ ghi nhớ".
*   **Điều kiện thành công:** Thông tin của thẻ từ song ngữ mới được thêm vào CSDL.
*   **Điều kiện thất bại:** Hệ thống loại bỏ các thông tin đã thêm và quay lui lại bước trước.
*   **Chuỗi sự kiện chính:**
    Hệ thống hiển thị giao diện thêm mới thẻ ghi nhớ
    Quản trị viên nhập thông tin thẻ từ song ngữ, gồm:
    - Từ tiếng anh
    - Từ tiếng việt
    - Ảnh minh hoạ
    Quản trị viên nhấn lưu.
    Hệ thống kiểm tra thông tin và xác nhận hợp lệ.
    Hệ thống nhập thông tin mới vào CSDL.
    Hệ thống thông báo đã thêm mới thành công.

*   **Luồng sự kiện ngoại lệ:**
    *   **Ngoại lệ 1: Thiếu thông tin hoặc ảnh minh họa**
        - Hệ thống phát hiện thông tin nhập vào bị trống.
        - Hệ thống hiển thị cảnh báo lỗi thiếu thông tin.
        - Hệ thống giữ nguyên dữ liệu đã nhập và yêu cầu bổ sung.
    *   **Ngoại lệ 2: Thẻ ghi nhớ đã tồn tại**
        - Hệ thống phát hiện từ vựng đã tồn tại trong CSDL.
        - Hệ thống hiển thị cảnh báo lỗi trùng lặp từ vựng.
        - Hệ thống giữ nguyên dữ liệu đã nhập và yêu cầu chỉnh sửa.
    *   **Ngoại lệ 3: Ghi dữ liệu vào CSDL thất bại**
        - Hệ thống phát hiện lỗi ghi dữ liệu hoặc lỗi kết nối.
        - Hệ thống hiển thị thông báo lưu thất bại.
        - Hệ thống hủy bỏ thông tin đã thêm và quay lui lại bước trước.

---

### 2.1.5 Đặc tả chi tiết Use Case "Sửa thẻ ghi nhớ"

**Tên Usecase**
Sửa thẻ ghi nhớ

**Tác nhân**
Quản trị viên

**Mức**
2

**Tiền điều kiện**
Quản trị viên đăng nhập vào hệ thống và đang ở màn hình danh sách thẻ ghi nhớ.

**Điều kiện thất bại**
Hệ thống giữ nguyên thông tin thẻ ghi nhớ cũ và hủy bỏ các thay đổi đã thực hiện.

**Đảm bảo thành công**
Thông tin thay đổi của thẻ ghi nhớ đã được cập nhật thành công vào CSDL.

**Kích hoạt**
Quản trị viên chọn một thẻ ghi nhớ cần chỉnh sửa và nhấn nút "Sửa thẻ ghi nhớ".

**Luồng sự kiện chính**
Hệ thống hiển thị giao diện sửa thẻ ghi nhớ kèm theo thông tin hiện tại của thẻ
Quản trị viên thay đổi các thông tin thẻ từ song ngữ, gồm:
- Từ tiếng anh mới (nếu có)
- Từ tiếng việt mới (nếu có)
- Ảnh minh hoạ mới (nếu có)
Quản trị viên nhấn lưu.
Hệ thống kiểm tra thông tin và xác nhận hợp lệ.
Hệ thống cập nhật thông tin thay đổi vào CSDL.
Hệ thống thông báo đã cập nhật thành công.

**Luồng sự kiện ngoại lệ**
*   **Ngoại lệ 1: Thiếu thông tin hoặc ảnh minh họa**
    - Hệ thống phát hiện thông tin nhập vào bị trống.
    - Hệ thống hiển thị cảnh báo lỗi thiếu thông tin.
    - Hệ thống giữ nguyên dữ liệu đã sửa và yêu cầu bổ sung.
*   **Ngoại lệ 2: Thẻ ghi nhớ bị trùng với từ vựng khác đã tồn tại**
    - Hệ thống phát hiện từ vựng sửa mới trùng lặp với một từ vựng khác trong CSDL.
    - Hệ thống hiển thị cảnh báo lỗi trùng lặp từ vựng.
    - Hệ thống giữ nguyên dữ liệu đã sửa và yêu cầu chỉnh sửa.
*   **Ngoại lệ 3: Ghi dữ liệu vào CSDL thất bại**
    - Hệ thống phát hiện lỗi ghi dữ liệu hoặc lỗi kết nối.
    - Hệ thống hiển thị thông báo lưu thất bại.
    - Hệ thống hủy bỏ các thông tin đã sửa và khôi phục lại trạng thái cũ của thẻ.

---

### 2.1.6 Đặc tả chi tiết Use Case "Xóa thẻ ghi nhớ"

**Tên Usecase**
Xóa thẻ ghi nhớ

**Tác nhân**
Quản trị viên

**Mức**
2

**Tiền điều kiện**
Quản trị viên đăng nhập vào hệ thống và đang ở màn hình danh sách thẻ ghi nhớ.

**Điều kiện thất bại**
Hệ thống không thực hiện xóa thẻ và giữ nguyên dữ liệu CSDL.

**Đảm bảo thành công**
Thông tin thẻ ghi nhớ được xóa khỏi CSDL và tệp hình ảnh được gỡ bỏ khỏi bộ nhớ thiết bị.

**Kích hoạt**
Quản trị viên chọn một thẻ ghi nhớ cần xóa và nhấn nút "Xóa thẻ ghi nhớ".

**Luồng sự kiện chính**
Hệ thống hiển thị hộp thoại xác nhận xóa thẻ ghi nhớ
Quản trị viên nhấn nút xác nhận xóa.
Hệ thống kiểm tra tính hợp lệ của yêu cầu xóa.
Hệ thống thực hiện xóa thông tin thẻ trong CSDL và gỡ bỏ tệp ảnh liên quan.
Hệ thống thông báo đã xóa thành công và cập nhật danh sách hiển thị.

**Luồng sự kiện ngoại lệ**
*   **Ngoại lệ 1: Quản trị viên hủy bỏ yêu cầu xóa**
    - Hệ thống phát hiện Quản trị viên nhấn nút "Hủy" trên hộp thoại xác nhận.
    - Hệ thống đóng hộp thoại xác nhận.
    - Hệ thống quay lui lại màn hình danh sách thẻ và giữ nguyên dữ liệu.
*   **Ngoại lệ 2: Lỗi xóa dữ liệu trong CSDL hoặc xóa ảnh thất bại**
    - Hệ thống phát hiện lỗi ghi dữ liệu hoặc lỗi kết nối.
    - Hệ thống hiển thị thông báo xóa thất bại.
    - Hệ thống khôi phục dữ liệu thẻ và quay lui lại trạng thái cũ.
---

### 2.1.7 Đặc tả chi tiết Use Case "Thêm mới thử thách"

**Tên Usecase**
Thêm mới thử thách

**Tác nhân**
Quản trị viên

**Mức**
2

**Tiền điều kiện**
Quản trị viên đăng nhập vào hệ thống quản lý.

**Điều kiện thất bại**
Hệ thống loại bỏ các thông tin đã nhập lỗi và quay lại giao diện quản lý danh sách thử thách.

**Đảm bảo thành công**
Thông tin thử thách mới (tiêu đề, mô tả bằng hai ngôn ngữ Anh-Việt, biểu tượng SF Symbol, mã màu và từ khóa nhận diện) được lưu thành công lên Firebase Realtime Database.

**Kích hoạt**
Quản trị viên chọn chức năng "Thêm mới thử thách" từ trang quản lý danh sách thử thách.

**Luồng sự kiện chính**
Hệ thống hiển thị giao diện thêm mới thử thách
Quản trị viên nhập thông tin thử thách mới, gồm:
- Tiêu đề (tiếng Anh và tiếng Việt)
- Mô tả chi tiết (tiếng Anh và tiếng Việt)
- Tên biểu tượng (SF Symbol) và Màu nền biểu tượng (Mã màu Hex)
- Các từ khóa nhận diện AI (Keywords)
Quản trị viên nhấn lưu.
Hệ thống kiểm tra thông tin và xác nhận hợp lệ.
Hệ thống nhập thông tin mới vào Firebase Realtime Database.
Hệ thống thông báo đã thêm mới thành công.

**Luồng sự kiện ngoại lệ**
*   **Ngoại lệ 1: Thiếu thông tin bắt buộc**
    - Hệ thống phát hiện thông tin nhập vào bị trống.
    - Hệ thống hiển thị cảnh báo lỗi thiếu thông tin.
    - Hệ thống giữ nguyên dữ liệu đã nhập và yêu cầu bổ sung.
*   **Ngoại lệ 2: Ghi dữ liệu vào Firebase thất bại**
    - Hệ thống phát hiện lỗi ghi dữ liệu hoặc lỗi kết nối.
    - Hệ thống hiển thị thông báo lưu thất bại.
    - Hệ thống hủy bỏ thông tin đã thêm và quay lui lại bước trước.

---

### 2.1.8 Đặc tả chi tiết Use Case "Sửa thử thách"

**Tên Usecase**
Sửa thử thách

**Tác nhân**
Quản trị viên

**Mức**
2

**Tiền điều kiện**
Quản trị viên đăng nhập vào hệ thống quản lý và đang ở giao diện danh sách thử thách.

**Điều kiện thất bại**
Hệ thống giữ nguyên thông tin thử thách cũ và hủy bỏ các thay đổi đã thực hiện.

**Đảm bảo thành công**
Thông tin thay đổi của thử thách (tiêu đề, mô tả bằng hai ngôn ngữ Anh-Việt, biểu tượng SF Symbol, mã màu và từ khóa nhận diện) được cập nhật thành công lên Firebase Realtime Database.

**Kích hoạt**
Quản trị viên chọn một thử thách từ danh sách và nhấn nút "Sửa thử thách".

**Luồng sự kiện chính**
Hệ thống hiển thị giao diện sửa thử thách kèm theo các thông tin hiện tại của thử thách
Quản trị viên thay đổi các thông tin cần thiết của thử thách, gồm:
- Tiêu đề mới (tiếng Anh và tiếng Việt - nếu có)
- Mô tả chi tiết mới (tiếng Anh và tiếng Việt - nếu có)
- Tên biểu tượng (SF Symbol - nếu có) và Màu nền biểu tượng (Mã màu Hex - nếu có)
- Các từ khóa nhận diện AI mới (Keywords - nếu có)
Quản trị viên nhấn lưu.
Hệ thống kiểm tra thông tin và xác nhận hợp lệ.
Hệ thống cập nhật thông tin đã thay đổi vào Firebase Realtime Database.
Hệ thống thông báo đã cập nhật thành công.

**Luồng sự kiện ngoại lệ**
*   **Ngoại lệ 1: Thiếu thông tin bắt buộc**
    - Hệ thống phát hiện thông tin nhập vào bị trống.
    - Hệ thống hiển thị cảnh báo lỗi thiếu thông tin.
    - Hệ thống giữ nguyên dữ liệu đã sửa và yêu cầu bổ sung.
*   **Ngoại lệ 2: Ghi dữ liệu vào Firebase thất bại**
    - Hệ thống phát hiện lỗi ghi dữ liệu hoặc lỗi kết nối.
    - Hệ thống hiển thị thông báo lưu thất bại.
    - Hệ thống hủy bỏ thông tin đã sửa và khôi phục lại trạng thái cũ của thử thách.

---

### 2.1.9 Đặc tả chi tiết Use Case "Xóa thử thách"

**Tên Usecase**
Xóa thử thách

**Tác nhân**
Quản trị viên

**Mức**
2

**Tiền điều kiện**
Quản trị viên đăng nhập vào hệ thống quản lý và đang ở giao diện danh sách thử thách.

**Điều kiện thất bại**
Hệ thống không thực hiện xóa thử thách và giữ nguyên dữ liệu CSDL.

**Đảm bảo thành công**
Thông tin thử thách được gỡ bỏ hoàn toàn khỏi Firebase Realtime Database.

**Kích hoạt**
Quản trị viên chọn một thử thách cần xóa từ danh sách và nhấn nút "Xóa thử thách".

**Luồng sự kiện chính**
Hệ thống hiển thị hộp thoại xác nhận xóa thử thách.
Quản trị viên nhấn nút xác nhận xóa.
Hệ thống kiểm tra tính hợp lệ của yêu cầu xóa.
Hệ thống thực hiện xóa node thông tin thử thách tương ứng trên Firebase Realtime Database.
Hệ thống thông báo đã xóa thử thách thành công và cập nhật lại giao diện danh sách hiển thị.

**Luồng sự kiện ngoại lệ**
*   **Ngoại lệ 1: Quản trị viên hủy bỏ yêu cầu xóa**
    - Hệ thống phát hiện Quản trị viên nhấn nút "Hủy" trên hộp thoại xác nhận.
    - Hệ thống đóng hộp thoại xác nhận.
    - Hệ thống quay lại màn hình danh sách thử thách và giữ nguyên dữ liệu.
*   **Ngoại lệ 2: Lỗi kết nối hoặc Firebase xóa thất bại**
    - Hệ thống phát hiện lỗi mạng hoặc Firebase Realtime Database từ chối quyền ghi/xóa.
    - Hệ thống hiển thị thông báo lỗi xóa thất bại.
    - Hệ thống khôi phục lại trạng thái hiển thị của thử thách trên danh sách và quay lui lại trạng thái cũ.

---

### 2.1.10 Đặc tả chi tiết Use Case "Học từ vựng qua thẻ ghi nhớ"

**Tên Usecase**
Học từ vựng qua thẻ ghi nhớ

**Tác nhân**
Người dùng

**Mức**
1

**Điều kiện tiên quyết**
Người dùng đã mở màn hình chọn chủ đề học tập.

**Điều kiện kích hoạt**
Người dùng chọn một chủ đề học tập cụ thể từ giao diện danh sách chủ đề.

**Điều kiện thành công**
Kết quả lượt học từ vựng (danh sách các từ đã thuộc và các từ cần ôn tập) được ghi nhận và lưu trữ thành công vào tiến trình học tập cục bộ của người dùng.

**Điều kiện thất bại**
Không tải được danh sách thẻ ghi nhớ.
Phiên học bị gián đoạn hoặc người dùng thoát giữa chừng khiến tiến trình học tập không được lưu.

**Luồng sự kiện chính**
Hệ thống hiển thị giao diện học từ vựng với thẻ ghi nhớ đầu tiên (hiển thị hình ảnh minh họa và từ tiếng Anh).
Người dùng tương tác học tập với thẻ ghi nhớ:
- Lật thẻ - xem khái niệm: Người dùng chạm vào thẻ ghi nhớ để lật mặt sau, xem nghĩa tiếng Việt tương ứng và nghe phát âm tiếng Việt.
- Vuốt trái - đánh dấu là không nhớ/ không biết: Người dùng vuốt thẻ ghi nhớ sang bên trái để hệ thống ghi nhận từ vựng này chưa thuộc và đưa vào danh sách ôn tập.
- Bấm nút phát âm thanh: Người dùng nhấn nút loa trên giao diện để hệ thống phát lại âm thanh tiếng Anh hoặc tiếng Việt của thẻ hiện tại (tùy thuộc mặt thẻ đang hiển thị).
- Vuốt phải - đánh dấu là nhớ/ đã biết: Người dùng vuốt thẻ ghi nhớ sang bên phải để hệ thống ghi nhận từ vựng này đã được thuộc lòng.
Hệ thống ghi nhận kết quả ghi nhớ của thẻ hiện tại và tự động chuyển sang thẻ tiếp theo trong danh sách.
Người dùng hoàn thành việc học toàn bộ thẻ trong chủ đề.
Hệ thống hiển thị màn hình báo cáo kết quả lượt học.
Hệ thống lưu tiến trình học tập của người dùng.

**Luồng sự kiện ngoại lệ**
*   **Ngoại lệ 1: Chủ đề chưa có dữ liệu bài học**
    - Hệ thống phát hiện danh sách thẻ ghi nhớ của chủ đề đã chọn trống.
    - Hệ thống hiển thị thông báo chưa có dữ liệu thẻ ghi nhớ.
    - Hệ thống quay lui lại màn hình chọn chủ đề học tập.
*   **Ngoại lệ 2: Người dùng thoát khi chưa hoàn thành**
    - Người dùng nhấn nút quay lại trước khi học hết số thẻ ghi nhớ.
    - Hệ thống hiển thị hộp thoại xác nhận hủy phiên học hiện tại.
    - Người dùng chọn đồng ý thoát: Hệ thống đóng giao diện học tập, hủy bỏ tiến trình lượt học hiện tại và quay về màn hình chọn chủ đề.

---

### 2.1.11 Đặc tả chi tiết Use Case "Tập viết theo mẫu các chữ cái"

*   **Tên Usecase:** Tập viết theo mẫu các chữ cái
*   **Tác nhân:** Người dùng (Trẻ em)
*   **Mức:** 1 (Mức người dùng - User Goal)
*   **Điều kiện tiên quyết:** Người dùng đang ở giao diện danh sách chữ cái (ListAlphabet) và tiến hành chọn một chữ cái.
*   **Điều kiện kích hoạt:** Người dùng chạm vào thẻ chữ cái bất kỳ trên danh sách.
*   **Điều kiện thành công:** Người dùng hoàn thành quá trình luyện viết và quay lại màn hình danh sách với tiến trình được cập nhật (nếu có).
*   **Điều kiện thất bại:** Trình vẽ không thể hiển thị do lỗi tải tài nguyên mẫu chữ, hệ thống giữ nguyên trạng thái cũ của màn hình danh sách.

*   **Luồng sự kiện chính:**
    1. Hệ thống hiển thị giao diện tập viết với chữ mẫu tương ứng (mặc định hiển thị chữ in hoa, màu vẽ cam và nét vẽ cỡ trung bình).
    2. Người dùng thực hiện các tùy chọn thiết lập bảng vẽ (nếu muốn):
        - **Chọn loại ký tự (in hoa / viết thường):** Người dùng chạm vào Segmented Control để đổi kiểu chữ. Hệ thống xóa sạch toàn bộ nét vẽ hiện tại trên bảng vẽ và thay thế bằng khuôn mẫu tương ứng (chữ thường hoặc chữ hoa).
        - **Chọn màu vẽ hoặc kích thước nét vẽ:** Người dùng chạm chọn màu sắc mới trên khay màu hoặc thay đổi kích cỡ bút vẽ. Hệ thống ghi nhận thiết lập và áp dụng ngay lập tức cho nét vẽ tiếp theo.
        - **Xóa bảng vẽ:** Người dùng nhấn nút "Clear". Hệ thống xóa toàn bộ nét vẽ cũ để người dùng viết lại từ đầu.
    3. Người dùng di chuyển ngón tay trên bảng vẽ để tập viết theo khuôn chữ mẫu.
    4. Hệ thống liên tục nhận dạng cử chỉ vẽ và hiển thị nét vẽ thời gian thực trên màn hình theo màu sắc và kích thước nét vẽ đang cấu hình.
    5. Người dùng hoàn thành và nhấn nút quay lại (Back).
    6. Hệ thống đóng giao diện tập viết và đưa người dùng về giao diện danh sách chữ cái.

*   **Luồng sự kiện ngoại lệ:**
    *   **Ngoại lệ 1: Thiết bị không tải được tài nguyên hình ảnh chữ mẫu**
        - Hệ thống phát hiện lỗi không tìm thấy mẫu chữ tương ứng trong thư viện.
        - Hệ thống hiển thị cảnh báo lỗi tải dữ liệu.
        - Hệ thống tự động đóng giao diện tập viết và quay về màn hình danh sách chữ cái.

---

### 2.1.12 Đặc tả chi tiết Use Case "Tập viết chữ số 0 - 9"

*   **Tác nhân:** Người dùng (Trẻ em)
*   **Mức:** 1 (Mức người dùng - User Goal)
*   **Điều kiện tiên quyết:** Người dùng đang ở màn hình chính của phần học tập.
*   **Điều kiện kích hoạt:** Người dùng chạm chọn thẻ "Luyện Viết Chữ Số" trên màn hình học tập.
*   **Điều kiện thành công:** Người dùng chọn được chữ số muốn tập viết, thực hiện vẽ lên bảng đen, hệ thống nhận diện nét vẽ bằng mô hình AI và hiển thị kết quả.
*   **Điều kiện thất bại:** Giao diện bảng vẽ tập viết số lỗi không thể khởi tạo.

*   **Luồng sự kiện chính:**
    1. Hệ thống hiển thị giao diện tập viết chữ số gồm:
        - Một bảng vẽ đen ở trạng thái trống.
        - Thanh chọn chữ số từ 0 đến 9, mặc định chọn số 0.
        - Nhãn hướng dẫn hiển thị yêu cầu mặc định: “Bé hãy viết số 0 lên bảng vẽ nhé”.
        - Các nút chức năng điều khiển bảng vẽ: nút "Kiểm tra” màu xanh lá và nút "Xóa” màu đỏ.
        - Nút "Quay lại".
    2. Người dùng thực hiện các tùy chọn tương tác thiết lập hoặc bổ sung (nếu muốn):
        - **Chọn số muốn tập viết:** Người dùng chạm chọn một nút số bất kỳ từ 0 đến 9 trên thanh chọn số. Hệ thống chuyển trạng thái kích hoạt sang số đó (đổi màu nền nút sang màu chủ đạo và chữ trắng), cập nhật nhãn hướng dẫn hiển thị số mới, đồng thời tự động xóa sạch bảng vẽ đen và ẩn kết quả kiểm tra trước đó.
        - **Xóa nét vẽ để viết lại:** Người dùng chạm chọn nút "Clear". Hệ thống xóa sạch toàn bộ nét vẽ hiện tại trên bảng vẽ, reset bộ nhớ đệm nhận dạng và ẩn khung hiển thị kết quả kiểm tra.
    3. Người dùng sử dụng ngón tay thực hiện thao tác vẽ nét chữ số đã chọn lên bảng vẽ đen.
    4. Hệ thống liên tục ghi nhận tọa độ di chuyển ngón tay của người dùng và hiển thị nét vẽ theo thời gian thực trên bảng vẽ đen.
    5. Người dùng chạm chọn nút "Kiểm tra" để thực hiện nhận diện nét vẽ chữ số:
        - **Trường hợp bảng vẽ trống:** Hệ thống bỏ qua yêu cầu kiểm tra (không thực hiện hành động nhận dạng).
        - **Trường hợp bảng vẽ có nét vẽ:** Hệ thống trích xuất dữ liệu hình ảnh nét vẽ gửi sang mô hình AI. Mô hình tiến hành nhận dạng và trả về kết quả dự đoán:
            - **Nhánh kết quả chính xác:** Hệ thống hiển thị chữ số nhận dạng được với màu xanh lá tại vùng kết quả, kèm theo thông báo chúc mừng: "Đúng rồi! Bé làm tốt lắm”.
            - **Nhánh kết quả chưa chính xác:** Hệ thống hiển thị chữ số nhận dạng được với màu đỏ tại vùng kết quả, kèm theo thông điệp động viên: "Chưa đúng lắm, bé hãy thử viết lại nhé”.
    6. Người dùng hoàn thành quá trình luyện viết và chạm chọn nút Quay lại.
    7. Hệ thống đóng giao diện tập viết chữ số và đưa người dùng quay trở lại giao diện màn hình học tập chính.

*   **Luồng sự kiện ngoại lệ:**
    *   **Ngoại lệ: Không thể nhận dạng do nét viết không rõ ràng hoặc không hợp lệ**
        - Hệ thống phát hiện mô hình AI trả về kết quả có độ tin cậy quá thấp hoặc nét chữ không đủ thông tin để nhận dạng chữ số.
        - Hệ thống hiển thị hộp thoại cảnh báo: "Không thể nhận dạng”.
        - Người dùng tương tác trên hộp thoại cảnh báo:
            - Nếu người dùng chọn "Viết lại”: Hệ thống tự động xóa sạch bảng vẽ đen, đóng hộp thoại và đưa người dùng về trạng thái viết mới.
            - Nếu người dùng chọn "Đóng”: Hệ thống đóng hộp thoại và giữ nguyên nét viết hiện tại trên bảng vẽ.

---

### 2.1.13 Đặc tả chi tiết Use Case "Thử thách truy tìm đồ vật"

*   **Tác nhân:** Người dùng (Trẻ em)
*   **Mức:** 1 (Mức người dùng - User Goal)
*   **Điều kiện tiên quyết:** Người dùng đã đăng nhập hệ thống và đang ở màn hình khám phá (DiscoveryController).
*   **Điều kiện kích hoạt:** Người dùng chạm chọn thẻ "Game truy tìm kho báu" trên màn hình khám phá.
*   **Điều kiện thành công:** Người dùng hoàn thành thử thách bằng cách chụp ảnh hoặc tải ảnh vật thể chính xác; hệ thống ghi nhận trạng thái hoàn thành và lưu vật thể vào bộ sưu tập.
*   **Điều kiện thất bại:** Lỗi tải danh sách thử thách từ Firebase, hệ thống giữ nguyên giao diện cũ.

*   **Luồng sự kiện chính:**
    1. Người dùng chạm chọn "Truy tìm kho báu" trên màn hình khám phá.
    2. Hệ thống tải dữ liệu từ CSDL và hiển thị giao diện danh sách thử thách (biểu ngữ tiến trình, các thẻ thử thách, nút "Quay lại").
    3. Người dùng chạm chọn nút thực hiện trên một thẻ thử thách chưa hoàn thành.
    4. Hệ thống hiển thị hộp thoại lựa chọn phương thức nạp ảnh (Chụp ảnh/Chọn từ thư viện).
    5. Người dùng thực hiện nạp ảnh bằng cách chụp từ camera hoặc chọn ảnh từ thư viện thiết bị.
    6. Hệ thống thực hiện nhận dạng vật thể bằng mô hình AI.
    7. **Nhánh kết quả chính xác (Match):** Hệ thống ghi nhận hoàn thành vào CSDL, lưu ảnh vào bộ sưu tập, hiển thị thông báo thành công và cập nhật giao diện. Luồng quay lại bước lựa chọn tương tác.
    8. **Nhánh kết quả chưa chính xác (Not Match):** Hệ thống hiển thị thông báo chưa chính xác kèm gợi ý thử lại. Người dùng chọn đóng hoặc thử lại. Luồng quay lại bước lựa chọn tương tác.
    9. Người dùng chạm chọn nút "Quay lại" trên màn hình danh sách thử thách.
    10. Hệ thống đóng giao diện danh sách thử thách và đưa người dùng quay về màn hình khám phá chính.

*   **Luồng sự kiện ngoại lệ:**
    *   **Ngoại lệ 1: Lỗi nạp dữ liệu từ CSDL**
        - Hệ thống phát hiện sự cố kết nối mạng hoặc lỗi CSDL.
        - Hệ thống hiển thị thông báo lỗi tải dữ liệu và đưa người dùng quay về màn hình khám phá chính.
    *   **Ngoại lệ 2: Người dùng hủy bỏ thao tác nạp ảnh**
        - Người dùng nhấn nút hủy bỏ khi camera hoặc thư viện ảnh đang mở.
        - Hệ thống đóng màn hình camera/thư viện ảnh và quay về màn hình danh sách thử thách.

---

### 2.1.14 Đặc tả chi tiết Use Case "Thử thách giải toán nhanh"

*   **Tên Usecase:** Thử thách giải toán nhanh
*   **Tác nhân:** Người dùng (Trẻ em)
*   **Mức:** 1 (Mức người dùng - User Goal)
*   **Điều kiện tiên quyết:** Người dùng đang ở màn hình học tập chính.
*   **Điều kiện kích hoạt:** Người dùng chọn "Thử thách giải toán nhanh" từ giao diện học tập.
*   **Điều kiện thành công:** Người dùng giải chính xác toàn bộ 10 cấp độ thử thách phép toán, hệ thống ghi nhận thành tích và cập nhật tiến trình thành công.
*   **Điều kiện thất bại:** Hết thời gian làm bài ở chế độ nâng cao mà người dùng chưa hoàn thành, hoặc người dùng thoát giữa chừng khiến tiến trình bị hủy bỏ.

*   **Luồng sự kiện chính:**
    1. Người dùng chọn chế độ thử thách (Cơ bản hoặc Nâng cao).
    2. Hệ thống khởi tạo trò chơi với danh sách 10 phép tính ngẫu nhiên.
    3. Hệ thống hiển thị phép tính hiện tại, cấp độ, bảng vẽ và các nút chức năng.
    4. Nếu ở chế độ Nâng cao, hệ thống bắt đầu bộ đếm thời gian.
    5. Người dùng viết đáp án (chữ số từ 0-9) lên bảng vẽ.
    6. Hệ thống nhận dạng nét vẽ và hiển thị nét viết theo thời gian thực.
    7. Người dùng chọn "Kiểm tra".
    8. Hệ thống thực hiện nhận dạng chữ số và so sánh với kết quả đúng của phép tính.
    9. **Nhánh kết quả đúng:** Hệ thống hiển thị đáp án đúng, lưu trạng thái hoàn thành cấp độ và hiển thị nút "Tiếp theo".
    10. **Nhánh kết quả sai:** Hệ thống hiển thị đáp án sai và tự động xóa bảng vẽ để người dùng viết lại.
    11. Người dùng chọn "Tiếp theo".
    12. Hệ thống chuyển sang cấp độ tiếp theo và lặp lại quá trình từ bước 3.
    13. Khi người dùng hoàn thành cấp độ 10:
        - Hệ thống kết thúc trò chơi và lưu thành tích.
        - Hiển thị thông báo hoàn thành.

---

### 2.1.15 Đặc tả chi tiết Use Case "Xem Thống Kê Tiến Độ Học"

*   **Tên Usecase:** Xem Thống Kê Tiến Độ Học
*   **Tác nhân:** Người dùng (Trẻ em hoặc Phụ huynh)
*   **Mức:** 1 (Mức người dùng - User Goal)
*   **Điều kiện tiên quyết:** Người dùng đã đăng nhập thành công vào ứng dụng.
*   **Điều kiện kích hoạt:** Người dùng chạm chọn mục "Thành tích" trên màn hình giao diện.
*   **Điều kiện thành công:** Hệ thống hiển thị đầy đủ các chỉ số (tổng thời gian học, số sao tích lũy, phần trăm hoàn thành mục tiêu) dưới dạng các thẻ chỉ số và biểu đồ cột sinh động. Người dùng có thể chuyển đổi hiển thị giữa các bộ lọc thời gian.
*   **Điều kiện thất bại:** Không thể tải dữ liệu tiến độ từ cơ sở dữ liệu cục bộ hoặc giao diện bị lỗi khởi tạo.

*   **Luồng sự kiện chính:**
    1. Người dùng chạm chọn mục "Thành tích".
    2. Hệ thống yêu cầu dữ liệu tiến độ học tập từ cơ sở dữ liệu cục bộ (SQLite/UserDefaults).
    3. Hệ thống tính toán các chỉ số: tổng thời gian học, số sao tích lũy và phần trăm hoàn thành mục tiêu.
    4. Hệ thống hiển thị giao diện "Thành tích" gồm:
        - Các thẻ chỉ số tương ứng.
        - Biểu đồ cột thể hiện tiến độ học tập.
        - Nút chuyển đổi thời gian (mặc định hiển thị theo chế độ "Hàng ngày").
    5. Người dùng chạm chọn thay đổi bộ lọc thời gian qua lại giữa "Hàng tuần" và "Hàng ngày".
    6. Hệ thống truy vấn dữ liệu theo khoảng thời gian tương ứng, tính toán lại và cập nhật biểu đồ cột và các thẻ số liệu.
    7. Người dùng kết thúc bằng cách nhấn nút "Quay lại" hoặc rời khỏi màn hình.
    8. Hệ thống đóng giao diện thống kê thành tích và quay về màn hình trước đó.

*   **Luồng sự kiện ngoại lệ:**
    *   **Ngoại lệ: Không có dữ liệu (Người dùng mới)**
        - Hệ thống phát hiện không có bất kỳ bản ghi học tập nào trong cơ sở dữ liệu cục bộ.
        - Hệ thống hiển thị giao diện trạng thái trống (Empty State) kèm thông điệp nhắc nhở: "Bạn chưa có thời gian học nào, bắt đầu luyện tập ngay!".
        - Người dùng có thể chạm chọn nút hành động để chuyển hướng nhanh tới màn hình danh sách bài học/luyện tập.
        - Hệ thống đóng giao diện thống kê và chuyển hướng người dùng tới màn hình học tập tương ứng.

---

### 2.1.16 Biểu đồ hoạt động (Activity Diagram)

#### 1. Biểu đồ hoạt động tính năng "Thêm mới thẻ ghi nhớ"
Biểu đồ hoạt động mô tả quy trình các bước nghiệp vụ diễn ra tuyến tính khi Quản trị viên thêm một thẻ từ vựng song ngữ mới vào ứng dụng:
- Bắt đầu: Quản trị viên chọn chức năng "Thêm mới thẻ ghi nhớ".
- Hệ thống hiển thị biểu mẫu trống.
- Quản trị viên nhập từ tiếng Anh, tiếng Việt và chọn ảnh minh họa từ camera hoặc thư viện thiết bị.
- Quản trị viên nhấn Lưu.
- Hệ thống thực hiện kiểm tra nghiệp vụ và xác thực dữ liệu hợp lệ.
- Hệ thống tải tệp ảnh lên bộ nhớ cục bộ (`FileManager`) và lưu metadata vào CSDL (`UserDefaults`).
- Hệ thống hiển thị thông báo thành công và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_add_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_add_flashcard.drawio).

#### 2. Biểu đồ hoạt động tính năng "Sửa thẻ ghi nhớ"
Quy trình hoạt động chỉnh sửa thông tin thẻ từ song ngữ cũ diễn ra tuần tự như sau:
- Bắt đầu: Quản trị viên chọn một thẻ ghi nhớ hiện có trên danh sách và nhấn nút "Sửa".
- Hệ thống tải dữ liệu hiện tại và hiển thị biểu mẫu chỉnh sửa.
- Quản trị viên thay đổi từ tiếng Anh, tiếng Việt hoặc cập nhật ảnh minh họa mới.
- Quản trị viên nhấn Lưu.
- Hệ thống kiểm tra tính hợp lệ của dữ liệu đã sửa.
- Hệ thống lưu các thay đổi mới vào CSDL (cập nhật thông tin và tệp ảnh).
- Hệ thống thông báo cập nhật thành công và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_edit_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_edit_flashcard.drawio).

#### 3. Biểu đồ hoạt động tính năng "Xóa thẻ ghi nhớ"
Quy trình hoạt động xóa thẻ ghi nhớ song ngữ được thực hiện tuần tự như sau:
- Bắt đầu: Quản trị viên chọn một thẻ ghi nhớ hiện có trên danh sách và nhấn nút "Xóa".
- Hệ thống hiển thị hộp thoại cảnh báo và yêu cầu xác nhận xóa thẻ.
- Quản trị viên nhấn nút xác nhận đồng ý xóa.
- Hệ thống kiểm tra và thực hiện xóa thông tin thẻ khỏi CSDL, đồng thời gỡ bỏ tệp tin hình ảnh tương ứng trên thiết bị di động.
- Hệ thống hiển thị thông báo xóa thành công, tự động cập nhật lại danh sách trên màn hình giao diện chính và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_delete_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_delete_flashcard.drawio).

#### 4. Biểu đồ hoạt động tính năng "Thêm mới thử thách"
Quy trình hoạt động khi Quản trị viên khởi tạo và xuất bản một thử thách săn tìm đồ vật mới lên hệ thống:
- Bắt đầu: Quản trị viên chọn chức năng "Thêm mới thử thách" từ giao diện quản trị.
- Hệ thống hiển thị biểu mẫu trống.
- Quản trị viên nhập các thông tin của thử thách mới (tiêu đề, mô tả bằng hai ngôn ngữ Anh-Việt, mã màu nền và các từ khóa AI tương ứng để MobileNet đối chiếu).
- Quản trị viên nhấn Lưu.
- Hệ thống thực hiện kiểm tra và xác nhận tính hợp lệ của dữ liệu đầu vào.
- Hệ thống lưu thông tin thử thách mới vào cơ sở dữ liệu.
- Hệ thống thông báo thêm mới thành công, hiển thị thử thách mới lên màn hình danh sách và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_add_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_add_mission.drawio).

#### 5. Biểu đồ hoạt động tính năng "Sửa thử thách"
Quy trình hoạt động khi Quản trị viên cập nhật thông tin thử thách đã tồn tại trên hệ thống:
- Bắt đầu: Quản trị viên chọn một thử thách cần chỉnh sửa từ danh sách và nhấn nút "Sửa".
- Hệ thống tải dữ liệu hiện tại của thử thách và hiển thị biểu mẫu chỉnh sửa.
- Quản trị viên thay đổi các thông tin mong muốn (tiêu đề, mô tả, biểu tượng/mã màu nền hoặc các từ khóa AI).
- Quản trị viên nhấn Lưu.
- Hệ thống thực hiện kiểm tra và xác nhận tính hợp lệ của dữ liệu đầu vào.
- Hệ thống cập nhật các thay đổi mới vào Firebase Realtime Database.
- Hệ thống thông báo cập nhật thành công, tự động cập nhật lại danh sách trên màn hình giao diện quản lý và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_edit_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_edit_mission.drawio).

#### 6. Biểu đồ hoạt động tính năng "Xóa thử thách"
Quy trình hoạt động khi Quản trị viên thực hiện xóa một thử thách khỏi hệ thống:
- Bắt đầu: Quản trị viên chọn một thử thách cần xóa từ danh sách và nhấn nút "Xóa".
- Hệ thống hiển thị hộp thoại cảnh báo và yêu cầu xác nhận xóa thử thách.
- Quản trị viên nhấn nút xác nhận đồng ý xóa.
- Hệ thống thực hiện xóa node thông tin thử thách tương ứng trên Firebase Realtime Database.
- Hệ thống hiển thị thông báo xóa thành công, tự động cập nhật lại danh sách trên giao diện quản trị và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_delete_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_delete_mission.drawio).

#### 7. Biểu đồ hoạt động tính năng "Học từ vựng qua thẻ ghi nhớ"
Quy trình hoạt động khi Người dùng (bé) học từ vựng qua thẻ ghi nhớ:
- Bắt đầu: Người dùng chọn một chủ đề học tập từ giao diện danh sách chủ đề.
- Hệ thống hiển thị thẻ ghi nhớ đầu tiên (hình ảnh minh họa + từ tiếng Anh) và tự động phát âm thanh tiếng Anh.
- Người dùng tương tác học tập (lật thẻ để xem khái niệm nghĩa tiếng Việt, nghe lại phát âm thanh).
- Người dùng vuốt thẻ (vuốt trái: chưa thuộc/ ôn tập, vuốt phải: đã thuộc) để hệ thống đánh dấu trạng thái ghi nhớ.
- Hệ thống ghi nhận kết quả và tự động chuyển sang thẻ tiếp theo trong hàng đợi cho đến hết danh sách thẻ.
- Hệ thống hiển thị màn hình báo cáo kết quả lượt học (thống kê số thẻ đã nhớ và cần ôn tập).
- Hệ thống lưu kết quả tiến trình học tập cục bộ của người dùng và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_learn_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/activity_diagram_learn_flashcard.drawio).

#### 8. Biểu đồ hoạt động tính năng "Tập viết theo mẫu các chữ cái"
Quy trình hoạt động tập viết theo mẫu chữ cái của Người dùng (bé) diễn ra như sau:
- Bắt đầu: Người dùng chọn thẻ chữ cái bất kỳ trên danh sách.
- Hệ thống thực hiện kiểm tra nạp dữ liệu mẫu chữ.
- Nếu tải thất bại: Hệ thống hiển thị cảnh báo lỗi tải dữ liệu, tự động đóng giao diện tập viết và quay về màn hình danh sách.
- Nếu tải thành công: Hệ thống hiển thị màn hình tập viết với chữ mẫu tương ứng (mặc định in hoa, màu vẽ cam, nét bút cỡ trung).
- Người dùng thực hiện các tùy chọn thiết lập bảng vẽ (chọn in hoa/thường, chọn màu/nét vẽ, hoặc nhấn xóa bảng vẽ) hoặc thực hiện nét vẽ trên bảng đen.
- Hệ thống áp dụng thiết lập tương ứng hoặc ghi nhận tọa độ vẽ và hiển thị nét vẽ theo thời gian thực.
- Người dùng nhấn nút quay lại (Back).
- Hệ thống đóng giao diện tập viết chữ cái, trở về màn hình danh sách chữ cái và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_draw_letter.drawio](file:///Users/mitie/tlu-app/KidX/docs/AD/activity_diagram_draw_letter.drawio).

#### 9. Biểu đồ hoạt động tính năng "Tập viết chữ số 0 - 9"
Quy trình hoạt động tập viết chữ số từ 0 đến 9 của Người dùng (bé) diễn ra theo cơ chế vòng lặp tương tác như sau:
- Bắt đầu: Người dùng chọn thẻ "Luyện Viết Chữ Số" trên màn hình học tập.
- Hệ thống hiển thị giao diện tập viết số (mặc định chọn số 0, bảng vẽ trống, hiển thị hướng dẫn viết số 0).
- Hệ thống đi vào điểm quyết định lựa chọn tương tác của người dùng:
  - **Chọn số mới:** Người dùng chọn một nút số từ 0 đến 9. Hệ thống cập nhật chữ số chọn, nhãn hướng dẫn mới, đổi màu nút kích hoạt, tự động xóa sạch bảng vẽ đen và ẩn kết quả cũ. Luồng quay lại điểm chọn tương tác.
  - **Nhấn nút Clear:** Người dùng chạm chọn nút "Clear". Hệ thống xóa sạch toàn bộ nét vẽ hiện tại trên bảng vẽ, reset trạng thái nhận dạng và ẩn khung kết quả. Luồng quay lại điểm chọn tương tác.
  - **Vẽ và nhấn Kiểm tra:** Người dùng vẽ nét số trên bảng vẽ đen và chọn "Kiểm tra". Hệ thống trích xuất pixel buffer nét vẽ chuyển qua mô hình AI (mnistCNN) để nhận diện:
    - Nếu kết quả nhận dạng không tin cậy (độ tin cậy quá thấp): Hệ thống hiển thị cảnh báo "Không thể nhận dạng". Người dùng chọn "Viết lại" (hệ thống xóa bảng vẽ, đóng cảnh báo và quay lại điểm chọn tương tác) hoặc chọn "Đóng" (hệ thống đóng cảnh báo, giữ nguyên nét vẽ và quay lại điểm chọn tương tác).
    - Nếu kết quả nhận dạng hợp lệ: Hệ thống so khớp với chữ số đang chọn. Nếu khớp (Đúng), hiển thị số màu xanh lá kèm thông điệp chúc mừng. Nếu không khớp (Sai), hiển thị số màu đỏ kèm thông điệp động viên. Luồng quay lại điểm chọn tương tác.
  - **Nhấn Quay lại:** Người dùng chạm chọn nút Quay lại (Back). Hệ thống đóng màn hình tập viết và đưa người dùng trở lại giao diện học tập chính.
- Kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_draw_number.drawio](file:///Users/mitie/tlu-app/KidX/docs/AD/activity_diagram_draw_number.drawio).

#### 10. Biểu đồ hoạt động tính năng "Thử thách truy tìm đồ vật"
Quy trình hoạt động trong thử thách truy tìm kho báu của Người dùng (bé) diễn ra theo cơ chế vòng lặp tương tác như sau:
- Bắt đầu: Người dùng chọn thẻ "Truy tìm kho báu" trên giao diện khám phá.
- Hệ thống tải dữ liệu nhiệm vụ từ CSDL và đi vào điểm quyết định:
  - **Tải dữ liệu thất bại:** Hệ thống hiển thị thông báo lỗi tải dữ liệu, kết thúc luồng và quay về màn hình khám phá chính.
  - **Tải dữ liệu thành công:** Hệ thống hiển thị giao diện danh sách thử thách (biểu ngữ tiến trình và danh sách nhiệm vụ) và đi vào điểm quyết định lựa chọn tương tác của người dùng:
    - **Nhấn Quay lại:** Người dùng chạm chọn nút Quay lại. Hệ thống đóng giao diện danh sách thử thách, đưa người dùng quay lại màn hình khám phá chính và kết thúc luồng.
    - **Thực hiện thử thách:** Người dùng chọn một thẻ thử thách chưa hoàn thành. Hệ thống hiển thị lựa chọn nguồn ảnh. Người dùng chụp ảnh hoặc chọn ảnh từ thư viện (hoặc hủy bỏ thao tác nạp ảnh và quay lại điểm chọn tương tác). Hệ thống nạp ảnh và nhận diện vật thể bằng mô hình AI:
      - Nếu kết quả nhận dạng đúng (Match): Hệ thống ghi nhận hoàn thành vào CSDL, lưu ảnh vào bộ sưu tập, hiển thị thông báo chúc mừng thành công, cập nhật tiến trình và giao diện. Luồng quay lại điểm chọn tương tác.
      - Nếu kết quả nhận dạng sai (Not Match): Hệ thống hiển thị thông báo chưa chính xác kèm gợi ý thử lại. Người dùng chọn đóng hoặc thử lại. Luồng quay lại điểm chọn tương tác.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_treasure_hunt.drawio](file:///Users/mitie/tlu-app/KidX/docs/AD/activity_diagram_treasure_hunt.drawio).

#### 11. Biểu đồ hoạt động tính năng "Thử thách giải toán nhanh"
Quy trình hoạt động trong thử thách giải toán nhanh của Người dùng (bé) diễn ra theo cơ chế vòng lặp tương tác như sau:
- Bắt đầu: Người dùng chọn chế độ thử thách (Cơ bản / Nâng cao).
- Hệ thống khởi tạo trò chơi với danh sách 10 phép tính ngẫu nhiên.
- Hệ thống hiển thị phép tính hiện tại, cấp độ, bảng vẽ và các nút chức năng. Nếu ở chế độ Nâng cao, hệ thống khởi chạy bộ đếm thời gian.
- Người dùng viết đáp án (chữ số từ 0-9) trên bảng vẽ và chọn "Kiểm tra".
- Hệ thống nhận dạng nét viết bằng mô hình AI và so sánh với đáp án đúng:
  - **Nhánh kết quả đúng:** Hệ thống hiển thị đáp án đúng, lưu trạng thái hoàn thành cấp độ và hiển thị nút "Tiếp theo". Người dùng nhấn "Tiếp theo", hệ thống đi vào điểm quyết định:
    - Nếu chưa hoàn thành cấp độ 10: Hệ thống chuyển sang cấp độ tiếp theo, quay lại hiển thị phép tính mới.
    - Nếu đã hoàn thành cấp độ 10: Hệ thống kết thúc trò chơi, lưu thành tích, hiển thị thông báo hoàn thành và kết thúc luồng.
  - **Nhánh kết quả sai:** Hệ thống hiển thị đáp án sai và tự động xóa bảng vẽ để người dùng thực hiện viết lại. Luồng quay lại hiển thị phép tính hiện tại để viết lại.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_calculate.drawio](file:///Users/mitie/tlu-app/KidX/docs/AD/activity_diagram_calculate.drawio).

#### 12. Biểu đồ hoạt động tính năng "Xem thống kê tiến độ học"
Quy trình hoạt động hiển thị thống kê tiến độ học tập của Người dùng diễn ra tuần tự như sau:
- Bắt đầu: Người dùng chọn thẻ "Thành tích".
- Hệ thống thực hiện tải dữ liệu học tập từ CSDL cục bộ và kiểm tra:
  - Nếu không có dữ liệu (người dùng mới): Hệ thống hiển thị trạng thái trống kèm lời nhắc "Bạn chưa có thời gian học nào, bắt đầu luyện tập ngay!". Người dùng có thể chạm nút chuyển tới màn hình luyện tập để hệ thống điều hướng và kết thúc luồng.
  - Nếu có dữ liệu: Hệ thống tính toán các chỉ số học tập, vẽ và hiển thị các thẻ số liệu và biểu đồ cột trên màn hình.
- Hệ thống đi vào điểm quyết định lựa chọn tương tác của người dùng:
  - **Chuyển bộ lọc:** Người dùng chọn thay đổi bộ lọc thời gian giữa "Hàng ngày" và "Hàng tuần". Hệ thống cập nhật lại dữ liệu và vẽ lại biểu đồ tương ứng. Luồng quay lại điểm chọn tương tác.
  - **Quay lại:** Người dùng chạm chọn nút Quay lại. Hệ thống đóng màn hình thống kê, quay về giao diện cũ và kết thúc luồng.

*Lưu ý:* File thiết kế chi tiết đã được lưu tại [activity_diagram_achieve_stats.drawio](file:///Users/mitie/tlu-app/KidX/docs/AD/activity_diagram_achieve_stats.drawio).

---

## 2.2 Tạo biểu đồ lớp phân tích (Analysis Class Diagram)

### 2.2.1 Giới thiệu về lớp phân tích
Trong phân tích và thiết kế hệ thống hướng đối tượng theo mô hình Robustness Analysis, các lớp của hệ thống được phân chia thành 3 nhóm chức năng chính (Stereotypes):
1. **Lớp Biên (Boundary Class - «boundary»):** Đại diện cho các thành phần giao diện người dùng (UI) tương tác trực tiếp với Tác nhân (Actor). Lớp biên tiếp nhận các sự kiện đầu vào từ người dùng và hiển thị kết quả xử lý từ hệ thống.
2. **Lớp Điều khiển (Control Class - «control»):** Chứa logic nghiệp vụ, điều phối luồng thông tin giữa lớp biên và lớp thực thể. Lớp này chịu trách nhiệm kiểm tra tính hợp lệ của dữ liệu, gọi các service lưu trữ và xử lý logic của Use Case.
3. **Lớp Thực thể (Entity Class - «entity»):** Đại diện cho các đối tượng dữ liệu lõi của hệ thống được lưu trữ lâu dài trong cơ sở dữ liệu (ví dụ: thông tin thẻ ghi nhớ, kết quả học tập).

### 2.2.2 Biểu đồ lớp phân tích Use Case "Thêm mới thẻ ghi nhớ"

---

title: 2.2.2. Biểu đồ lớp phân tích chức năng thêm mới thẻ ghi nhớ

---

```mermaid
classDiagram
direction LR

%% Mau BCE: Boundary la GiaoDien, Control la HeThong, Entity gom du lieu va dich vu ngoai

class GiaoDienThemMoiTheGhiNho {
  <<Boundary>>
  +nhapTuTiengAnh()
  +nhapTuTiengViet()
  +chonAnhMinhHoa()
  +clickLuuThongTin()
  +hienThiThongBao()
  +quayLaiTrangTruoc()
}

class HeThong {
  <<Control>>
  +kiemTraDuLieuHopLe()
  +taoTheMoi()
  +luuTheVaoCSDL()
  +capNhatDanhSachHienThi()
}

class TheGhiNho {
  <<Entity>>
  -maThe
  -tuTiengAnh
  -tuTiengViet
  -duongDanAnh
  -maChuDe
  -ngayTao
  +taoThe()
  +layThongTinThe()
  +capNhatThe()
}

class ChuDeHocTap {
  <<Entity>>
  -maChuDe
  -tenChuDe
  -soLuongThe
  +themTheVaoChuDe()
  +capNhatSoLuong()
}

class DichVuLuuTru {
  <<Entity>>
  -duongDanThuMuc
  -keyUserDefaults
  +luuTepAnhCucBo()
  +luuMetadataDatabase()
  +dongBoFirebase()
}

GiaoDienThemMoiTheGhiNho -- HeThong
HeThong -- TheGhiNho
HeThong -- ChuDeHocTap
HeThong -- DichVuLuuTru
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được cập nhật và đồng bộ dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram.drawio](file:///Users/mitie/tlu-app/KidX/docs/analysis_class_diagram.drawio) tương ứng với cấu trúc trên. Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.3 Biểu đồ lớp phân tích Use Case "Sửa thẻ ghi nhớ"

---

title: 2.2.3. Biểu đồ lớp phân tích chức năng sửa thẻ ghi nhớ

---

```mermaid
classDiagram
direction LR

%% Mau BCE: Boundary la GiaoDien, Control la HeThong, Entity gom du lieu va dich vu ngoai

class GiaoDienSuaTheGhiNho {
  <<Boundary>>
  +hienThiThongTinThe()
  +nhapThongTinChinhSua()
  +chonAnhMoi()
  +clickLuuThayDoi()
  +hienThiThongBao()
  +quayLaiTrangTruoc()
}

class HeThong {
  <<Control>>
  +kiemTraDuLieuHopLe()
  +layThongTinTheTuCSDL()
  +capNhatThongTinThe()
  +capNhatDanhSachHienThi()
}

class TheGhiNho {
  <<Entity>>
  -maThe
  -tuTiengAnh
  -tuTiengViet
  -duongDanAnh
  -maChuDe
  -ngayTao
  +taoThe()
  +layThongTinThe()
  +capNhatThe()
}

class ChuDeHocTap {
  <<Entity>>
  -maChuDe
  -tenChuDe
  -soLuongThe
  +themTheVaoChuDe()
  +capNhatSoLuong()
}

class DichVuLuuTru {
  <<Entity>>
  -duongDanThuMuc
  -keyUserDefaults
  +luuTepAnhCucBo()
  +luuMetadataDatabase()
  +dongBoFirebase()
}

GiaoDienSuaTheGhiNho -- HeThong
HeThong -- TheGhiNho
HeThong -- ChuDeHocTap
HeThong -- DichVuLuuTru
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_edit.drawio](file:///Users/mitie/tlu-app/KidX/docs/analysis_class_diagram_edit.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.4 Biểu đồ lớp phân tích Use Case "Xóa thẻ ghi nhớ"

---

title: 2.2.4. Biểu đồ lớp phân tích chức năng xóa thẻ ghi nhớ

---

```mermaid
classDiagram
direction LR

%% Mau BCE: Boundary la GiaoDien, Control la HeThong, Entity gom du lieu va dich vu ngoai

class GiaoDienXoaTheGhiNho {
  <<Boundary>>
  +hienThiThongBaoXacNhan()
  +clickXacNhanXoa()
  +clickHuyXoa()
  +hienThiThongBaoKetQua()
}

class HeThong {
  <<Control>>
  +yeuCauXoaThe()
  +xoaTheTuCSDL()
  +capNhatDanhSachHienThi()
}

class TheGhiNho {
  <<Entity>>
  -maThe
  -tuTiengAnh
  -tuTiengViet
  -duongDanAnh
  -maChuDe
  -ngayTao
  +xoaThe()
}

class ChuDeHocTap {
  <<Entity>>
  -maChuDe
  -tenChuDe
  -soLuongThe
  +giamSoLuongThe()
}

class DichVuLuuTru {
  <<Entity>>
  -duongDanThuMuc
  -keyUserDefaults
  +xoaTepAnhCucBo()
  +xoaMetadataDatabase()
  +dongBoFirebase()
}

GiaoDienXoaTheGhiNho -- HeThong
HeThong -- TheGhiNho
HeThong -- ChuDeHocTap
HeThong -- DichVuLuuTru
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_delete.drawio](file:///Users/mitie/tlu-app/KidX/docs/analysis_class_diagram_delete.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.5 Biểu đồ lớp phân tích Use Case "Thêm mới thử thách"

---

title: 2.2.5. Biểu đồ lớp phân tích chức năng thêm mới thử thách

---

```mermaid
classDiagram
direction LR

%% Mau BCE: Boundary la GiaoDien, Control la HeThong, Entity gom du lieu va dich vu ngoai

class GiaoDienThemMoiThuThach {
  <<Boundary>>
  +nhapTieuDe()
  +nhapMoTa()
  +nhapMaMau()
  +nhapTuKhoaAI()
  +clickLuuThongTin()
  +hienThiThongBao()
  +quayLaiTrangTruoc()
}

class HeThong {
  <<Control>>
  +kiemTraDuLieuHopLe()
  +taoThuThachMoi()
  +luuThuThachVaoCSDL()
  +capNhatDanhSachHienThi()
}

class ThuThach {
  <<Entity>>
  -maThuThach
  -tieuDeEn
  -tieuDeVi
  -moTaEn
  -moTaVi
  -maMauHex
  -danhSachTuKhoa
  +taoThuThach()
  +layThongTinThuThach()
}

class DichVuCSDL {
  <<Entity>>
  -urlRealtimeDatabase
  -nodeRoot
  +ghiThuThachMoi()
  +dongBoDuLieu()
}

GiaoDienThemMoiThuThach -- HeThong
HeThong -- ThuThach
HeThong -- DichVuCSDL
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_add_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/analysis_class_diagram_add_mission.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.6 Biểu đồ lớp phân tích Use Case "Sửa thử thách"

---

title: 2.2.6. Biểu đồ lớp phân tích chức năng sửa thử thách

---

```mermaid
classDiagram
direction LR

%% Mau BCE: Boundary la GiaoDien, Control la HeThong, Entity gom du lieu va dich vu ngoai

class GiaoDienSuaThuThach {
  <<Boundary>>
  +hienThiThongTinThuThach()
  +nhapThongTinChinhSua()
  +clickLuuThayDoi()
  +hienThiThongBao()
  +quayLaiTrangTruoc()
}

class HeThong {
  <<Control>>
  +layThongTinThuThachTuCSDL()
  +kiemTraDuLieuHopLe()
  +capNhatThongTinThuThach()
  +capNhatDanhSachHienThi()
}

class ThuThach {
  <<Entity>>
  -maThuThach
  -tieuDeEn
  -tieuDeVi
  -moTaEn
  -moTaVi
  -maMauHex
  -danhSachTuKhoa
  +taoThuThach()
  +layThongTinThuThach()
  +capNhatThuThach()
}

class DichVuCSDL {
  <<Entity>>
  -urlRealtimeDatabase
  -nodeRoot
  +ghiThuThachMoi()
  +capNhatThuThachCSDL()
  +dongBoDuLieu()
}

GiaoDienSuaThuThach -- HeThong
HeThong -- ThuThach
HeThong -- DichVuCSDL
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_edit_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/analysis_class_diagram_edit_mission.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.7 Biểu đồ lớp phân tích Use Case "Xóa thử thách"

---

title: 2.2.7. Biểu đồ lớp phân tích chức năng xóa thử thách

---

```mermaid
classDiagram
direction LR

%% Mau BCE: Boundary la GiaoDien, Control la HeThong, Entity gom du lieu va dich vu ngoai

class GiaoDienXoaThuThach {
  <<Boundary>>
  +hienThiThongBaoXacNhan()
  +clickXacNhanXoa()
  +clickHuyXoa()
  +hienThiThongBaoKetQua()
}

class HeThong {
  <<Control>>
  +yeuCauXoaThuThach()
  +xoaThuThachTuCSDL()
  +capNhatDanhSachHienThi()
}

class ThuThach {
  <<Entity>>
  -maThuThach
  -tieuDeEn
  -tieuDeVi
  -moTaEn
  -moTaVi
  -maMauHex
  -danhSachTuKhoa
  +xoaThuThach()
}

class DichVuCSDL {
  <<Entity>>
  -urlRealtimeDatabase
  -nodeRoot
  +xoaThuThachCSDL()
  +dongBoDuLieu()
}

GiaoDienXoaThuThach -- HeThong
HeThong -- ThuThach
HeThong -- DichVuCSDL
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_delete_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/analysis_class_diagram_delete_mission.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.8 Biểu đồ lớp phân tích Use Case "Tập viết theo mẫu các chữ cái"

---

title: 2.2.8. Biểu đồ lớp phân tích chức năng tập viết theo mẫu các chữ cái

---

```mermaid
classDiagram
direction LR

class GiaoDienTapViet {
  <<Boundary>>
  +hienThiChuMau()
  +capNhatKieuChu()
  +capNhatMauSac()
  +capNhatKichCoNetVe()
  +xoaBangVe()
  +hienThiNetVe()
  +dongGiaoDien()
}

class DieuKhienTapViet {
  <<Control>>
  +taiThongTinChuCai()
  +thayDoiThietLapBangVe()
  +xuLyToaDoNetVe()
}

class ChuCai {
  <<Entity>>
  -maChuCai
  -kieuInHoa
  -kieuVietThuong
  +layMauChu()
}

class CauHinhBangVe {
  <<Entity>>
  -mauSacHienTai
  -kichCoHienTai
  -kieuChuHienTai
  +capNhatCauHinh()
  +layCauHinh()
}

GiaoDienTapViet -- DieuKhienTapViet
DieuKhienTapViet -- ChuCai
DieuKhienTapViet -- CauHinhBangVe
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_draw_letter.drawio](file:///Users/mitie/tlu-app/KidX/docs/AC/analysis_class_diagram_draw_letter.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.9 Biểu đồ lớp phân tích Use Case "Tập viết chữ số 0 - 9"

---

title: 2.2.9. Biểu đồ lớp phân tích chức năng tập viết chữ số 0 - 9

---

```mermaid
classDiagram
direction LR

class GiaoDienTapVietSo {
  <<Boundary>>
  +chonSoMuonTapViet()
  +vietSoLenBangDen()
  +xoaNetVe()
  +clickKiemTra()
  +hienThiKetQua()
  +quayLaiTrangTruoc()
}

class DieuKhienTapVietSo {
  <<Control>>
  +xuLyChuyenSo()
  +resetBangVe()
  +nhanDangChuSo(buffer)
}

class mnistCNN {
  <<Entity>>
  +prediction(image)
}

class CauHinhBangVeSo {
  <<Entity>>
  -soDangChon
  -trangThaiNetDraw
  +capNhatCauHinh()
  +layCauHinh()
}

GiaoDienTapVietSo -- DieuKhienTapVietSo
DieuKhienTapVietSo -- mnistCNN
DieuKhienTapVietSo -- CauHinhBangVeSo
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_draw_number.drawio](file:///Users/mitie/tlu-app/KidX/docs/AC/analysis_class_diagram_draw_number.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.10 Biểu đồ lớp phân tích Use Case "Thử thách truy tìm đồ vật"

---

title: 2.2.10. Biểu đồ lớp phân tích chức năng thử thách truy tìm đồ vật

---

```mermaid
classDiagram
direction LR

class GiaoDienDanhSachThuThach {
  <<Boundary>>
  +hienThiDanhSachNhiemVu()
  +capNhatTienTrinh()
  +clickThucHienNhiemVu()
  +clickQuayLai()
}

class GiaoDienKetQuaNhanDang {
  <<Boundary>>
  +hienThiThanhCong()
  +hienThiThatBai()
  +phatAmThanh()
  +clickLuu()
  +clickThuLai()
}

class DieuKhienTruyTimDoVat {
  <<Control>>
  +taiDanhSachTuFirebase()
  +xuLyNhanDangAnh(buffer)
  +kiemTraKetQua(rawLabel)
}

class MissionData {
  <<Entity>>
  -id
  -title
  -description
  -isCompleted
  -keywords
  +layDanhSachNhiemVu()
  +setMissionCompleted(id)
}

class MobileNet {
  <<Entity>>
  +predict(image)
}

class SavedObjectItem {
  <<Entity>>
  +save(image, name)
}

GiaoDienDanhSachThuThach -- DieuKhienTruyTimDoVat
GiaoDienKetQuaNhanDang -- DieuKhienTruyTimDoVat
DieuKhienTruyTimDoVat -- MissionData
DieuKhienTruyTimDoVat -- MobileNet
DieuKhienTruyTimDoVat -- SavedObjectItem
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_treasure_hunt.drawio](file:///Users/mitie/tlu-app/KidX/docs/AC/analysis_class_diagram_treasure_hunt.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.2.11 Biểu đồ lớp phân tích Use Case "Thử thách giải toán nhanh"

---

title: 2.2.11. Biểu đồ lớp phân tích chức năng thử thách giải toán nhanh

---

```mermaid
classDiagram
direction LR

class GiaoDienThuThachGiaiToan {
  <<Boundary>>
  +chonCheDoThuThach()
  +veKetQuaLenBang()
  +xoaKetQua()
  +clickKiemTra()
  +clickKeTiep()
  +hienThiThanhCong(prediction)
  +hienThiThatBai(prediction)
  +hienThiHoanThanhChallenge()
  +quayLaiTrangTruoc()
  +batDauDongHoDemNguoc()
  +hienThiHetGio()
}

class DieuKhienGiaiToanNhanh {
  <<Control>>
  +taiDanhSachThuThach(difficulty)
  +resetTienTrinh()
  +chuyenThuThachKeTiep()
  +kiemTraKetQua(pixelBuffer)
  +quayVeManHinhChinh()
}

class CaculateChallenge {
  <<Entity>>
  -id: String
  -level: Int
  -operand1: Int
  -operand2: Int
  -operation: String
  -result: Int
  -isCompleted: Bool
  +getCompletedChallengeIds(difficulty)
  +setChallengeCompleted(id, difficulty)
  +clearProgress(difficulty)
}

class MNISTDigitPredictor {
  <<Entity>>
  -model: mnistCNN
  +predict(pixelBuffer)
}

class AchievementStatsService {
  <<Entity>>
  +recordMathChallengeCompleted()
}

GiaoDienThuThachGiaiToan -- DieuKhienGiaiToanNhanh
DieuKhienGiaiToanNhanh -- CaculateChallenge
DieuKhienGiaiToanNhanh -- MNISTDigitPredictor
CaculateChallenge -- AchievementStatsService
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_calculate.drawio](file:///Users/mitie/tlu-app/KidX/docs/AC/analysis_class_diagram_calculate.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

### 2.2.12 Biểu đồ lớp phân tích Use Case "Xem Thống Kê Tiến Độ Học"

---

title: 2.2.12. Biểu đồ lớp phân tích chức năng xem thống kê tiến độ học

---

```mermaid
classDiagram
direction LR

class GiaoDienThongKeTienDo {
  <<Boundary>>
  +clickXemThanhTich()
  +clickChuyenBoLoc(period)
  +clickQuayLai()
  +hienThiThongKe(stats)
  +hienThiTrangThaiTrong(message)
  +hienThiCanhBaoLoi(error)
}

class DieuKhienThongKeTienDo {
  <<Control>>
  +taiThongKeTienDo(period)
  +tinhToanChiSo(logs)
  +chuyenHuongLuyenTap()
  +quayVeManHinhTruoc()
}

class StudyLog {
  <<Entity>>
  -logId: String
  -date: String
  -totalStudyTime: Int
  -cardsLearned: Int
  -objectsFound: Int
  -mathsSolved: Int
  -starsEarned: Int
  +getStudyLogs(period)
}

class LearningStats {
  <<Entity>>
  -totalTime: Int
  -totalStars: Int
  -progressPercentage: Double
  -chartData: List~StatEntry~
  +buildStats(logs)
}

GiaoDienThongKeTienDo -- DieuKhienThongKeTienDo
DieuKhienThongKeTienDo -- StudyLog
DieuKhienThongKeTienDo -- LearningStats
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ lớp phân tích chi tiết đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [analysis_class_diagram_achieve_stats.drawio](file:///Users/mitie/tlu-app/KidX/docs/AC/analysis_class_diagram_achieve_stats.drawio). Người dùng có thể kéo thả tệp này vào trang Web `draw.io` để xuất ảnh đồ họa chèn vào báo cáo.

---

### 2.3.2 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn

```plantuml
@startuml SD_ThemMoiTheGhiNho
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Quản trị viên" as Admin
boundary "Giao diện thêm mới" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu" as CSDL

Admin -> UI : 1. Nhập thông tin thẻ và nhấn "Lưu"
activate UI

UI -> Controller : 2. Gửi yêu cầu thêm mới thẻ
activate Controller

Controller -> Controller : 3. Kiểm tra thông tin hợp lệ

alt Thiếu thông tin (Ngoại lệ 1)
  Controller --[#red]> UI : 4. Trả thông báo thiếu dữ liệu
  UI --[#red]> Admin : 5. Cảnh báo lỗi thiếu thông tin

else Đầy đủ thông tin
  Controller -> CSDL : 4. Kiểm tra trùng lặp & lưu thẻ mới
  activate CSDL
  
  alt Trùng lặp từ vựng (Ngoại lệ 2)
    CSDL --[#red]> Controller : 5. Báo trùng lặp
    Controller --[#red]> UI : 6. Trả thông báo trùng từ vựng
    UI --[#red]> Admin : 7. Cảnh báo từ vựng đã tồn tại
    
  else Lỗi lưu dữ liệu (Ngoại lệ 3)
    CSDL --[#red]> Controller : 5. Báo lỗi lưu trữ
    Controller --[#red]> UI : 6. Trả thông báo lưu thất bại
    UI --[#red]> Admin : 7. Thông báo lỗi và quay lui trạng thái
    
  else Lưu thành công
    CSDL --> Controller : 5. Xác nhận lưu thành công
    deactivate CSDL
    Controller --> UI : 6. Trả kết quả thêm thành công
    UI --> Admin : 7. Hiển thị thông báo thành công
  end
end

deactivate Controller
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được cập nhật và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_add_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/sequence_diagram_add_flashcard.drawio).

---

### 2.3.3 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng sửa thẻ ghi nhớ

```plantuml
@startuml SD_SuaTheGhiNho
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Quản trị viên" as Admin
boundary "Giao diện sửa thẻ" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu" as CSDL

Admin -> UI : 1. Thay đổi thông tin thẻ và nhấn "Lưu"
activate UI

UI -> Controller : 2. Gửi yêu cầu cập nhật thẻ
activate Controller

Controller -> Controller : 3. Kiểm tra thông tin hợp lệ

alt Thiếu thông tin (Ngoại lệ 1)
  Controller --[#red]> UI : 4. Trả thông báo thiếu dữ liệu
  UI --[#red]> Admin : 5. Cảnh báo lỗi thiếu thông tin

else Đầy đủ thông tin
  Controller -> CSDL : 4. Kiểm tra trùng lặp & cập nhật CSDL
  activate CSDL
  
  alt Trùng lặp từ vựng (Ngoại lệ 2)
    CSDL --[#red]> Controller : 5. Báo trùng lặp
    Controller --[#red]> UI : 6. Trả thông báo trùng từ vựng
    UI --[#red]> Admin : 7. Cảnh báo từ vựng đã tồn tại
    
  else Lỗi lưu dữ liệu (Ngoại lệ 3)
    CSDL --[#red]> Controller : 5. Báo lỗi lưu trữ
    Controller --[#red]> UI : 6. Trả thông báo lưu thất bại
    UI --[#red]> Admin : 7. Thông báo lỗi và quay lui trạng thái
    
  else Cập nhật thành công
    CSDL --> Controller : 5. Xác nhận lưu thành công
    deactivate CSDL
    Controller --> UI : 6. Trả kết quả cập nhật thành công
    UI --> Admin : 7. Hiển thị thông báo thành công
  end
end

deactivate Controller
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_edit_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/sequence_diagram_edit_flashcard.drawio).

---

### 2.3.4 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng xóa thẻ ghi nhớ

```plantuml
@startuml SD_XoaTheGhiNho
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Quản trị viên" as Admin
boundary "Giao diện xóa thẻ" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu" as CSDL

Admin -> UI : 1. Chọn xóa thẻ ghi nhớ
activate UI

UI -> UI : 2. Hiển thị hộp thoại xác nhận xóa

alt Hủy bỏ yêu cầu xóa (Ngoại lệ 1)
  Admin -> UI : 3. Nhấn "Hủy"
  UI -> UI : Đóng hộp thoại xác nhận

else Xác nhận xóa
  Admin -> UI : 3. Nhấn "Xác nhận"
  UI -> Controller : 4. Gửi yêu cầu xóa thẻ
  activate Controller

  Controller -> CSDL : 5. Yêu cầu xóa dữ liệu thẻ & tệp ảnh
  activate CSDL
  
  alt Lỗi xóa dữ liệu (Ngoại lệ 2)
    CSDL --[#red]> Controller : 6. Báo lỗi hệ thống
    Controller --[#red]> UI : 7. Trả thông báo xóa thất bại
    UI --[#red]> Admin : 8. Cảnh báo lỗi xóa thất bại
    
  else Xóa thành công
    CSDL --> Controller : 6. Xác nhận đã xóa thành công
    deactivate CSDL
    Controller --> UI : 7. Trả kết quả xóa thành công
    deactivate Controller
    UI --> Admin : 8. Thông báo thành công & cập nhật lại danh sách
  end
end

deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_delete_flashcard.drawio](file:///Users/mitie/tlu-app/KidX/docs/sequence_diagram_delete_flashcard.drawio).

---

### 2.3.5 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng thêm mới thử thách

```plantuml
@startuml SD_ThemMoiThuThach
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Quản trị viên" as Admin
boundary "Giao diện thêm mới" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu" as CSDL

Admin -> UI : 1. Nhập thông tin thử thách và nhấn "Lưu"
activate UI

UI -> Controller : 2. Gửi yêu cầu thêm mới thử thách
activate Controller

Controller -> Controller : 3. Kiểm tra thông tin hợp lệ

alt Thiếu thông tin (Ngoại lệ 1)
  Controller --[#red]> UI : 4. Trả thông báo thiếu dữ liệu
  UI --[#red]> Admin : 5. Cảnh báo lỗi thiếu thông tin

else Đầy đủ thông tin
  Controller -> CSDL : 4. Lưu thử thách mới vào CSDL
  activate CSDL
  
  alt Ghi dữ liệu thất bại (Ngoại lệ 2)
    CSDL --[#red]> Controller : 5. Báo lỗi lưu trữ
    Controller --[#red]> UI : 6. Trả thông báo lưu thất bại
    UI --[#red]> Admin : 7. Thông báo lỗi và quay lui trạng thái
    
  else Lưu thành công
    CSDL --> Controller : 5. Xác nhận lưu thành công
    deactivate CSDL
    Controller --> UI : 6. Trả kết quả thêm thành công
    UI --> Admin : 7. Hiển thị thông báo thành công
  end
end

deactivate Controller
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_add_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/sequence_diagram_add_mission.drawio).

---

### 2.3.6 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng sửa thử thách

```plantuml
@startuml SD_SuaThuThach
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Quản trị viên" as Admin
boundary "Giao diện sửa thử thách" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu" as CSDL

Admin -> UI : 1. Thay đổi thông tin thử thách và nhấn "Lưu"
activate UI

UI -> Controller : 2. Gửi yêu cầu cập nhật thử thách
activate Controller

Controller -> Controller : 3. Kiểm tra thông tin hợp lệ

alt Thiếu thông tin (Ngoại lệ 1)
  Controller --[#red]> UI : 4. Trả thông báo thiếu dữ liệu
  UI --[#red]> Admin : 5. Cảnh báo lỗi thiếu thông tin

else Đầy đủ thông tin
  Controller -> CSDL : 4. Cập nhật dữ liệu thay đổi vào CSDL
  activate CSDL
  
  alt Ghi dữ liệu thất bại (Ngoại lệ 2)
    CSDL --[#red]> Controller : 5. Báo lỗi lưu trữ
    Controller --[#red]> UI : 6. Trả thông báo lưu thất bại
    UI --[#red]> Admin : 7. Thông báo lỗi và khôi phục trạng thái
    
  else Cập nhật thành công
    CSDL --> Controller : 5. Xác nhận cập nhật thành công
    deactivate CSDL
    Controller --> UI : 6. Trả kết quả cập nhật thành công
    UI --> Admin : 7. Hiển thị thông báo thành công
  end
end

deactivate Controller
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_edit_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/sequence_diagram_edit_mission.drawio).

---

### 2.3.7 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng xóa thử thách

```plantuml
@startuml SD_XoaThuThach
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Quản trị viên" as Admin
boundary "Giao diện xóa thử thách" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu" as CSDL

Admin -> UI : 1. Chọn xóa thử thách
activate UI

UI -> UI : 2. Hiển thị hộp thoại xác nhận xóa

alt Hủy bỏ yêu cầu xóa (Ngoại lệ 1)
  Admin -> UI : 3. Nhấn "Hủy"
  UI -> UI : Đóng hộp thoại xác nhận

else Xác nhận xóa
  Admin -> UI : 3. Nhấn "Xác nhận"
  UI -> Controller : 4. Gửi yêu cầu xóa thử thách
  activate Controller

  Controller -> CSDL : 5. Yêu cầu xóa node thử thách trên Firebase
  activate CSDL
  
  alt Lỗi xóa dữ liệu (Ngoại lệ 2)
    CSDL --[#red]> Controller : 6. Báo lỗi hệ thống
    Controller --[#red]> UI : 7. Trả thông báo xóa thất bại
    UI --[#red]> Admin : 8. Cảnh báo lỗi xóa thất bại
    
  else Xóa thành công
    CSDL --> Controller : 6. Xác nhận đã xóa thành công
    deactivate CSDL
    Controller --> UI : 7. Trả kết quả xóa thành công
    deactivate Controller
    UI --> Admin : 8. Thông báo thành công & cập nhật lại danh sách
  end
end

deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_delete_mission.drawio](file:///Users/mitie/tlu-app/KidX/docs/sequence_diagram_delete_mission.drawio).

---

### 2.3.8 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng tập viết theo mẫu các chữ cái

```plantuml
@startuml SD_TapVietChuCai
skinparam defaultFontName Arial
skinparam defaultFontSize 24
skinparam shadowing false
skinparam ParticipantPadding 10
skinparam BoxPadding 5

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor Black
  LifeLineBorderThickness 2
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Người dùng" as User
boundary "Giao diện tập viết" as UI
control "Hệ thống" as Controller
entity "Cơ sở dữ liệu cục bộ" as DB

User -> UI : 1. Chọn thẻ chữ cái\ncần tập viết
activate UI
||20||

UI -> Controller : 2. Yêu cầu tải thông tin\nmẫu chữ (maChuCai)
activate Controller
||20||

Controller -> DB : 3. Truy vấn dữ liệu\nmẫu chữ
activate DB
||20||
DB --> Controller : 4. Trả về dữ liệu chữ cái\n(in hoa, viết thường)
deactivate DB
||20||

Controller -> Controller : 5. Kiểm tra tính hợp lệ\ncủa dữ liệu
||20||

alt Tải dữ liệu thất bại
  Controller --> UI : 6a. Trả về lỗi\ntải dữ liệu
  ||20||
  UI --> User : 7a. Hiển thị thông báo lỗi\nvà đóng màn hình
  ||20||
else Tải dữ liệu thành công
  Controller --> UI : 6b. Truyền thiết lập mặc định\n(chữ in hoa, nét trung, màu cam)
  ||20||
  UI --> User : 7b. Hiển thị giao diện\ntập viết
  ||20||
  
  loop Tương tác tập viết
    alt Tùy chọn thiết lập bảng vẽ
      User -> UI : 8a. Chọn kiểu chữ, màu sắc,\ncỡ nét hoặc Xóa
      ||20||
      UI -> Controller : 9a. Gửi yêu cầu\ncập nhật thiết lập
      ||20||
      Controller --> UI : 10a. Xác nhận\ncập nhật
      ||20||
      UI --> User : 11a. Hiển thị bảng vẽ\ntheo thiết lập mới
      ||20||
    else Tập viết nét chữ
      User -> UI : 8b. Di chuyển ngón tay\ntô theo nét chữ
      ||20||
      UI -> Controller : 9b. Gửi tọa độ nét vẽ
      ||20||
      Controller --> UI : 10b. Nhận dạng và cập nhật\nhiển thị nét vẽ
      ||20||
      UI --> User : 11b. Hiển thị nét vẽ\nthời gian thực
      ||20||
    end
  end
  
  User -> UI : 12. Nhấn nút\n"Quay lại"
  ||20||
  UI -> Controller : 13. Xử lý đóng\ngiao diện
  ||20||
  Controller --> UI : 14. Xác nhận đóng
  deactivate Controller
  ||20||
  UI --> User : 15. Đóng giao diện,\ntrở về màn hình danh sách
end

deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_draw_letter.drawio](file:///Users/mitie/tlu-app/KidX/docs/SD/sequence_diagram_draw_letter.puml).

---

### 2.3.9 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng tập viết chữ số 0 - 9

```plantuml
@startuml SD_TapVietChuSo
skinparam defaultFontName Arial
skinparam defaultFontSize 24
skinparam shadowing false
skinparam ParticipantPadding 10
skinparam BoxPadding 5

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor Black
  LifeLineBorderThickness 2
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Người dùng" as User
boundary "Giao diện tập viết" as UI
control "Hệ thống" as Controller
entity "Mô hình AI (mnistCNN)" as AI

User -> UI : 1. Chọn thẻ\n"Luyện Viết Chữ Số"
activate UI
||20||

UI -> UI : 2. Khởi tạo giao diện mặc định\n(Bảng vẽ trống, chọn số 0)
||20||

loop Tương tác luyện viết số
  alt Chọn số hoặc Xóa bảng vẽ
    User -> UI : 3a. Chạm chọn số mới (0-9)\nhoặc nhấn Clear
    ||20||
    UI -> UI : 4a. Cập nhật số chọn, làm sạch\nbảng vẽ và ẩn kết quả
    ||20||
  
  else Thực hiện nét vẽ
    User -> UI : 3b. Di chuyển ngón tay\ntrên bảng vẽ
    ||20||
    UI -> UI : 4b. Nhận dạng và hiển thị\nnét vẽ thời gian thực
    ||20||
  
  else Kiểm tra nhận diện chữ số
    User -> UI : 3c. Chạm nút "Kiểm tra"
    ||20||
    UI -> Controller : 4c. Gửi yêu cầu nhận diện\nnét vẽ (pixel buffer)
    activate Controller
    ||20||
    
    Controller -> AI : 5. Dự đoán chữ số\ntừ ảnh nét vẽ
    activate AI
    ||20||
    AI --> Controller : 6. Trả về kết quả\n(số dự đoán, độ tin cậy)
    deactivate AI
    ||20||
    
    alt Nhận diện không tin cậy (Ngoại lệ)
      Controller --> UI : 7a. Báo kết quả\nkhông tin cậy (Unreliable)
      ||20||
      UI --> User : 8a. Hiển thị cảnh báo\n"Không thể nhận dạng" & viết lại
      ||20||
      
    else Nhận diện thành công
      Controller --> UI : 7b. Trả về chữ số dự đoán
      deactivate Controller
      ||20||
      UI -> UI : 8b. So khớp chữ số\ndự đoán với số đã chọn
      ||20||
      UI --> User : 9b. Hiển thị kết quả\ntương ứng (Đúng / Sai)
      ||20||
    end
  end
end

User -> UI : 10. Chạm chọn nút\n"Quay lại"
||20||
UI -> UI : 11. Giải phóng tài nguyên\nvà đóng màn hình
||20||
UI --> User : 12. Trở về màn hình\nhọc tập chính
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_draw_number.drawio](file:///Users/mitie/tlu-app/KidX/docs/SD/sequence_diagram_draw_number.puml).

---

### 2.3.10 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng thử thách truy tìm đồ vật

```plantuml
@startuml SD_TruyTimDoVat
skinparam defaultFontName Arial
skinparam defaultFontSize 24
skinparam shadowing false
skinparam ParticipantPadding 10
skinparam BoxPadding 5

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor Black
  LifeLineBorderThickness 2
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Người dùng" as User
boundary "Giao diện nhiệm vụ" as UI
control "Hệ thống" as Controller
entity "Mô hình AI (MobileNet)" as AI
entity "Cơ sở dữ liệu" as CSDL

User -> UI : 1. Chọn thẻ\n"Game truy tìm kho báu"
activate UI
||20||

UI -> CSDL : 2. Yêu cầu tải\ndanh sách nhiệm vụ
activate CSDL
||20||
CSDL --> UI : 3. Trả về danh sách\nnhiệm vụ (Firebase)
deactivate CSDL
||20||

UI -> UI : 4. Hiển thị danh sách\nnhiệm vụ và tiến trình
||20||

loop Tương tác thực hiện nhiệm vụ
  User -> UI : 5. Chọn thực hiện nhiệm vụ\n& chụp/chọn ảnh
  ||20||
  UI -> Controller : 6. Gửi ảnh vật thể\n(UIImage)
  activate Controller
  ||20||
  
  Controller -> AI : 7. Yêu cầu nhận diện\nvật thể từ ảnh
  activate AI
  ||20||
  AI --> Controller : 8. Trả về kết quả\nphân loại (raw label)
  deactivate AI
  ||20||
  
  Controller -> Controller : 9. So khớp nhãn nhận diện\nvới từ khóa nhiệm vụ
  ||20||
  
  alt Kết quả chính xác (Match)
    Controller -> CSDL : 10a. Cập nhật trạng thái\nhoàn thành & lưu vật thể
    activate CSDL
    ||20||
    CSDL --> Controller : 11a. Xác nhận\nlưu thành công
    deactivate CSDL
    ||20||
    Controller --> UI : 12a. Báo nhận diện\nchính xác
    ||20||
    UI --> User : 13a. Hiển thị popup\nChúc mừng thành công
    ||20||
    
  else Kết quả chưa chính xác (Not Match)
    Controller --> UI : 10b. Báo nhận diện\nchưa chính xác
    deactivate Controller
    ||20||
    UI --> User : 11b. Hiển thị popup\nthông báo sai & gợi ý thử lại
    ||20||
  end
end

User -> UI : 14. Nhấn nút "Quay lại"
||20||
UI --> User : 15. Đóng giao diện,\ntrở về màn hình khám phá chính
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_treasure_hunt.puml](file:///Users/mitie/tlu-app/KidX/docs/SD/sequence_diagram_treasure_hunt.puml).

---

### 2.3.11 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng thử thách giải toán nhanh

```plantuml
@startuml SD_GiaiToanNhanh
skinparam defaultFontName Arial
skinparam defaultFontSize 24
skinparam shadowing false
skinparam ParticipantPadding 15
skinparam BoxPadding 10

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor Black
  LifeLineBorderThickness 2
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Người dùng" as User
boundary "Giao diện giải toán" as UI
control "Bộ điều khiển" as Controller
entity "Cơ sở dữ liệu" as CSDL

User -> UI : 1. Chọn thử thách giải toán
activate UI
||20||

UI -> Controller : 2. Yêu cầu tải dữ liệu (loadChallenges)
activate Controller
||20||

Controller -> CSDL : 3. Truy vấn tiến trình đã lưu (getCompletedChallengeIds)
activate CSDL
||20||
CSDL --> Controller : 4. Trả về các ID đã hoàn thành
deactivate CSDL
||20||

Controller -> Controller : 5. Khởi tạo ngẫu nhiên 10 cấp độ\nvà tìm cấp độ chưa làm đầu tiên
||20||

Controller --> UI : 6. Gửi callback dữ liệu tải xong (onDataLoaded)
deactivate Controller
||20||

UI -> UI : 7. Cập nhật hiển thị (Cấp độ, Phép toán, ẩn nút Next)
||20||

alt Chế độ nâng cao (Advanced Mode)
  UI -> UI : 8. Bắt đầu đếm ngược 180 giây (startTimer)
  ||20||
end

loop Tương tác giải toán (10 cấp độ)
  User -> UI : 9. Vẽ nét đáp án trên bảng vẽ và nhấn "Check"
  ||20||
  UI -> UI : 10. Hiển thị HUD nhận diện
  ||20||
  UI -> Controller : 11. Gửi pixel buffer nét vẽ (checkAnswer)
  activate Controller
  ||20||
  Controller -> Controller : 12. Nhận dạng nét vẽ (MNIST) & so khớp đáp án
  ||20||
  
  alt Đáp án Đúng (isCorrect = true)
    Controller -> CSDL : 13a. Lưu tiến trình hoàn thành & ghi thành tích
    activate CSDL
    ||20||
    CSDL --> Controller : 14a. Xác nhận lưu thành công
    deactivate CSDL
    ||20||
    Controller --> UI : 15a. Trả về kết quả Đúng & số dự đoán
    ||20||
    UI -> UI : 16a. Ẩn HUD, hiện đáp án màu xanh & hiện nút "Kế tiếp"
    ||20||
    
    User -> UI : 17a. Nhấn nút "Kế tiếp" (Next)
    ||20||
    UI -> Controller : 18a. Yêu cầu câu hỏi tiếp theo (nextChallenge)
    activate Controller
    ||20||
    Controller --> UI : 19a. Trả về thông tin câu hỏi của cấp độ mới
    deactivate Controller
    ||20||
    UI -> UI : 20a. Tải câu hỏi mới, ẩn nút Next & Clear bảng vẽ
    ||20||
    
  else Đáp án Sai (isCorrect = false)
    Controller --> UI : 13b. Trả về kết quả Sai & số dự đoán
    deactivate Controller
    ||20||
    UI -> UI : 14b. Ẩn HUD, hiện đáp án màu đỏ & rung hộp đáp án;\nSau 1.2 giây khôi phục "?" & Clear bảng vẽ
    ||20||
  end
end

UI -> UI : 21. Hoàn thành 10 cấp độ, dừng timer,\ntrigger pháo hoa & hiển thị popup chúc mừng
||20||

alt Người dùng nhấn nút "Đóng" hoặc "Back"
  User -> UI : 22. Yêu cầu đóng màn hình học tập
  ||20||
  UI -> Controller : 23. Điều phối quay lại (navigateBack)
  activate Controller
  ||20||
  Controller --> UI : 24. Xác nhận pop ViewController
  deactivate Controller
  ||20||
  UI --> User : 25. Trở về màn hình học tập chính
  deactivate UI
end
||20||

alt Ngoại lệ: Hết thời gian đếm ngược (Chế độ nâng cao)
  UI -> UI : Timer đếm ngược về 0 giây
  ||20||
  UI -> User : Hiển thị thông báo hết giờ
  ||20||
  User -> UI : Nhấn "OK" xác nhận
  ||20||
  UI -> Controller : Điều phối quay lại (navigateBack)
  activate Controller
  ||20||
  Controller --> UI : Xác nhận pop ViewController
  deactivate Controller
  ||20||
  UI --> User : Trở về màn hình học tập chính
end
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_calculate.puml](file:///Users/mitie/tlu-app/KidX/docs/SD/sequence_diagram_calculate.puml).

### 2.3.12 Mã UML (PlantUML) cho biểu đồ Sequence rút gọn chức năng xem thống kê tiến độ học

```plantuml
@startuml SD_XemThongKeTienDo
skinparam defaultFontName Arial
skinparam defaultFontSize 18
skinparam shadowing false

skinparam sequence {
  ParticipantBorderColor Black
  ParticipantBackgroundColor White
  ActorBorderColor Black
  ActorBackgroundColor White
  LifeLineBorderColor #555555
  LifeLineBackgroundColor White
  ArrowColor Black
  GroupBorderColor Black
  GroupBackgroundColor White
  ActivationBorderColor Black
  ActivationBackgroundColor #EEEEEE
}

actor "Người dùng" as User
boundary "GiaoDienThongKeTienDo" as UI
control "DieuKhienThongKeTienDo" as Controller
entity "StudyLog" as Log
entity "LearningStats" as Stats

User -> UI : clickXemThanhTich()
activate UI
||20||

UI -> Controller : taiThongKeTienDo(period)
activate Controller
||20||

Controller -> Log : getStudyLogs(period)
activate Log
||20||
Log --> Controller : logs
deactivate Log
||20||

Controller -> Controller : tinhToanChiSo(logs)
||20||

alt logs rỗng
  Controller --> UI : stats rỗng
  deactivate Controller
  ||20||
  UI -> UI : hienThiTrangThaiTrong()
  ||20||
  UI --> User : hiển thị trạng thái trống
  ||20||

else có dữ liệu
  Controller -> Stats : buildStats(logs)
  activate Stats
  ||20||
  Stats --> Controller : stats
  deactivate Stats
  ||20||
  Controller --> UI : hienThiThongKe(stats)
  deactivate Controller
  ||20||
  UI --> User : hiển thị thống kê + biểu đồ
  ||20||
end

loop đổi bộ lọc
  User -> UI : clickChuyenBoLoc(period)
  ||20||
  UI -> Controller : taiThongKeTienDo(period)
  activate Controller
  ||20||
  Controller -> Log : getStudyLogs(period)
  activate Log
  ||20||
  Log --> Controller : logs
  deactivate Log
  ||20||
  Controller -> Controller : tinhToanChiSo(logs)
  ||20||
  Controller --> UI : hienThiThongKe(stats)
  deactivate Controller
  ||20||
  UI --> User : cập nhật UI
  ||20||
end

User -> UI : clickQuayLai()
||20||
UI -> Controller : quayVeManHinhTruoc()
activate Controller
||20||
Controller --> UI : confirm
deactivate Controller
||20||
UI --> User : back
deactivate UI
@enduml
```

*Lưu ý cho việc vẽ sơ đồ:* Sơ đồ tuần tự tương ứng đã được khởi tạo và lưu dưới dạng tệp tin Draw.io tại đường dẫn [sequence_diagram_achieve_stats.puml](file:///Users/mitie/tlu-app/KidX/docs/SD/sequence_diagram_achieve_stats.puml).

---

## 2.5 Thiết kế cơ sở dữ liệu

2.5.1. Cấu trúc cơ sở dữ liệu từ xa (Remote Database - Firebase)

missions Collection
Mô tả: Lưu trữ danh sách nhiệm vụ săn tìm đồ vật đồng bộ từ Firebase Realtime Database.
Document ID: missionId (string)
Trường dữ liệu:
id: string (ID nhiệm vụ)
titleEn: string (tên nhiệm vụ tiếng Anh)
titleVi: string (tên nhiệm vụ tiếng Việt)
descriptionEn: string (mô tả gợi ý tiếng Anh)
descriptionVi: string (mô tả gợi ý tiếng Việt)
iconSymbol: string (tên biểu tượng SF Symbol)
iconBgColorHex: string (mã màu HEX nền biểu tượng)
keywords: array (danh sách từ khóa tiếng Anh nhận dạng)

2.5.2. Cấu trúc cơ sở dữ liệu cục bộ (Local Database - UserDefaults & FileManager)

users Local Storage
Mô tả: Lưu trữ thông tin tài khoản người dùng hiện tại đang đăng nhập.
Key ID: currentUser (string)
Trường dữ liệu:
uid: string (mã định danh tài khoản từ Firebase Auth)
email: string (địa chỉ email đăng nhập)
displayName: string (tên hiển thị của trẻ)
avatarUrl: string (đường dẫn ảnh đại diện)

studyLogs Local Storage
Mô tả: Lưu trữ nhật ký hoạt động học tập hàng ngày của trẻ.
Key ID: studyLogs_YYYY-MM-DD (string)
Trường dữ liệu:
logId: string (ID nhật ký)
date: string (ngày học tập)
totalStudyTime: number (tổng thời gian học trong ngày, đơn vị giây)
cardsLearned: number (số lượng thẻ từ vựng đã học)
objectsFound: number (số lượng đồ vật đã tìm thấy)
mathsSolved: number (số lượng phép toán giải đúng)

savedObjects Local Storage
Mô tả: Lưu trữ bộ sưu tập hình ảnh các đồ vật trẻ đã chụp và tìm thấy thành công.
Key ID: savedObjectId (string)
Trường dữ liệu:
savedId: string (ID ảnh lưu trữ)
objectName: string (tên đồ vật đã nhận dạng)
imagePath: string (đường dẫn tuyệt đối đến tệp tin ảnh trong bộ nhớ cục bộ)
createdAt: timestamp (thời điểm chụp ảnh)

vocabulary Local Storage
Mô tả: Lưu trữ danh sách các chủ đề từ vựng.
Document ID: topicId (string)
Trường dữ liệu:
topicName: string (tên chủ đề học tập)
topicIcon: string (SF Symbol đại diện chủ đề)

words Subcollection (dưới vocabulary)
Mô tả: Lưu trữ danh sách các thẻ từ vựng trong từng chủ đề.
Document ID: cardId (string)
Trường dữ liệu:
wordEn: string (từ vựng tiếng Anh)
wordVi: string (nghĩa tiếng Việt của từ)
imagePath: string (tên tệp ảnh minh họa cục bộ)

mathLevels Local Storage
Mô tả: Lưu trữ danh sách cấu hình cấp độ của thử thách toán học.
Key ID: levelId (string)
Trường dữ liệu:
operand1: number (số thứ nhất)
operand2: number (số thứ hai)
operation: string (toán tử "+" hoặc "-")
result: number (kết quả chính xác)

