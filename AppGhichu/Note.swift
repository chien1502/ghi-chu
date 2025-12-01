import Foundation

struct Note {
    var id: Int64        // SQLite INTEGER PRIMARY KEY -> dùng Int64
    var title: String
    var content: String
    var dateISO: String
    var createdAt: Date   // thêm property createdAt để dùng trực tiếp kiểu Date

    // Init chuẩn khi tạo note mới (date mặc định = now)
    init(id: Int64 = 0, title: String, content: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = date

        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "vi_VN")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateISO = fmt.string(from: date)
    }

    // Init khi bạn có sẵn chuỗi dateISO từ DB
    init(id: Int64 = 0, title: String, content: String, dateISO: String) {
        self.id = id
        self.title = title
        self.content = content
        self.dateISO = dateISO

        // convert chuỗi dateISO -> Date, nếu không parse được thì dùng Date()
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "vi_VN")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdAt = fmt.date(from: dateISO) ?? Date()
    }

    // helper chuyển dateISO -> Date (có sẵn, nhưng có thể dùng createdAt trực tiếp)
    var date: Date {
        return createdAt
    }

    // chuỗi hiển thị đẹp
    var displayDate: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "vi_VN")
        f.dateFormat = "EEEE, 'ngày' d 'thg' M"
        return f.string(from: createdAt).capitalized
    }
}
