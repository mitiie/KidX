# XIB Localization Guide

Hướng dẫn này giải thích cách thiết lập đa ngôn ngữ (Localization) trực tiếp trong các file `.xib` và định nghĩa các bản dịch trong các file `Localizable.strings` của dự án KidX.

---

## 1. Cơ chế Hoạt động (How It Works)

Dự án sử dụng cơ chế mở rộng (extension) thông qua `@IBInspectable` trong file `LocalizeHelper.swift` để tự động hóa việc dịch các thành phần UI khi file XIB được load tại runtime.

Các thuộc tính inspectable khả dụng bao gồm:
*   **`UILabel`, `UITextField`, `UITextView`**: Thuộc tính `localizedText`
*   **`UITextField` (Placeholder)**: Thuộc tính `localizedPlaceholder`
*   **`UIButton` (Theo các State)**:
    *   `normalLocalizedTitle` (Dành cho Normal state)
    *   `highlightedLocalizedTitle` (Dành cho Highlighted state)
    *   `selectedLocalizedTitle` (Dành cho Selected state)
    *   `disabledLocalizedTitle` (Dành cho Disabled state)

---

## 2. Thiết lập trên XIB (XIB Configuration)

Thay vì thiết lập text bằng code Swift thủ công, bạn có thể cấu hình trực tiếp trên Xcode Interface Builder thông qua **User Defined Runtime Attributes**:

1.  Mở file `.xib` cần cấu hình.
2.  Chọn Label hoặc Button cần dịch.
3.  Mở tab **Identity Inspector** (phím tắt `Cmd + Alt + 3`).
4.  Tại phần **User Defined Runtime Attributes**, nhấn nút `+` để thêm thuộc tính mới:

### Dành cho UILabel / UITextField / UITextView:
*   **Key Path**: `localizedText`
*   **Type**: `String`
*   **Value**: *Nhập English Key dùng làm mã dịch (Ví dụ: `Discover the World!`)*

### Dành cho UIButton (Normal state):
*   **Key Path**: `normalLocalizedTitle`
*   **Type**: `String`
*   **Value**: *Nhập English Key dùng làm mã dịch (Ví dụ: `Start now  →`)*

---

## 3. Định nghĩa trong file Dịch (Localizable.strings Definitions)

Khi đã đặt các Key trong XIB, bạn cần khai báo các key này trong các file ngôn ngữ tương ứng nằm ở đường dẫn:
*   [en.lproj/Localizable.strings] (File gốc tiếng Anh)
*   [vi.lproj/Localizable.strings] (Tiếng Việt)

### Quy tắc định nghĩa:
*   Sử dụng chính **nội dung tiếng Anh** làm Key định danh (Key-as-Content pattern).
*   Định dạng dòng dịch: `"Key" = "Value";` (Luôn kết thúc bằng dấu chấm phẩy `;`).

### Ví dụ thực tế:

**Trong `en.lproj/Localizable.strings`:**
```strings
"Discover the World!" = "Discover the World!";
"Start now  →" = "Start now  →";
"Popular Flash Card" = "Popular Flash Card";
```

**Trong `vi.lproj/Localizable.strings`:**
```strings
"Discover the World!" = "Khám phá thế giới!";
"Start now  →" = "Bắt đầu ngay  →";
"Popular Flash Card" = "Bộ thẻ phổ biến";
```

---

## 4. Tham chiếu Code (Code Reference)

Cơ chế này được định nghĩa tại file [LocalizeHelper.swift]

```swift
extension UILabel: XIBLocalizable {
    @IBInspectable public var localizedText: String? {
        get { return text }
        set(key) {
            text = key?.localize()
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var normalLocalizedTitle: String? {
        get { return title(for: .normal) }
        set(key) {
            setTitle(key?.localize(), for: .normal)
        }
    }
    // ... các states khác
}
```

Hãy tuân thủ quy trình này khi phát triển màn hình mới để giảm thiểu boilerplate code thiết lập giao diện trong ViewController!
