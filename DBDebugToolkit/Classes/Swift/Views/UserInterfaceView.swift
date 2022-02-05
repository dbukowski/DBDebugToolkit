import SwiftUI

struct UserInterfaceView: UIViewControllerRepresentable {
    class Delegate: NSObject, DBUserInterfaceTableViewControllerDelegate {
        func userInterfaceTableViewControllerDidOpenDebuggingInformationOverlay(_ userInterfaceTableViewController: DBUserInterfaceTableViewController!) {

        }
    }

    let userInterfaceToolkit: DBUserInterfaceToolkit
    let delegate: Delegate = Delegate()

    func makeUIViewController(context: Context) -> DBUserInterfaceTableViewController {
        let viewController = DBUserInterfaceTableViewController()
        viewController.userInterfaceToolkit = userInterfaceToolkit
        viewController.delegate = self.delegate
        return viewController
    }

    func updateUIViewController(_ uiViewController: DBUserInterfaceTableViewController, context: Context) {}
}
