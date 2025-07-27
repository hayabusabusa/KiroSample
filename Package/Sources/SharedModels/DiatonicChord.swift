import Foundation

/// ダイアトニックコードを表す構造体
public struct DiatonicChord: Equatable, Hashable, Sendable {
    public let degree: ScaleDegree
    public let chord: Chord
    public let function: HarmonicFunction
    public let romanNumeral: String
    
    public init(degree: ScaleDegree, chord: Chord, function: HarmonicFunction, romanNumeral: String) {
        self.degree = degree
        self.chord = chord
        self.function = function
        self.romanNumeral = romanNumeral
    }
}