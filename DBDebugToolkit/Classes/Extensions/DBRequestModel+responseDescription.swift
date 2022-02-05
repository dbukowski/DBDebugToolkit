import Foundation

extension DBRequestModel {
    var responseDescription: String {
        var value = ""
        if !finished {
            let dateString = DateFormatter.localizedString(
                from: sendingDate,
                dateStyle: .medium,
                timeStyle: .medium
            )
            value.append("Sent at \(dateString)...")
        } else if didFinishWithError {
            value.append("Error \(errorCode): \(localizedErrorDescription ?? "")")
        } else {
            let formattedValue = String(format: "%.2lfs", duration)
            value.append("\(formattedValue)")
            if let statusCode = statusCode {
                value.append(", HTTP \(statusCode)")
            }
            if let localizedStatusCodeString = localizedStatusCodeString {
                value.append(" - \(localizedStatusCodeString)")
            }
        }

        return value
    }
}
