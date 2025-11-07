import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Tạo cửa sổ và màn hình chính
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = MainViewController()
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()

        // ✅ Gọi hàm thêm ghi chú mẫu và lấy đường link
        if let noteId = DatabaseHelper.shared.insertNote(
            title: "Tiêu đề:",
            content: "Nội dung:",
            date: Date()
        ) {
            let noteLink = "appghichu://note/\(noteId)"
            print("🔗 Đường link ghi chú mới: \(noteLink)")
        } else {
            print("⚠️ Không thể thêm ghi chú hoặc không lấy được ID.")
        }

        return true
    }
}
