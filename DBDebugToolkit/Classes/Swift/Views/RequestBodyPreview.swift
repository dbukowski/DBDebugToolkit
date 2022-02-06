import SwiftUI
import UIKit

struct RequestBodyPreview: UIViewControllerRepresentable {
    let model: DBRequestModel
    let mode: DBBodyPreviewViewControllerMode

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "DBBodyPreviewViewController", bundle: Bundle.debugToolkit())
        let viewController = storyboard.instantiateInitialViewController() as? DBBodyPreviewViewController
        viewController?.configure(with: model, mode: mode)
        return viewController ?? UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
