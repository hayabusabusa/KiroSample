//
//  KeySuggestionSortOrder.swift
//  KeySuggestionFeature
//
//  Created by Shunya Yamada on 2025/07/27.
//

import Foundation

/// キー提案のソート順序
public enum KeySuggestionSortOrder: String, CaseIterable {
    case byScore = "スコア順"
    case byKeyName = "キー名順"
    case byMode = "モード順"
    
    public var description: String {
        return rawValue
    }
}