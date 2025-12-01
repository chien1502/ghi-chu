import UIKit

class NoteCell: UITableViewCell {

    // UI đã kéo từ XIB
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnMore: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configure(note: Note) {
        lblMonth.text = getMonth(from: note.dateISO)
        lblTitle.text = note.title
        lblDate.text = getFullDate(from: note.dateISO)

        imgIcon.image = UIImage(named: "icon1")
    }

    private func getMonth(from iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: iso) {
            let month = Calendar.current.component(.month, from: date)
            return "Tháng \(month)"
        }
        return ""
    }

    private func getFullDate(from iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: iso) {
            let df = DateFormatter()
            df.locale = Locale(identifier: "vi_VN")
            df.dateFormat = "EEEE, dd/MM/yyyy"
            return df.string(from: date).capitalized
        }
        return ""
    }

    @IBAction func moreButtonTapped(_ sender: UIButton) {
        print("Nhấn nút ⋯ cho ghi chú: \(lblTitle.text ?? "")")
        // Bạn có thể dùng closure hoặc delegate để thông báo ViewController
    }
}
