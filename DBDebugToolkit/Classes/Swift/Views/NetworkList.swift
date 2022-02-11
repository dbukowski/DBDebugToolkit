import SwiftUI

struct NetworkList: View {
    @State var viewModel: NetworkViewModel
    @State var filterString: String = ""

    var body: some View {
        SearchBar(text: Binding<String>(
            get: {
                self.filterString
            }, set: {
                self.filterString = $0
                viewModel.filter($0)
            }
        ))
        .padding(.top, 10)

        List {
            ForEach(viewModel.requestModels, id: \.self) { model in
                NavigationLink(
                    destination: RequestDetails(model: model),
                    label: {
                        HStack {
                            if let image = model.thumbnail {
                                Image(uiImage: image)
                                    .frame(width: 50, height: 50)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    if let method = model.httpMethod {
                                        Text(method.uppercased())
                                            .font(.footnote.weight(.bold))
                                    }

                                    Text(model.url.relativePath)
                                        .font(.footnote)
                                }

                                if let host = model.url.host {
                                    Text(host)
                                        .font(.footnote)
                                }

                                Text(model.responseDescription)
                                    .font(.footnote)
                            }
                        }
                    }
                )

            }
        }
        .navigationBarTitle("Requests")
        .navigationBarItems(
            trailing:  NavigationLink(
                destination: RequestSettings(networkToolkit: viewModel.networkToolkit),
                label: {
                    Text("Settings")
                }
            )
        )
    }
}
