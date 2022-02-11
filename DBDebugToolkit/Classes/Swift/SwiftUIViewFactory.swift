import SwiftUI
import UIKit

@objc
public class SwiftUIViewFactory: NSObject {
    @objc
    public static func makeMenuListView(
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
    ) -> UIViewController {
        UIHostingController(
            rootView: MenuList(
                viewModel: .init(
                    performanceToolkit: performanceToolkit,
                    consoleOutputCaptor: consoleOutputCaptor,
                    networkToolkit: networkToolkit,
                    userInterfaceToolkit: userInterfaceToolkit,
                    locationToolkit: locationToolkit,
                    coreDataToolkit: coreDataToolkit,
                    crashReportsToolkit: crashReportsToolkit,
                    deviceInfoProvider: deviceInfoProvider,
                    customVariables: customVariables,
                    customActions: customActions,
                    menuDismissAction: menuDismissAction
                )
            )
        )
    }
}
