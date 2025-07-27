//
//  AppView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/07/21.
//

import SwiftUI
import KeySuggestionFeature

public struct AppView: View {
    public var body: some View {
        KeySuggestionView(viewModel: KeySuggestionViewModel())
    }

    public init() {}
}
