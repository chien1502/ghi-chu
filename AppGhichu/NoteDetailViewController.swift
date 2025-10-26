import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!

    var noteTitle: String = ""
    var noteBody: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI handled by XIB
        titleLabel.text = noteTitle
        bodyTextView.text = noteBody
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        // nếu push thì pop, nếu present thì dismiss
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
