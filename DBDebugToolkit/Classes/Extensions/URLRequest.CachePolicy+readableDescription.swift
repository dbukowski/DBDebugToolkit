import Foundation

extension URLRequest.CachePolicy {
    var readableDescription: String {
        switch self {
        case .reloadIgnoringLocalAndRemoteCacheData:
            return "Reload ignoring local and remote cache data"
        case .reloadIgnoringLocalCacheData:
            return "Reload ignoring local cache data"
        case .returnCacheDataElseLoad:
            return "Return cache data else load"
        case .reloadRevalidatingCacheData:
            return "Reload revalidating cache data"
        case .returnCacheDataDontLoad:
            return "Return cache data, don't load"
        case .useProtocolCachePolicy:
            return "Use protocol cache policy"
        case .reloadIgnoringCacheData:
            return "Reload ignoring cache data"
        @unknown default:
            return "unknown"
        }
    }
}
