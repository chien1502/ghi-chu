import UIKit

class NewPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
           dismiss(animated: true)
       }

    @IBAction func newPostButtonTapped(_ sender: UIButton) {
        let composeVC = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        
        // ✅ Gọi callback khi note được lưu
        composeVC.onNoteSaved = {
            // Tìm MainViewController và reload lại dữ liệu
            if let presentingVC = self.presentingViewController as? MainViewController {
                presentingVC.loadNotesFromDatabase()
            }
        }
        
        composeVC.modalPresentationStyle = .fullScreen
        present(composeVC, animated: true, completion: nil)
    }

}

