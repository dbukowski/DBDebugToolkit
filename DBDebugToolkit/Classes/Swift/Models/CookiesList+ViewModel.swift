import SwiftUI

extension CookiesList {
    final class ViewModel: ObservableObject {
        @Published private(set) var cookies: [HTTPCookie]

        init() {
            cookies = HTTPCookieStorage.shared.cookies ?? []
        }

        func deleteCookie(at offsets: IndexSet) {
            let cookiesToDelete = offsets.map { cookies[$0] }
            cookies.remove(atOffsets: offsets)
            cookiesToDelete.forEach {
                HTTPCookieStorage.shared.deleteCookie($0)
            }

            cookies = HTTPCookieStorage.shared.cookies ?? []
        }

        func deleteCookie(_ cookie: HTTPCookie) {
            guard let index = cookies.firstIndex(of: cookie) else {
                return
            }
            cookies.remove(at: index)
            HTTPCookieStorage.shared.deleteCookie(cookie)
            cookies = HTTPCookieStorage.shared.cookies ?? []
        }
    }
}
