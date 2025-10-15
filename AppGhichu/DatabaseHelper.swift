import Foundation
import SQLite3

final class DatabaseHelper {
    static let shared = DatabaseHelper()
    private var db: OpaquePointer?

    private init() {
        openDatabase()
    }

    // MARK: - Đường dẫn file DB trong Documents
    private func getDBPath() -> String {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[0]
        let dbPath = docURL.appendingPathComponent("appghichu.sqlite").path
        return dbPath
    }

    // MARK: - Mở / Tạo database
    func openDatabase() {
        let path = getDBPath()
        print("📁 Database path:", path)
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("✅ Mở hoặc tạo database thành công.")
            createTable() // tạo bảng sau khi mở DB
        } else {
            print("❌ Không thể mở database.")
        }
    }

    // MARK: - Tạo bảng notes
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT
        );
        """
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ Tạo bảng notes thành công.")
            } else {
                print("⚠️ Không thể tạo bảng.")
            }
        } else {
            print("❌ Lỗi khi chuẩn bị lệnh SQL.")
        }
        sqlite3_finalize(stmt)
    }

    // MARK: - Chèn ghi chú mới
    func insertNote(title: String, content: String, date: String) -> Int64? {
        var noteId: Int64?

        let insertSQL = "INSERT INTO notes (title, content, date) VALUES (?, ?, ?);"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (date as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("✅ Thêm ghi chú thành công.")
                noteId = sqlite3_last_insert_rowid(db) // <-- Lấy ID vừa thêm
            } else {
                print("❌ Không thể thêm ghi chú.")
            }
        } else {
            print("❌ Lỗi câu lệnh SQL.")
        }

        sqlite3_finalize(statement)
        return noteId
    }

}

