//
//  AppDelegate.swift
//  AppGhichu
//
//  Created by nguyễn xuân chiến on 4/9/25.
//
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
            title: "Ghi chú đầu tiên",
            content: "Nội dung thử",
            date: "2025-10-12"
        ) {
            let noteLink = "appghichu://note/\(noteId)"
            print("🔗 Đường link ghi chú mới: \(noteLink)")
        } else {
            print("⚠️ Không thể thêm ghi chú hoặc không lấy được ID.")
        }

        return true
    }
}
