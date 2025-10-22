import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyLabel: UILabel!
    @IBOutlet weak var notesContainerView: UIView!

    // MARK: - Biến dữ liệu
    var db = DatabaseHelper.shared
    var notes: [Note] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDateLabel()
        loadNotesFromDatabase()
    }

    // MARK: - Cấu hình giao diện
    private func setupUI() {
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dateLabel.textAlignment = .left

        noteTitleLabel.textColor = .white
        noteBodyLabel.textColor = .lightGray
        notesContainerView.isHidden = true
    }

    private func setupDateLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        dateLabel.text = formatter.string(from: Date()).capitalized
    }

    // MARK: - Load ghi chú từ DB
    func loadNotesFromDatabase() {
        notes = db.getAllNotes()
        print("Có \(notes.count) ghi chú từ DB:", notes)
        for note in notes {
            print("ID: \(note.id), Tiêu đề: \(note.title), Nội dung: \(note.content), Ngày: \(note.dateISO)")
        }

        if let latestNote = notes.last {
            noteTitleLabel.text = latestNote.title
            noteBodyLabel.text = latestNote.content
            notesContainerView.isHidden = false
        } else {
            notesContainerView.isHidden = true
        }
    }

    // MARK: - Nút + thêm ghi chú
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let composeVC = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        composeVC.delegate = self   // ✅ Dùng delegate duy nhất
        present(composeVC, animated: true, completion: nil)
    }
}

// MARK: - Delegate từ ComposeViewController
extension MainViewController: ComposeViewControllerDelegate {
    func didSaveNote(title: String, body: String) {
        // ✅ Lưu vào DB
        _ = db.insertNote(title: title, content: body)

        // ✅ Cập nhật lại giao diện
        loadNotesFromDatabase()
    }
}
