import Foundation

/// スケール度数を表すenum
public enum ScaleDegree: Int, CaseIterable, Sendable {
    case i = 1
    case ii = 2
    case iii = 3
    case iv = 4
    case v = 5
    case vi = 6
    case vii = 7
    
    /// メジャーキーでのローマ数字記法
    public var majorRomanNumeral: String {
        switch self {
        case .i: return "I"
        case .ii: return "ii"
        case .iii: return "iii"
        case .iv: return "IV"
        case .v: return "V"
        case .vi: return "vi"
        case .vii: return "vii°"
        }
    }
    
    /// マイナーキーでのローマ数字記法
    public var minorRomanNumeral: String {
        switch self {
        case .i: return "i"
        case .ii: return "ii°"
        case .iii: return "III"
        case .iv: return "iv"
        case .v: return "v"
        case .vi: return "VI"
        case .vii: return "VII"
        }
    }
    
    /// キーモードに応じたローマ数字記法を返す
    public func romanNumeral(for mode: KeyMode) -> String {
        switch mode {
        case .major:
            return majorRomanNumeral
        case .minor:
            return minorRomanNumeral
        }
    }
}