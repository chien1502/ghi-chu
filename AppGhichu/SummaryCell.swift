import UIKit

class SummaryCell: UITableViewCell {

    // 3 icon
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!

    // 3 label
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // icon trắng giống Apple Notes
        btn1.tintColor = .white
        btn2.tintColor = .white
        btn3.tintColor = .white

        // đảm bảo icon không bị méo
        btn1.imageView?.contentMode = .scaleAspectFit
        btn2.imageView?.contentMode = .scaleAspectFit
        btn3.imageView?.contentMode = .scaleAspectFit

        // font label
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lbl1.font = font
        lbl2.font = font
        lbl3.font = font

        // màu chữ nhạt
        lbl1.textColor = .lightGray
        lbl2.textColor = .lightGray
        lbl3.textColor = .lightGray
    }

    func configure(
        icon1: UIImage?, title1: String,
        icon2: UIImage?, title2: String,
        icon3: UIImage?, title3: String
    ) {
        // set icon
        btn1.setImage(icon1, for: .normal)
        btn2.setImage(icon2, for: .normal)
        btn3.setImage(icon3, for: .normal)

        // set text
        lbl1.text = title1
        lbl2.text = title2
        lbl3.text = title3
    }
}
