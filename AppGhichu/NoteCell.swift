import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnMore: UIButton!

    // Callback gửi ra MainViewController
    var onMoreTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        // UI
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        cardView.backgroundColor = UIColor.black
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true

        imgIcon.contentMode = .scaleAspectFill
        imgIcon.clipsToBounds = true

        lblMonth.textColor = .white
        lblTitle.textColor = .white
        lblDate.textColor = .white

        // Đảm bảo nút 3 chấm luôn có target
        btnMore.addTarget(self, action: #selector(handleMoreTap), for: .touchUpInside)
    }

    @objc private func handleMoreTap() {
        print("👉 Button 3 chấm được bấm")   // TEST
        onMoreTapped?()
    }

    // Khi cell được reuse → phải reset target
    override func prepareForReuse() {
        super.prepareForReuse()
        onMoreTapped = nil
    }

    func configure(note: Note) {
        lblMonth.text = getMonth(from: note.dateISO)
        lblTitle.text = note.title
        lblDate.text = getFullDate(from: note.dateISO)

        imgIcon.image = UIImage(named: "img_icon") ?? UIImage(systemName: "photo")
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
}
