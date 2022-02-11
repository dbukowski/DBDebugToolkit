import SwiftUI

struct CrashReportsView: UIViewControllerRepresentable {
    let crashReportsToolkit: DBCrashReportsToolkit

    func makeUIViewController(context: Context) -> DBCrashReportsTableViewController {
        let viewController = DBCrashReportsTableViewController()
        viewController.crashReportsToolkit = crashReportsToolkit
        return viewController
    }

    func updateUIViewController(_ uiViewController: DBCrashReportsTableViewController, context: Context) {}
}
