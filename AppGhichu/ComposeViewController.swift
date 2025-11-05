import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateLabel()
        
        // Ẩn bàn phím khi chạm ra ngoài
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
        
        // Kiểm tra rỗng
        if title.isEmpty && body.isEmpty {
            let alert = UIAlertController(title: "Chưa có nội dung",
                                          message: "Vui lòng nhập ghi chú trước khi lưu.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 🧠 Lưu vào DB
        DatabaseHelper.shared.insertNote(title: title, content: body)
        
        // 🔁 Tìm và quay về màn Main
        if let presentingVC = presentingViewController {
            // Nếu đang có 2 lớp (Compose nằm trên NewPost)
            if let newPostVC = presentingVC as? NewPostViewController,
               let mainVC = newPostVC.presentingViewController {
                dismiss(animated: true) {
                    mainVC.dismiss(animated: false)
                }
                return
            }
        }
        
        // Nếu không có tầng trung gian thì chỉ cần dismiss chính nó
        dismiss(animated: true)
    }
}
