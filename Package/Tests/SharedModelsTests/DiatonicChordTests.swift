import Testing
@testable import SharedModels

/// DiatonicChord structのテストスイート
struct DiatonicChordTests {
    
    @Test
    func diatonicChordInitialization() {
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let diatonicChord = DiatonicChord(
            degree: .i,
            chord: chord,
            function: .tonic,
            romanNumeral: "I"
        )
        
        #expect(diatonicChord.degree == .i)
        #expect(diatonicChord.chord == chord)
        #expect(diatonicChord.function == .tonic)
        #expect(diatonicChord.romanNumeral == "I")
    }
    
    @Test
    func majorKeyDiatonicChordExamples() {
        // Cメジャーキーのダイアトニックコード例
        let cMajor = DiatonicChord(
            degree: .i,
            chord: Chord(root: .c, quality: .major, extensions: [], bass: nil),
            function: .tonic,
            romanNumeral: "I"
        )
        #expect(cMajor.degree == .i)
        #expect(cMajor.function == .tonic)
        #expect(cMajor.romanNumeral == "I")
        
        let dMinor = DiatonicChord(
            degree: .ii,
            chord: Chord(root: .d, quality: .minor, extensions: [], bass: nil),
            function: .subdominant,
            romanNumeral: "ii"
        )
        #expect(dMinor.degree == .ii)
        #expect(dMinor.function == .subdominant)
        #expect(dMinor.romanNumeral == "ii")
        
        let g7 = DiatonicChord(
            degree: .v,
            chord: Chord(root: .g, quality: .dominant7, extensions: [], bass: nil),
            function: .dominant,
            romanNumeral: "V7"
        )
        #expect(g7.degree == .v)
        #expect(g7.function == .dominant)
        #expect(g7.romanNumeral == "V7")
    }
    
    @Test
    func minorKeyDiatonicChordExamples() {
        // Aマイナーキーのダイアトニックコード例
        let aMinor = DiatonicChord(
            degree: .i,
            chord: Chord(root: .a, quality: .minor, extensions: [], bass: nil),
            function: .tonic,
            romanNumeral: "i"
        )
        #expect(aMinor.degree == .i)
        #expect(aMinor.function == .tonic)
        #expect(aMinor.romanNumeral == "i")
        
        let bDiminished = DiatonicChord(
            degree: .ii,
            chord: Chord(root: .b, quality: .diminished, extensions: [], bass: nil),
            function: .subdominant,
            romanNumeral: "ii°"
        )
        #expect(bDiminished.degree == .ii)
        #expect(bDiminished.function == .subdominant)
        #expect(bDiminished.romanNumeral == "ii°")
    }
    
    @Test
    func diatonicChordEquality() {
        let chord1 = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let chord2 = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let chord3 = Chord(root: .d, quality: .minor, extensions: [], bass: nil)
        
        let diatonic1 = DiatonicChord(degree: .i, chord: chord1, function: .tonic, romanNumeral: "I")
        let diatonic2 = DiatonicChord(degree: .i, chord: chord2, function: .tonic, romanNumeral: "I")
        let diatonic3 = DiatonicChord(degree: .ii, chord: chord3, function: .subdominant, romanNumeral: "ii")
        let diatonic4 = DiatonicChord(degree: .i, chord: chord1, function: .dominant, romanNumeral: "I") // 異なる機能
        
        #expect(diatonic1 == diatonic2)
        #expect(diatonic1 != diatonic3) // 異なるdegreeとchord
        #expect(diatonic1 != diatonic4) // 異なるfunction
    }
    
    @Test
    func diatonicChordHashability() {
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let diatonic1 = DiatonicChord(degree: .i, chord: chord, function: .tonic, romanNumeral: "I")
        let diatonic2 = DiatonicChord(degree: .i, chord: chord, function: .tonic, romanNumeral: "I")
        let diatonic3 = DiatonicChord(degree: .ii, chord: chord, function: .subdominant, romanNumeral: "ii")
        
        #expect(diatonic1.hashValue == diatonic2.hashValue)
        #expect(diatonic1.hashValue != diatonic3.hashValue)
    }
    
    @Test
    func diatonicChordWithExtensions() {
        let seventhChord = Chord(root: .g, quality: .dominant7, extensions: [], bass: nil)
        let diatonic = DiatonicChord(
            degree: .v,
            chord: seventhChord,
            function: .dominant,
            romanNumeral: "V7"
        )
        
        #expect(diatonic.chord.quality == .dominant7)
        #expect(diatonic.chord.symbol == "G7")
        #expect(diatonic.function == .dominant)
    }
    
    @Test
    func diatonicChordWithBass() {
        let slashChord = Chord(root: .c, quality: .major, extensions: [], bass: .e)
        let diatonic = DiatonicChord(
            degree: .i,
            chord: slashChord,
            function: .tonic,
            romanNumeral: "I/3"
        )
        
        #expect(diatonic.chord.symbol == "C/E")
        #expect(diatonic.romanNumeral == "I/3")
        #expect(diatonic.function == .tonic)
    }
}