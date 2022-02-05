import SwiftUI

struct LocationView: UIViewControllerRepresentable {
    let locationToolkit: DBLocationToolkit

    func makeUIViewController(context: Context) -> DBLocationTableViewController {
        let viewController = DBLocationTableViewController()
        viewController.locationToolkit = locationToolkit
        return viewController
    }

    func updateUIViewController(_ uiViewController: DBLocationTableViewController, context: Context) {}
}
