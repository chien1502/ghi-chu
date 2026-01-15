import UIKit
var note: Note?
var onEdit: ((Note) -> Void)?

class MoreMenuViewController: UIViewController {

    var onEdit: (() -> Void)?
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
    }

    @IBAction func editTapped(_ sender: UIButton) {

        if let parentVC = presentingViewController {

               dismiss(animated: true) {
                   let vc = EditNoteViewController(nibName: "EditNoteViewController", bundle: nil)
                   vc.modalPresentationStyle = .fullScreen
                   vc.note = note

                   parentVC.present(vc, animated: true)
               }
           }

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}
