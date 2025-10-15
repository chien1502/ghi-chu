//
//  NoteDetailViewController.swift
//  AppGhichu
//
//  Created by nguyễn xuân chiến on 9/10/25.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!

    var noteTitleText: String = ""
    var noteBodyText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        titleLabel.textColor = .white
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .clear

        titleLabel.text = noteTitleText
        bodyTextView.text = noteBodyText
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
