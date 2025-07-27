//
//  ChordExtension.swift
//  SharedModels
//
//  Created by Claude on 2025/07/21.
//

import Foundation

/// コードの拡張要素を表すenum
public enum ChordExtension: Equatable, Hashable, Sendable {
    case ninth
    case eleventh
    case thirteenth
    case flatFive
    case sharpFive
    case flatNine
    case sharpNine
    case sharpEleven
    case flatThirteen
    
    /// 拡張要素の記号表現
    public var symbol: String {
        switch self {
        case .ninth: return "9"
        case .eleventh: return "11"
        case .thirteenth: return "13"
        case .flatFive: return "b5"
        case .sharpFive: return "#5"
        case .flatNine: return "b9"
        case .sharpNine: return "#9"
        case .sharpEleven: return "#11"
        case .flatThirteen: return "b13"
        }
    }
}