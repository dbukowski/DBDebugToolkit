import SwiftUI

struct PerformanceView: UIViewControllerRepresentable {
    let performanceToolkit: DBPerformanceToolkit

    func makeUIViewController(context: Context) -> DBPerformanceTableViewController {
        let viewController = DBPerformanceTableViewController()
        viewController.performanceToolkit = performanceToolkit
        return viewController
    }

    func updateUIViewController(_ uiViewController: DBPerformanceTableViewController, context: Context) {}
}
