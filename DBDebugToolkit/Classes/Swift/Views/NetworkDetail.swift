import SwiftUI

struct NetworkDetail: UIViewControllerRepresentable {
    let model: DBRequestModel

    func makeUIViewController(context: Context) -> DBRequestDetailsViewController {
        let viewController = DBRequestDetailsViewController()
        viewController.configure(with: model)
        return viewController
    }

    func updateUIViewController(_ uiViewController: DBRequestDetailsViewController, context: Context) {}
}
