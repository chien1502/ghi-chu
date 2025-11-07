import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyTextView: UITextView!

    // MARK: - Dữ liệu
    private let db = DatabaseHelper.shared
    private var notes: [Note] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Kiểm tra nil (nếu có)
        if dateLabel == nil || noteTitleLabel == nil || noteBodyTextView == nil {
            print("⚠️ Một hoặc nhiều IBOutlet chưa được nối trong Storyboard!")
            return
        }

        setupDateLabel()
        setupUI()
        loadNotesFromDatabase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loadNotesFromDatabase()
        }
    }

    // MARK: - Cấu hình UI
    private func setupUI() {
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)

        noteTitleLabel.textColor = .white
        noteTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        noteBodyTextView.textColor = .lightGray
        noteBodyTextView.font = UIFont.systemFont(ofSize: 16)
        noteBodyTextView.isEditable = false
        noteBodyTextView.backgroundColor = .clear
    }

    // MARK: - Cập nhật ngày tháng
    private func setupDateLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        dateLabel.text = formatter.string(from: Date()).capitalized
    }

    // MARK: - Load ghi chú
    func loadNotesFromDatabase() {
        // Lấy danh sách đã được ORDER BY id DESC trong DatabaseHelper
        notes = db.getAllNotes()

        guard let latestNote = notes.first else {
            noteTitleLabel.text = "Chưa có ghi chú"
            noteBodyTextView.text = ""
            return
        }

        // Hiển thị ghi chú mới nhất
        noteTitleLabel.text = latestNote.title
        noteBodyTextView.text = latestNote.content

        print("🆕 Hiển thị ghi chú ID mới nhất: \(latestNote.id)")
    }
    // MARK: - Nút thêm ghi chú
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newPostVC = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
        newPostVC.modalPresentationStyle = .fullScreen
        present(newPostVC, animated: true)
    }
}
