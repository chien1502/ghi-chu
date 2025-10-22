import Foundation
import SQLite3
import Darwin // để dùng unlink(), errno, strerror

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private let dbPath: String = "notes.sqlite"
    private var db: OpaquePointer?

    private init() {
        db = openDatabase()
        createTable()
    }

    // MARK: - Mở hoặc khôi phục CSDL
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)

        var dbPointer: OpaquePointer? = nil
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX

        func tryOpen() -> Bool {
            if sqlite3_open_v2(fileURL.path, &dbPointer, flags, nil) == SQLITE_OK {
                print("✅ Đã mở CSDL tại: \(fileURL.path)")
                return true
            } else {
                if dbPointer != nil {
                    sqlite3_close(dbPointer)
                    dbPointer = nil
                }
                return false
            }
        }

        // 🔹 Thử mở CSDL lần đầu
        if tryOpen() {
            return dbPointer
        }

        print("⚠️ Không thể mở CSDL (có thể bị khoá hoặc hỏng). Thử reset...")

        // 🔹 Xóa file WAL / SHM để giải phóng lock
        let paths = [
            fileURL.path,
            fileURL.path + "-wal",
            fileURL.path + "-shm"
        ]

        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    print("🗑️ Đã xoá file: \(path)")
                } catch {
                    print("⚠️ Không thể xoá file bằng FileManager: \(path). Thử unlink()...")

                    let cPath = (path as NSString).utf8String
                    if let cPath = cPath {
                        if unlink(cPath) == 0 {
                            print("🗑️ unlink() thành công cho \(path)")
                        } else {
                            let e = errno
                            let errStr = String(cString: strerror(e))
                            print("❌ unlink() thất bại cho \(path): errno=\(e) (\(errStr))")
                        }
                    }
                }
            }
        }

        // 🔹 Thử mở lại
        if tryOpen() {
            print("✅ Đã khôi phục và mở lại CSDL thành công.")
            return dbPointer
        }

        print("🚫 Vẫn không thể tạo lại CSDL.")
        return nil
    }

    // MARK: - Tạo bảng notes
    private func createTable() {
        guard db != nil else {
            print("⚠️ Không thể tạo bảng vì DB chưa mở.")
            return
        }

        let createTableString = """
        CREATE TABLE IF NOT EXISTS notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        dateISO TEXT);
        """

        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("✅ Bảng notes đã sẵn sàng.")
            } else {
                print("⚠️ Không thể tạo bảng notes.")
            }
        } else {
            print("⚠️ Lỗi prepare createTable.")
        }
        sqlite3_finalize(statement)
    }

    // MARK: - Thêm ghi chú
    func insertNote(title: String, content: String, date: Date = Date()) -> Int64? {
        guard db != nil else {
            print("⚠️ Không thể thêm ghi chú vì DB chưa mở.")
            return nil
        }

        let insertSQL = "INSERT INTO notes (title, content, dateISO) VALUES (?, ?, ?);"
        var statement: OpaquePointer? = nil
        var lastID: Int64?

        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = formatter.string(from: date)

            sqlite3_bind_text(statement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (dateStr as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                lastID = sqlite3_last_insert_rowid(db)
                print("✅ Thêm ghi chú thành công, ID: \(lastID!)")
            } else {
                print("⚠️ Không thể thêm ghi chú hoặc không lấy được ID.")
            }
        } else {
            print("⚠️ Lỗi prepare insertNote.")
        }

        sqlite3_finalize(statement)
        return lastID
    }

    // MARK: - Lấy tất cả ghi chú
    func getAllNotes() -> [Note] {
        guard db != nil else {
            print("⚠️ Không thể truy vấn vì DB chưa mở.")
            return []
        }

        var notes: [Note] = []
        let query = "SELECT * FROM notes ORDER BY id DESC;"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let title = String(cString: sqlite3_column_text(statement, 1))
                let content = String(cString: sqlite3_column_text(statement, 2))
                let dateISO = String(cString: sqlite3_column_text(statement, 3))
                notes.append(Note(id: id, title: title, content: content, dateISO: dateISO))
            }
            print("✅ Đã lấy \(notes.count) ghi chú từ DB.")
        } else {
            print("❌ Không thể truy vấn ghi chú.")
        }

        sqlite3_finalize(statement)
        return notes
    }
}
