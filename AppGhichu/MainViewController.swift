import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyTextView: UITextView!

    private let db = DatabaseHelper.shared
    private var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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

    private func setupDateLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        dateLabel.text = formatter.string(from: Date()).capitalized
    }

    func loadNotesFromDatabase() {
        notes = db.getAllNotes()

        guard let latestNote = notes.first else {
            noteTitleLabel.text = "Chưa có ghi chú"
            noteBodyTextView.text = ""
            return
        }

        noteTitleLabel.text = latestNote.title
        noteBodyTextView.text = latestNote.content

        print("🆕 Hiển thị ghi chú ID mới nhất: \(latestNote.id)")
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newPostVC = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
        newPostVC.modalPresentationStyle = .fullScreen
        present(newPostVC, animated: true)
    }
}
