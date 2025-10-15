import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets (kết nối trong Storyboard/XIB)
    @IBOutlet weak var notesContainerView: UIView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel! // nếu có

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 13/255, green: 12/255, blue: 29/255, alpha: 1)

        // Cấu hình view + label cơ bản (đảm bảo không cắt chữ)
        configureAppearance()

        // Hiển thị (nếu có) ghi chú đã lưu
        displaySavedNote()

        // Thêm gesture mở chi tiết khi chạm vào vùng ghi chú
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openNoteDetail))
        notesContainerView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Appearance
    private func configureAppearance() {
        notesContainerView.layer.cornerRadius = 12
        notesContainerView.layer.masksToBounds = true
        notesContainerView.backgroundColor = .black

        noteTitleLabel.textColor = .white
        noteTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        noteTitleLabel.numberOfLines = 0
        noteTitleLabel.lineBreakMode = .byWordWrapping
        noteTitleLabel.textAlignment = .left

        noteBodyLabel.textColor = .white
        noteBodyLabel.font = UIFont.systemFont(ofSize: 16)
        noteBodyLabel.numberOfLines = 0
        noteBodyLabel.lineBreakMode = .byWordWrapping
        noteBodyLabel.textAlignment = .left

        // 🧩 Xóa toàn bộ constraint top cũ của bodyLabel và thêm mới
        noteBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteBodyLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 4) // cách chỉ 4pt
        ])

        dateLabel?.textColor = .lightGray
        dateLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        dateLabel?.textAlignment = .left
        setupDateLabel()
    }


    // MARK: - Hiển thị ghi chú
    func displaySavedNote() {
        let title = UserDefaults.standard.string(forKey: "noteTitle") ?? ""
        let body = UserDefaults.standard.string(forKey: "noteBody") ?? ""

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
           body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notesContainerView.isHidden = true
            return
        }

        noteTitleLabel.text = title
        noteBodyLabel.text = body
        notesContainerView.isHidden = false
        setupDateLabel()
    }

    // MARK: - Nút ➕ thêm ghi chú
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newPostVC = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
        newPostVC.onSave = { [weak self] title, body in
            guard let self = self else { return }
            UserDefaults.standard.set(title, forKey: "noteTitle")
            UserDefaults.standard.set(body, forKey: "noteBody")
            self.displaySavedNote()
            self.dismiss(animated: true, completion: nil)
        }
        present(newPostVC, animated: true, completion: nil)
    }

    // MARK: - Mở chi tiết ghi chú
    @objc func openNoteDetail() {
        guard let title = UserDefaults.standard.string(forKey: "noteTitle"),
              let body = UserDefaults.standard.string(forKey: "noteBody"),
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
              !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let detailVC = NoteDetailViewController(nibName: "NoteDetailViewController", bundle: nil)
        detailVC.noteTitleText = title
        detailVC.noteBodyText = body
        present(detailVC, animated: true, completion: nil)
    }

    // MARK: - Ngày hiển thị
    private func setupDateLabel() {
        guard dateLabel != nil else { return }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, d 'Thg' M"
        dateLabel.text = formatter.string(from: Date()).capitalized
    }
}

