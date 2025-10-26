import UIKit


protocol NewPostViewControllerDelegate: AnyObject {
    func newPostViewController(_ controller: NewPostViewController, didCreateNoteWithTitle title: String, body: String)
}

class NewPostViewController: UIViewController {

    
    weak var delegate: NewPostViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func newPostButtonTapped(_ sender: UIButton) {
        let composeVC = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        composeVC.delegate = self
        composeVC.modalPresentationStyle = .fullScreen
        present(composeVC, animated: true, completion: nil)
    }
}

// MARK: - Nhận callback từ ComposeViewController
extension NewPostViewController: ComposeViewControllerDelegate {
    func didSaveNote(title: String, body: String) {
        // Báo ngược về Main (qua delegate)
        delegate?.newPostViewController(self, didCreateNoteWithTitle: title, body: body)

        // Đóng luôn NewPost để quay lại Main
        dismiss(animated: true, completion: nil)
    }
}
