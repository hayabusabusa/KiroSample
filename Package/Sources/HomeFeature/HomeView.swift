import SwiftUI

/// 店舗一覧表示用のメインビュー
public struct HomeView: View {
    @State private var viewModel: StoreListViewModel
    
    public init(viewModel: StoreListViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("店舗情報を取得中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(
                        message: errorMessage,
                        retryAction: {
                            Task {
                                await viewModel.refreshStores()
                            }
                        },
                        dismissAction: {
                            viewModel.clearError()
                        }
                    )
                } else {
                    StoreListView(viewModel: viewModel)
                }
            }
            .navigationTitle("さわやか店舗一覧")
            .refreshable {
                await viewModel.refreshStores()
            }
            .task {
                if viewModel.stores.isEmpty {
                    await viewModel.refreshStores()
                }
            }
        }
    }
}

