import SwiftUI

struct CustomActionsView: UIViewControllerRepresentable {
    let customActions: [DBCustomAction]

    func makeUIViewController(context: Context) -> DBCustomActionsTableViewController {
        let viewController = DBCustomActionsTableViewController()
        viewController.customActions = customActions
        return viewController
    }

    func updateUIViewController(_ uiViewController: DBCustomActionsTableViewController, context: Context) {}
}

