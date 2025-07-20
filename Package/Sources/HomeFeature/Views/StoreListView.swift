import SwiftUI
import SharedModels

/// 店舗一覧コンテンツ表示用のビュー
public struct StoreListView: View {
    let viewModel: StoreListViewModel
    
    public init(viewModel: StoreListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            // 検索バー
            SearchBar(text: Binding(
                get: { viewModel.searchQuery },
                set: { viewModel.searchQuery = $0 }
            ))
            .padding(.horizontal)
            
            // フィルター情報表示
            if !viewModel.filterCriteria.region.isNilOrEmpty ||
               viewModel.filterCriteria.openOnly ||
               viewModel.filterCriteria.maxWaitTime != nil {
                FilterSummaryView(
                    filterCriteria: viewModel.filterCriteria,
                    clearAction: { viewModel.clearFilters() }
                )
                .padding(.horizontal)
            }
            
            // 店舗一覧
            List(viewModel.filteredStores) { store in
                StoreRowView(
                    store: store,
                    refreshAction: {
                        Task {
                            await viewModel.refreshWaitTime(for: store.id)
                        }
                    }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
            .listStyle(.plain)
            
            // 最終更新時刻
            if let lastUpdated = viewModel.lastUpdated {
                LastUpdatedView(date: lastUpdated)
                    .padding()
            }
        }
    }
}

// MARK: - Extensions

private extension String? {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}