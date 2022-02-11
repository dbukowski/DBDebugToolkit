final class ConsoleViewModel: NSObject, ObservableObject {
    let consoleOutputCaptor: DBConsoleOutputCaptor
    let deviceInfoProvider: DBDeviceInfoProvider
    @Published var consoleOutput: String
    @Published var isConsoleOutputPause: Bool = false

    init(
        consoleOutputCaptor: DBConsoleOutputCaptor,
        deviceInfoProvider: DBDeviceInfoProvider
    ) {
        self.consoleOutputCaptor = consoleOutputCaptor
        self.deviceInfoProvider = deviceInfoProvider
        self.consoleOutput = consoleOutputCaptor.consoleOutput
        super.init()
        self.consoleOutputCaptor.delegate = self
    }

    func pauseConsoleOutput() {
        isConsoleOutputPause.toggle()
    }

    func clearConsoleOutput() {
        consoleOutput = ""
        consoleOutputCaptor.clearConsoleOutput()
    }

    func shareConsoleOutput() {
        let content = """
        Device model: \(deviceInfoProvider.deviceModel() ?? "unknown"))
        System version: \(deviceInfoProvider.systemVersion() ?? "unknown")
        Console output:\(consoleOutput)
        """

        let activityVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        let rootViewController = UIWindow.keyWindow?.rootViewController
        if let presentedViewController = rootViewController?.presentedViewController {
            presentedViewController.present(activityVC, animated: true)
        } else {
            rootViewController?.present(activityVC, animated: true)
        }
    }
}

// MARK: - DBConsoleOutputCaptorDelegate

extension ConsoleViewModel: DBConsoleOutputCaptorDelegate {
    func consoleOutputCaptorDidUpdateOutput(_ consoleOutputCaptor: DBConsoleOutputCaptor!) {
        guard !isConsoleOutputPause else {
            return
        }
        consoleOutput = consoleOutputCaptor.consoleOutput
    }

    func consoleOutputCaptor(_ consoleOutputCaptor: DBConsoleOutputCaptor!, didSetEnabled enabled: Bool) {

    }
}
