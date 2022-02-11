import SwiftUI

struct ConsoleView: View {
    @ObservedObject var viewModel: ConsoleViewModel

    var body: some View {
        ScrollView {
            Text(viewModel.consoleOutput)
                .font(.footnote)
                .padding()
        }
        .navigationBarTitle("Console")
        .navigationBarItems(trailing: navigationBarItems())
    }
}

private extension ConsoleView {
    func navigationBarItems() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Button(
                action: viewModel.shareConsoleOutput,
                label: {
                    Image(systemName: "square.and.arrow.up")
                }
            )

            Button(
                action: viewModel.pauseConsoleOutput,
                label: {
                    let imageName = viewModel.isConsoleOutputPause ? "pause.circle.fill" : "pause.circle"
                    Image(systemName: imageName)
                }
            )

            Button(
                action: viewModel.clearConsoleOutput,
                label: {
                    Image(systemName: "trash")
                }
            )
        }
    }
}
