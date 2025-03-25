import SwiftUI

private enum Constants {
    static let width = 60.0
    static let height = 60.0
}

struct ThumbnailView: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: Constants.width, height: Constants.height)
            .cornerRadius(Constants.width / 2)
    }
}
