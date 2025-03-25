import SwiftUI

struct NavigationButtonView<Destination: View>: View {
    let title: String
    let destination: Destination

    init(title: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.destination = destination()
    }

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .frButtonStyle()
        }
    }
}
