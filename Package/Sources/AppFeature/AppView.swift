//
//  App.swift
//  Package
//
//  Created by Shunya Yamada on 2025/07/20.
//

import Domain
import SwiftUI
import HomeFeature

public struct AppView: View {
    public var body: some View {
        HomeView(
            viewModel: StoreListViewModel(
                storeService: StoreService(
                    repository: StoreRepository(
                        apiClient: MockAPIClient(),
                        localStorage: LocalStorage()
                    )
                ),
                networkService: NetworkService()
            )
        )
    }

    public init() {}
}
