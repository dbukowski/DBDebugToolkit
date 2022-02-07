import SwiftUI

struct ResourcesList: View {
    let viewModel: ResourcesViewModel

    var body: some View {
        List {
            NavigationLink("Files", destination: FilesView())
            NavigationLink("User defaults", destination: TitleValueView(viewModel: viewModel.userDefaultsModel))
            NavigationLink("Keychain", destination: TitleValueView(viewModel: viewModel.keychainModel))
            NavigationLink("CoreData", destination: CoreDataView(coreDataToolkit: viewModel.coreDataToolkit))
            NavigationLink("Cookies", destination: CookiesList(viewModel: .init()))
        }
    }
}
