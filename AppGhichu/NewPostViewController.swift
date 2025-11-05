import UIKit

class NewPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
           dismiss(animated: true)
       }

    @IBAction func newPostButtonTapped(_ sender: UIButton) {
        // Mở ComposeViewController để nhập ghi chú mới
        let composeVC = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        composeVC.modalPresentationStyle = .fullScreen
        present(composeVC, animated: true, completion: nil)
    }
}

