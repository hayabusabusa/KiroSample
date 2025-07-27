import Testing
@testable import SharedModels

/// Chord structのテストスイート
struct ChordTests {
    
    @Test
    func chordInitialization() {
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        #expect(chord.root == .c)
        #expect(chord.quality == .major)
        #expect(chord.extensions.isEmpty)
        #expect(chord.bass == nil)
    }
    
    @Test
    func basicChordSymbolGeneration() {
        let cMajor = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        #expect(cMajor.symbol == "C")
        
        let dMinor = Chord(root: .d, quality: .minor, extensions: [], bass: nil)
        #expect(dMinor.symbol == "Dm")
        
        let fSharpDiminished = Chord(root: .fSharp, quality: .diminished, extensions: [], bass: nil)
        #expect(fSharpDiminished.symbol == "F#dim")
        
        let gAugmented = Chord(root: .g, quality: .augmented, extensions: [], bass: nil)
        #expect(gAugmented.symbol == "Gaug")
    }
    
    @Test
    func seventhChordSymbolGeneration() {
        let g7 = Chord(root: .g, quality: .dominant7, extensions: [], bass: nil)
        #expect(g7.symbol == "G7")
        
        let cMaj7 = Chord(root: .c, quality: .major7, extensions: [], bass: nil)
        #expect(cMaj7.symbol == "Cmaj7")
        
        let aminor7 = Chord(root: .a, quality: .minor7, extensions: [], bass: nil)
        #expect(aminor7.symbol == "Am7")
        
        let bHalfDim7 = Chord(root: .b, quality: .halfDiminished7, extensions: [], bass: nil)
        #expect(bHalfDim7.symbol == "Bm7b5")
    }
    
    @Test
    func extendedChordSymbolGeneration() {
        let c9 = Chord(root: .c, quality: .dominant9, extensions: [], bass: nil)
        #expect(c9.symbol == "C9")
        
        let dMaj9 = Chord(root: .d, quality: .major9, extensions: [], bass: nil)
        #expect(dMaj9.symbol == "Dmaj9")
        
        let eMinor11 = Chord(root: .e, quality: .minor11, extensions: [], bass: nil)
        #expect(eMinor11.symbol == "Em11")
        
        let f13 = Chord(root: .f, quality: .dominant13, extensions: [], bass: nil)
        #expect(f13.symbol == "F13")
    }
    
    @Test
    func chordWithBassNote() {
        let cMajorOverE = Chord(root: .c, quality: .major, extensions: [], bass: .e)
        #expect(cMajorOverE.symbol == "C/E")
        
        let g7OverB = Chord(root: .g, quality: .dominant7, extensions: [], bass: .b)
        #expect(g7OverB.symbol == "G7/B")
        
        let fMajorOverA = Chord(root: .f, quality: .major, extensions: [], bass: .a)
        #expect(fMajorOverA.symbol == "F/A")
    }
    
    @Test
    func chordWithSameRootAndBass() {
        // ルート音とベース音が同じ場合はベース音を表示しない
        let cMajorOverC = Chord(root: .c, quality: .major, extensions: [], bass: .c)
        #expect(cMajorOverC.symbol == "C")
        
        let g7OverG = Chord(root: .g, quality: .dominant7, extensions: [], bass: .g)
        #expect(g7OverG.symbol == "G7")
    }
    
    @Test
    func chordWithExtensions() {
        let cWithNinth = Chord(root: .c, quality: .major, extensions: [.ninth], bass: nil)
        #expect(cWithNinth.symbol == "C9")
        
        let dWithFlatFive = Chord(root: .d, quality: .minor, extensions: [.flatFive], bass: nil)
        #expect(dWithFlatFive.symbol == "Dmb5")
        
        let eWithMultipleExtensions = Chord(
            root: .e, 
            quality: .dominant7, 
            extensions: [.ninth, .sharpEleven], 
            bass: nil
        )
        #expect(eWithMultipleExtensions.symbol == "E7#119")
    }
    
    @Test
    func chordEquality() {
        let chord1 = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let chord2 = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let chord3 = Chord(root: .d, quality: .major, extensions: [], bass: nil)
        let chord4 = Chord(root: .c, quality: .minor, extensions: [], bass: nil)
        let chord5 = Chord(root: .c, quality: .major, extensions: [], bass: .e)
        
        #expect(chord1 == chord2)
        #expect(chord1 != chord3) // 異なるルート
        #expect(chord1 != chord4) // 異なる品質
        #expect(chord1 != chord5) // 異なるベース音
    }
    
    @Test
    func chordHashability() {
        let chord1 = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let chord2 = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let chord3 = Chord(root: .d, quality: .major, extensions: [], bass: nil)
        
        #expect(chord1.hashValue == chord2.hashValue)
        #expect(chord1.hashValue != chord3.hashValue)
    }
    
    @Test
    func complexChordSymbols() {
        // 複雑なコード記法のテスト
        let complexChord1 = Chord(
            root: .fSharp, 
            quality: .halfDiminished7, 
            extensions: [], 
            bass: .a
        )
        #expect(complexChord1.symbol == "F#m7b5/A")
        
        let complexChord2 = Chord(
            root: .aFlat, 
            quality: .major13, 
            extensions: [], 
            bass: nil
        )
        #expect(complexChord2.symbol == "Abmaj13")
    }
}