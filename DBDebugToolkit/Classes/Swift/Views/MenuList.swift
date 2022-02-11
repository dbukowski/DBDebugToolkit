import SwiftUI

public struct MenuList: View {
    @ObservedObject var viewModel: MenuViewModel
    @Environment(\.presentationMode) private var presentationMode
    public var body: some View {
        List {
            Section(
                header: Text(Bundle.buildInfoString ?? ""),
                footer: Text(viewModel.deviceInfoProvider.deviceInfoString() ?? "")
            ) {
                NavigationLink("Performance", destination: PerformanceView(performanceToolkit: viewModel.performanceToolkit))
                NavigationLink("User Interface", destination: UserInterfaceView(userInterfaceToolkit: viewModel.userInterfaceToolkit))
                NavigationLink("Network", destination: NetworkList(viewModel: .init( networkToolkit: viewModel.networkToolkit)))
                NavigationLink("Resources", destination: ResourcesList(viewModel: .init(coreDataToolkit: viewModel.coreDataToolkit)))
                NavigationLink("Console", destination: ConsoleView(viewModel: .init(consoleOutputCaptor: viewModel.consoleOutputCaptor, deviceInfoProvider: viewModel.deviceInfoProvider)))
                NavigationLink("Location", destination: LocationView(locationToolkit: viewModel.locationToolkit))
                NavigationLink("Crash reports", destination: CrashReportsView(crashReportsToolkit: viewModel.crashReportsToolkit))
                NavigationLink("Custom variables", destination: CustomVariablesView(customVariables: viewModel.customVariables))
                NavigationLink("Custom actions", destination: CustomActionsView(customActions: viewModel.customActions))
                Text("Application settings")
                    .onTapGesture {
                        viewModel.applicationSettingsTapped()
                    }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Menu")
        .navigationBarItems(
            leading: Button(
                action: viewModel.menuDismissAction,
                label: {
                    Text("Cancel")
                }
            )
        )
    }
}
