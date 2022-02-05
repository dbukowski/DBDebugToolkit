import SwiftUI

struct FilesView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DBFilesTableViewController {
        DBFilesTableViewController()
    }

    func updateUIViewController(_ uiViewController: DBFilesTableViewController, context: Context) {}
}


