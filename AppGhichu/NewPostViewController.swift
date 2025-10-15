//
//  NewPostViewController.swift
//  AppGhichu
//
//  Created by nguyễn xuân chiến on 10/9/25.
//
import UIKit

class NewPostViewController: UIViewController {

    // Closure để gửi dữ liệu về Main
    var onSave: ((_ title: String, _ body: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 22/255, green: 20/255, blue: 50/255, alpha: 1)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func newPostButton(_ sender: UIButton) {
        let composeVC = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        composeVC.modalPresentationStyle = .fullScreen
        // Gán delegate hoặc closure
        composeVC.onSave = { [weak self] title, body in
            self?.onSave?(title, body)
            self?.dismiss(animated: true, completion: nil)
        }
        self.present(composeVC, animated: true, completion: nil)
    }
}

