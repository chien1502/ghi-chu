import UIKit

class EditNoteViewController: UIViewController {

    @IBOutlet weak var allmenu: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    private func showCurrentDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "d 'thg' M, yyyy"

        dateLabel.text = formatter.string(from: Date())
    }
    @IBOutlet weak var moreButton: UIButton!

    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var closeMapButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!

    var note: Note?

    // 🔥 callback gửi dữ liệu về màn trước
    var onSave: ((Note) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fillData()
        showCurrentDate()
    }

    private func setupUI() {
        mapContainerView.layer.cornerRadius = 12
        mapContainerView.clipsToBounds = true
    }

    private func fillData() {
        guard let note = note else { return }

        textView.text = note.content
        dateLabel.text = formatDate(note.createdAt)
        locationLabel.text = "Chuyến thăm"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        return formatter.string(from: date).capitalized
    }

    @IBAction func doneTapped(_ sender: UIButton) {

        // 🔥 cập nhật content
        if var note = note {
            note.content = textView.text
            onSave?(note)   // 🔥 gửi dữ liệu ngược lại
        }

        dismiss(animated: true)
    }
}
