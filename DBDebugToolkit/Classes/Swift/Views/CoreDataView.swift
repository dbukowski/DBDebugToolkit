import SwiftUI

struct CoreDataView: UIViewControllerRepresentable {
    let coreDataToolkit: DBCoreDataToolkit

    func makeUIViewController(context: Context) -> UIViewController {
        if coreDataToolkit.persistentStoreCoordinators.count == 1 {
            let entitiesTableViewController = DBEntitiesTableViewController()
            entitiesTableViewController.persistentStoreCoordinator = coreDataToolkit.persistentStoreCoordinators.first
            return entitiesTableViewController
        } else {
            let storeCoordinatorsViewController = DBPersistentStoreCoordinatorsTableViewController()
            storeCoordinatorsViewController.coreDataToolkit = coreDataToolkit;
            return storeCoordinatorsViewController
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


