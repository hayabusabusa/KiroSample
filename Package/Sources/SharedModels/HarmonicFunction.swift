import Foundation

/// ハーモニック機能（和声機能）を表すenum
public enum HarmonicFunction: String, CaseIterable, Sendable {
    case tonic = "tonic"
    case subdominant = "subdominant"
    case dominant = "dominant"
    
    /// 日本語説明
    public var description: String {
        switch self {
        case .tonic:
            return "トニック"
        case .subdominant:
            return "サブドミナント"
        case .dominant:
            return "ドミナント"
        }
    }
    
    /// 機能の詳細説明
    public var detailedDescription: String {
        switch self {
        case .tonic:
            return "安定した響きを持つ主和音"
        case .subdominant:
            return "下属和音として中間的な響きを持つ"
        case .dominant:
            return "緊張感を持ち主和音へ解決する"
        }
    }
    
    /// メジャーキーでの代表的なスケール度数
    public var typicalDegreesInMajor: [ScaleDegree] {
        switch self {
        case .tonic:
            return [.i, .iii, .vi]
        case .subdominant:
            return [.ii, .iv]
        case .dominant:
            return [.v, .vii]
        }
    }
    
    /// マイナーキーでの代表的なスケール度数
    public var typicalDegreesInMinor: [ScaleDegree] {
        switch self {
        case .tonic:
            return [.i, .iii, .vi]
        case .subdominant:
            return [.ii, .iv]
        case .dominant:
            return [.v, .vii]
        }
    }
}