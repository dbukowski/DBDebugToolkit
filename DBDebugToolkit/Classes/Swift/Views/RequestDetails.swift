import SwiftUI

struct RequestDetails: View {
    let model: DBRequestModel
    @State private var selection = 0
    var body: some View {
        List {
            Section {
                Picker("Request/Response picker", selection: $selection) {
                    Text("Request").tag(0)
                    Text("Response").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            if selection == 0 {
                requestSelection()
            } else {
                responseSelection()
            }
        }
        .listStyle(GroupedListStyle())
    }
}

private extension RequestDetails {
    @ViewBuilder
    func requestSelection() -> some View {
        Section(header: Text("Request")) {
            rowView(title: "URL", subtitle: "\(model.url.absoluteString)")
            rowView(title: "Cache policy", subtitle: "\(model.cachePolicy.readableDescription)")
            rowView(title: "Timeout interval", subtitle: String(format: "%.2lfs", model.timeoutInterval))

            let dateString = DateFormatter.localizedString(
                from: model.sendingDate,
                dateStyle: .medium,
                timeStyle: .medium
            )
            rowView(title: "Sending date", subtitle: dateString)

            if let httpMethod = model.httpMethod {
                rowView(title: "HTTP method", subtitle: httpMethod)
            }
        }

        if let headerFields =  model.allRequestHTTPHeaderFields {
            Section(header: Text("HTTP Header Fields")) {
                ForEach(headerFields.keys.sorted(), id: \.self) { key in
                    if let value = headerFields[key] {
                        rowView(title: key, subtitle: value)
                    }
                }
            }
        }

        Section(header: Text("Body")) {
            rowView(title: "Body length", subtitle: "\(model.requestBodyLength)")
            NavigationLink("Body preview", destination: RequestBodyPreview(model: model, mode: .request))
        }
    }

    @ViewBuilder
    func responseSelection() -> some View {
        Section(header: Text("Response")) {
            rowView(title: "MIME Type", subtitle: "\(model.url.absoluteString)")
            rowView(title: "Receiving data", subtitle: "\(model.url.absoluteString)")
            rowView(title: "Duration", subtitle: "\(model.url.absoluteString)")
            rowView(title: "HTTP status code", subtitle: "\(model.url.absoluteString)")
        }

        if let headerFields =  model.allResponseHTTPHeaderFields {
            Section(header: Text("HTTP Header Fields")) {
                ForEach(headerFields.keys.sorted(), id: \.self) { key in
                    if let value = headerFields[key] {
                        rowView(title: key, subtitle: value)
                    }
                }
            }
        }

        Section(header: Text("Body")) {
            rowView(title: "Body length", subtitle: "\(model.responseBodyLength)")
            NavigationLink("Body preview", destination: RequestBodyPreview(model: model, mode: .response))
        }
    }

    func rowView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}
