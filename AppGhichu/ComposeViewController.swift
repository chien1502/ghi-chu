import UIKit

// MARK: - Gửi dữ liệu ngược lại (delegate)
protocol ComposeViewControllerDelegate: AnyObject {
    func didSaveNote(title: String, body: String)
}

class ComposeViewController: UIViewController {
    var onSave: ((String, String) -> Void)?
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    // ❌ Đã bỏ closure và notification — chỉ dùng delegate
    weak var delegate: ComposeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        titleTextField.textColor = .white
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .clear
        bodyTextView.font = UIFont.systemFont(ofSize: 16)
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Tiêu đề",
            attributes: [.foregroundColor: UIColor.gray]
        )

        setupDateLabel()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func setupDateLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        let dateString = formatter.string(from: Date()).capitalized
        dateLabel.text = dateString
        dateLabel.textColor = .white
    }

    // MARK: - Khi nhấn nút Xong
    @IBAction func doneButtonTapped(_ sender: Any) {
        let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let body = bodyTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if title.isEmpty && body.isEmpty {
            showAlert(title: "Chưa có nội dung", message: "Vui lòng nhập ghi chú trước khi lưu.")
            return
        }

        // ✅ Chỉ dùng delegate để báo ngược về MainViewController
        delegate?.didSaveNote(title: title, body: body)

        // ✅ Đóng màn hiện tại, không cần alert “Đã lưu”
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Hiển thị alert
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
