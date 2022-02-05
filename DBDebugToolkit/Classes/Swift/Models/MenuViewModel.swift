public final class MenuViewModel: ObservableObject {
    let performanceToolkit: DBPerformanceToolkit
    let consoleOutputCaptor: DBConsoleOutputCaptor
    let networkToolkit: DBNetworkToolkit
    let userInterfaceToolkit: DBUserInterfaceToolkit
    let locationToolkit: DBLocationToolkit
    let coreDataToolkit: DBCoreDataToolkit
    let crashReportsToolkit: DBCrashReportsToolkit
    let deviceInfoProvider: DBDeviceInfoProvider
    let customVariables: [String: DBCustomVariable]
    let customActions: [DBCustomAction]
    let menuDismissAction: () -> Void

    init(
        performanceToolkit: DBPerformanceToolkit,
        consoleOutputCaptor: DBConsoleOutputCaptor,
        networkToolkit: DBNetworkToolkit,
        userInterfaceToolkit: DBUserInterfaceToolkit,
        locationToolkit: DBLocationToolkit,
        coreDataToolkit: DBCoreDataToolkit,
        crashReportsToolkit: DBCrashReportsToolkit,
        deviceInfoProvider: DBDeviceInfoProvider,
        customVariables: [String: DBCustomVariable],
        customActions: [DBCustomAction],
        menuDismissAction: @escaping () -> Void
    ) {
        self.performanceToolkit = performanceToolkit
        self.consoleOutputCaptor = consoleOutputCaptor
        self.networkToolkit = networkToolkit
        self.userInterfaceToolkit = userInterfaceToolkit
        self.locationToolkit = locationToolkit
        self.coreDataToolkit = coreDataToolkit
        self.crashReportsToolkit = crashReportsToolkit
        self.deviceInfoProvider = deviceInfoProvider
        self.customVariables = customVariables
        self.customActions = customActions
        self.menuDismissAction = menuDismissAction
    }

    func applicationSettingsTapped() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(url)
    }
}
