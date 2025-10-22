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

    var noteTitle: String = ""
    var noteBody: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        titleLabel.textColor = .white
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .clear

        titleLabel.text = noteTitle
        bodyTextView.text = noteBody
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
