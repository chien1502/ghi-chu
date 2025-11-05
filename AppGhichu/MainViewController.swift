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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 🔄 Khi quay lại từ Compose, load lại dữ liệu mới
        loadNotesFromDatabase()
    }

    // MARK: - Cấu hình giao diện
    private func setupUI() {
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
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
        if let latestNote = notes.last {
            noteTitleLabel.text = latestNote.title
            noteBodyLabel.text = latestNote.content
            notesContainerView.isHidden = false
        } else {
            notesContainerView.isHidden = true
        }
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
            let newPostVC = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
            newPostVC.modalPresentationStyle = .fullScreen
            present(newPostVC, animated: true)
        }
}
