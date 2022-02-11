import SwiftUI

struct CookiesList: View {
    @ObservedObject var viewModel: ViewModel
    @State var selectedCookie: HTTPCookie?

    var body: some View {
        List {
            ForEach(viewModel.cookies, id: \.self) { cookie in
                VStack(alignment: .leading) {
                    Text("Name: ").fontWeight(.bold) + Text(cookie.name)
                    Text("Domain: ").fontWeight(.bold) + Text(cookie.domain)
                }.onTapGesture {
                    selectedCookie = cookie
                }
            }
            .onDelete(perform: viewModel.deleteCookie)
        }

        if let selectedCookie = selectedCookie {
            NavigationLink(
                destination: details(cookie: selectedCookie),
                isActive: .constant(true),
                label: EmptyView.init
            )
        }
    }
}

private extension CookiesList {
    @ViewBuilder
    func details(cookie: HTTPCookie) -> some View {
        if let propertieKeys = cookie.properties?.keys {
            let properties = Array(propertieKeys)
            List(properties, id: \.self) { key in
                if let value = cookie.properties?[key] {
                    VStack(alignment: .leading) {
                        Text(key.rawValue)
                        Text("\(String(describing: value))")
                            .font(.footnote)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(
                trailing:
                    Button(
                        action: {
                            selectedCookie = nil
                            viewModel.deleteCookie(cookie)
                        },
                        label: {
                            Image(systemName: "trash")
                        }
                    )
            )
        }
    }
}
