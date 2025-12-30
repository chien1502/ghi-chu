import Foundation

struct Note {
    var id: Int64
    var title: String
    var content: String
    var dateISO: String
    var createdAt: Date

    // Init khi tạo note mới (date mặc định = thời điểm hiện tại)
    init(id: Int64 = 0, title: String, content: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = date

        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateISO = fmt.string(from: date)
    }

    // Init khi lấy từ DB (dateISO có sẵn)
    init(id: Int64, title: String, content: String, dateISO: String) {
        self.id = id
        self.title = title
        self.content = content
        self.dateISO = dateISO

        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdAt = fmt.date(from: dateISO) ?? Date()
    }

    // Helper
    var date: Date {
        return createdAt
    }

    var displayDate: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "vi_VN")
        f.dateFormat = "EEEE, 'ngày' d 'thg' M"
        return f.string(from: createdAt).capitalized
    }
}
