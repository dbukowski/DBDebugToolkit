import Foundation

@objc
public extension Bundle {
    static var applicationName: String {
        main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "unknown"
    }

    static var buildVersion: String {
        main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }

    static var buildNumber: String {
        main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
    }

    static var buildInfoString: String? {
        String(format: "%@, v. %@ (%@)", applicationName, buildVersion, buildNumber)
    }
}
