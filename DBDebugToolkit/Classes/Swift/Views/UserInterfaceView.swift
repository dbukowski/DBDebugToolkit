import SwiftUI

struct UserInterfaceView: UIViewControllerRepresentable {
    class Delegate: NSObject, DBUserInterfaceTableViewControllerDelegate {
        func userInterfaceTableViewControllerDidOpenDebuggingInformationOverlay(_ userInterfaceTableViewController: DBUserInterfaceTableViewController!) {

        }
    }

    let userInterfaceToolkit: DBUserInterfaceToolkit
    let delegate: Delegate = Delegate()

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "DBUserInterfaceViewController", bundle: Bundle.debugToolkit())
        let viewController = storyboard.instantiateInitialViewController() as? DBUserInterfaceTableViewController
        viewController?.userInterfaceToolkit = userInterfaceToolkit
        viewController?.delegate = self.delegate
        return viewController ?? UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
