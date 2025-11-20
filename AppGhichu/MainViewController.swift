import UIKit

struct IconData {
    let img: String
    let title: String
}

class MainViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyTextView: UITextView!

    private let db = DatabaseHelper.shared
    private var notes: [Note] = []

    // 3 icon tương ứng
    let icons: [IconData] = [
        IconData(img: "icon1", title: "Nhật ký"),
        IconData(img: "icon2", title: "Từ"),
        IconData(img: "icon3", title: "Năm nay")
    ]

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDateLabel()
        setupUI()
        setupTableView()
        loadNotesFromDatabase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotesFromDatabase()
    }

    private func setupUI() {
        dateLabel.textColor = .lightGray
        noteTitleLabel.textColor = .white
        noteBodyTextView.textColor = .lightGray
        noteBodyTextView.isEditable = false
        noteBodyTextView.backgroundColor = .clear
    }

    private func setupDateLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "EEEE, 'ngày' d 'thg' M"
        dateLabel.text = formatter.string(from: Date()).capitalized
    }

    func loadNotesFromDatabase() {
        notes = db.getAllNotes()
        guard let latestNote = notes.first else {
            noteTitleLabel.text = "Chưa có ghi chú"
            noteBodyTextView.text = ""
            return
        }

        noteTitleLabel.text = latestNote.title
        noteBodyTextView.text = latestNote.content
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newPostVC = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
        newPostVC.modalPresentationStyle = .fullScreen
        present(newPostVC, animated: true)
    }

    // MARK: TableView Setup
    private func setupTableView() {

        // đặt vị trí tableView nằm dưới noteBody
        tableView.frame = CGRect(
            x: 0,
            y: noteBodyTextView.frame.maxY + 20,
            width: view.bounds.width,
            height: 150
        )

        tableView.delegate = self
        tableView.dataSource = self

        // Cho dùng heightForRowAt
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        view.addSubview(tableView)

        let nib = UINib(nibName: "SummaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SummaryCell")

        tableView.separatorStyle = .none
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1   // chỉ có 3 icon trong 1 cell
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell

        // set icon (bạn thay tên ảnh nếu dùng Assets riêng)
        cell.configure(
            icon1: UIImage(named: icons[0].img),
            title1: icons[0].title,
            icon2: UIImage(named: icons[1].img),
            title2: icons[1].title,
            icon3: UIImage(named: icons[2].img),
            title3: icons[2].title
        )

        return cell
    }

    // 👉 CHỈNH CHIỀU CAO CELL TẠI ĐÂY
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70   // chuẩn nhất giống app mẫu
    }

}
