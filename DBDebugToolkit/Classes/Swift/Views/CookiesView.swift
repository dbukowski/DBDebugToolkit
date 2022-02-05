import SwiftUI

struct CookiesView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DBCookiesTableViewController {
        DBCookiesTableViewController()
    }

    func updateUIViewController(_ uiViewController: DBCookiesTableViewController, context: Context) {}
}

