import SwiftUI

private enum Constants {
    static let width = 60.0
    static let height = 60.0
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            VStack {
                switch viewModel.homeState {
                case .empty:
                    VStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 8) {
                            Text("Empty State")
                                .font(.headline)
                            Text("There are no recipes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loading:
                    ProgressView()
                        .frame(width: Constants.width, height: Constants.height)
                case .loaded(let recipes):
                    List(recipes, id: \.uuid) { recipe in
                        HStack(alignment: .top, spacing: 12) {
                            if let url = recipe.photoURLSmall {
                                CachedAsyncImage(url: url)
                                    .frame(width: Constants.width, height: Constants.height)
                                    .clipped()
                                    .cornerRadius(8)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.cuisine)
                                    .font(.headline)
                                Text(recipe.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                case .error(let error):
                    VStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 8) {
                            Text("Error State")
                                .font(.headline)
                            Text(error.localizedDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Cuisines")
            .onAppear {
                Task {
                    try? await viewModel.onAppear()
                }
            }
            if case let .error(message) = viewModel.toastState {
                ToastView(message: message, background: .red)
            } else if case let .success(message) = viewModel.toastState {
                ToastView(message: message, background: .green)
            }
        }
        .onChange(of: viewModel.toastState) {
            guard viewModel.toastState != .none else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    viewModel.toastState = .none
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
