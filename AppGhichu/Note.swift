import Foundation

struct Note {
    var id: Int64        // SQLite INTEGER PRIMARY KEY -> dùng Int64
    var title: String
    var content: String
    var dateISO: String  // lưu ngày theo ISO string "yyyy-MM-dd HH:mm:ss"

    // Init chuẩn khi bạn tạo note mới (date mặc định = now)
    init(id: Int64 = 0, title: String, content: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "vi_VN")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateISO = fmt.string(from: date)
    }

    // <-- Thêm initializer này để dùng khi bạn có chuỗi dateISO từ DB
    init(id: Int64 = 0, title: String, content: String, dateISO: String) {
        self.id = id
        self.title = title
        self.content = content
        self.dateISO = dateISO
    }

    // helper chuyển dateISO -> Date
    var date: Date? {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "vi_VN")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt.date(from: dateISO)
    }

    // chuỗi hiển thị đẹp
    var displayDate: String {
        guard let d = date else { return dateISO }
        let f = DateFormatter()
        f.locale = Locale(identifier: "vi_VN")
        f.dateFormat = "EEEE, 'ngày' d 'thg' M"
        return f.string(from: d).capitalized
    }
}
