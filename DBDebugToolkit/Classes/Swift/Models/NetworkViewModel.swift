import SwiftUI

final class NetworkViewModel: NSObject, ObservableObject {
    let networkToolkit: DBNetworkToolkit
    @Published var requestModels: [DBRequestModel]

    init(networkToolkit: DBNetworkToolkit) {
        self.networkToolkit = networkToolkit
        requestModels = networkToolkit.savedRequests
        super.init()
        self.networkToolkit.delegate = self
    }

    func filter(_ string: String) {
        guard !string.isEmpty else {
            requestModels = networkToolkit.savedRequests
            return
        }
        
        let searchString = string.lowercased()
        requestModels = networkToolkit.savedRequests.filter {
            $0.httpMethod.lowercased().contains(searchString) ||
                $0.responseDescription.lowercased().contains(searchString) ||
                $0.url.relativePath.lowercased().contains(searchString) ||
                (($0.url.host?.lowercased().contains(searchString)) != false)
        }
    }
}

// MARK: - DBNetworkToolkitDelegate

extension NetworkViewModel: DBNetworkToolkitDelegate {
    func networkDebugToolkitDidUpdateRequestsList(_ networkToolkit: DBNetworkToolkit!) {
        requestModels = networkToolkit.savedRequests
    }

    func networkDebugToolkit(_ networkToolkit: DBNetworkToolkit!, didUpdateRequestAt index: Int) {

    }

    func networkDebugToolkit(_ networkToolkit: DBNetworkToolkit!, didSetEnabled enabled: Bool) {

    }
}
