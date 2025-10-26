import UIKit

// Compose sẽ báo ngược cho NewPost (ComposeViewControllerDelegate)
protocol ComposeViewControllerDelegate: AnyObject {
    func didSaveNote(title: String, body: String)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    weak var delegate: ComposeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI handled by XIB
        setupDateLabel()
        // optional: add gesture to hide keyboard if you want (no layout change)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() { view.endEditing(true) }

    private func setupDateLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        dateLabel.text = formatter.string(from: Date()).capitalized
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        let title = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let body = (bodyTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if title.isEmpty && body.isEmpty {
            let alert = UIAlertController(title: "Chưa có nội dung", message: "Vui lòng nhập ghi chú trước khi lưu.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // 1) Gọi delegate (NewPost sẽ implement)
        delegate?.didSaveNote(title: title, body: body)

        // 2) Đóng Compose để trả về NewPost
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
