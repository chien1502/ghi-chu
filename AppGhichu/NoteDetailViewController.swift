import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!

    var noteTitle: String = ""
    var noteBody: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.text = noteBody
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
