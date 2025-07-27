//
//  KeySignature.swift
//  SharedModels
//
//  Created by Claude on 2025/07/21.
//

import Foundation

/// 調号を表す構造体
public struct KeySignature: Equatable, Hashable, Sendable {
    /// 調号の数（正数はシャープ、負数はフラット）
    public let accidentals: Int
    
    public init(accidentals: Int) {
        self.accidentals = accidentals
    }
    
    /// 調号の表現
    public var description: String {
        if accidentals == 0 {
            return "♮"
        } else if accidentals > 0 {
            return "\(accidentals)♯"
        } else {
            return "\(-accidentals)♭"
        }
    }
    
    /// シャープがついる音名の順序
    private static let sharpOrder: [Note] = [.f, .c, .g, .d, .a, .e, .b]
    
    /// フラットがつく音名の順序
    private static let flatOrder: [Note] = [.b, .e, .a, .d, .g, .c, .f]
    
    /// この調号でシャープがつく音名のリスト
    public var sharps: [Note] {
        guard accidentals > 0 else { return [] }
        return Array(KeySignature.sharpOrder.prefix(accidentals))
    }
    
    /// この調号でフラットがつく音名のリスト
    public var flats: [Note] {
        guard accidentals < 0 else { return [] }
        return Array(KeySignature.flatOrder.prefix(-accidentals))
    }
}