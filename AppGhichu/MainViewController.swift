import UIKit

struct IconData {
    let img: String
    let title: String
}

class MainViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteBodyTextView: UITextView!

    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    @IBOutlet weak var emptySubtitleLabel: UILabel!

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var lblNum1: UILabel!
    @IBOutlet weak var lblText1: UILabel!

    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var lblNum2: UILabel!
    @IBOutlet weak var lblText2: UILabel!

    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var lblNum3: UILabel!
    @IBOutlet weak var lblText3: UILabel!

    @IBOutlet weak var tblv: UITableView!
    
    private let db = DatabaseHelper.shared
    private var notes: [Note] = []

    let icons: [IconData] = [
        IconData(img: "icon1", title: "bài viết năm nay"),
        IconData(img: "icon2", title: "từ"),
        IconData(img: "icon3", title: "ngày ghi nhật ký")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDateLabel()
        setupUI()
        setupIcons()
        loadNotesFromDatabase()
        updateIconData()
        updateEmptyState()

        tblv.delegate = self
        tblv.dataSource = self

        let nib = UINib(nibName: "NoteCell", bundle: nil)
        tblv.register(nib, forCellReuseIdentifier: "NoteCell")
        
        tblv.backgroundColor = .black
        tblv.backgroundView = nil
        tblv.separatorStyle = .none
        tblv.showsVerticalScrollIndicator = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotesFromDatabase()
        updateIconData()
        tblv.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        tblv.isHidden = false
        
        if notes.isEmpty {
            emptyImageView.isHidden = false
            emptyTitleLabel.isHidden = false
            emptySubtitleLabel.isHidden = false
        } else {
            emptyImageView.isHidden = true
            emptyTitleLabel.isHidden = true
            emptySubtitleLabel.isHidden = true
        }
    }


    private func setupIcons() {

        btn1.setImage(UIImage(named: icons[0].img), for: .normal)
        lblText1.text = icons[0].title

        btn2.setImage(UIImage(named: icons[1].img), for: .normal)
        lblText2.text = icons[1].title

        btn3.setImage(UIImage(named: icons[2].img), for: .normal)
        lblText3.text = icons[2].title

        btn1.imageView?.contentMode = .scaleAspectFit
        btn2.imageView?.contentMode = .scaleAspectFit
        btn3.imageView?.contentMode = .scaleAspectFit
    }

    private func updateIconData() {
        notes = db.getAllNotes()

        let year = Calendar.current.component(.year, from: Date())
        let countThisYear = notes.filter {
            Calendar.current.component(.year, from: $0.createdAt) == year
        }.count
        lblNum1.text = "\(countThisYear)"

        let keywordCount = notes.filter {
            $0.title.lowercased().contains("từ") ||
            $0.content.lowercased().contains("từ")
        }.count
        lblNum2.text = "\(keywordCount)"

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let uniqueDays = Set(notes.map { formatter.string(from: $0.createdAt) })
        lblNum3.text = "\(uniqueDays.count)"
    }

    private func setupUI() {
        dateLabel.textColor = .lightGray
        noteTitleLabel.textColor = .white
        noteBodyTextView.textColor = .lightGray
        noteBodyTextView.isEditable = false
        noteBodyTextView.backgroundColor = .clear

            noteTitleLabel.backgroundColor = UIColor(white: 0.2, alpha: 1)
            noteTitleLabel.layer.cornerRadius = 10
            noteTitleLabel.clipsToBounds = true
            noteTitleLabel.textAlignment = .left

            noteBodyTextView.textColor = .lightGray
            noteBodyTextView.isEditable = false
            noteBodyTextView.backgroundColor = UIColor(white: 0.18, alpha: 1)
            noteBodyTextView.layer.cornerRadius = 12
            noteBodyTextView.clipsToBounds = true
            
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
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        cell.configure(note: note)
//        cell.contentView.backgroundColor = UIColor.secondarySystemBackground
//        cell.backgroundColor = .clear
//        tableView.backgroundColor = UIColor.black
//        tableView.separatorStyle = .none
        cell.onMoreTapped = { [weak self] in
            self?.showMoreMenu()
        }

        return cell
    }
    func showMoreMenu() {
        let vc = MoreMenuViewController(nibName: "MoreMenuViewController", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
