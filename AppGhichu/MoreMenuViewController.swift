import UIKit

class MoreMenuViewController: UIViewController {

    // View bao quanh menu
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Nền mờ bên ngoài
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        // Bo góc menu
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
    }

    @IBAction func editTapped(_ sender: UIButton) {
        dismiss(animated: true)
        print("Sửa")
    }

    @IBAction func bookmarkTapped(_ sender: UIButton) {
        dismiss(animated: true)
        print("Dấu trang")
    }

    @IBAction func printTapped(_ sender: UIButton) {
        dismiss(animated: true)
        print("In")
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        dismiss(animated: true)
        print("Xóa")
    }

    // Bấm ra ngoài tắt
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}
