final class ResourcesViewModel: ObservableObject {
    let coreDataToolkit: DBCoreDataToolkit
    let keychainModel: DBTitleValueListViewModel
    let userDefaultsModel: DBTitleValueListViewModel

    init(
        coreDataToolkit: DBCoreDataToolkit,
        keychainModel: DBTitleValueListViewModel = DBKeychainToolkit(),
        userDefaultsModel: DBTitleValueListViewModel = DBUserDefaultsToolkit()
    ) {
        self.coreDataToolkit = coreDataToolkit
        self.keychainModel = keychainModel
        self.userDefaultsModel = userDefaultsModel
    }
}
