import Testing
@testable import SharedModels

/// ChordQuality enumのテストスイート
struct ChordQualityTests {
    
    @Test
    func basicChordQualitySymbols() {
        #expect(ChordQuality.major.symbol == "")
        #expect(ChordQuality.minor.symbol == "m")
        #expect(ChordQuality.diminished.symbol == "dim")
        #expect(ChordQuality.augmented.symbol == "aug")
        #expect(ChordQuality.sus2.symbol == "sus2")
        #expect(ChordQuality.sus4.symbol == "sus4")
    }
    
    @Test
    func seventhChordQualitySymbols() {
        #expect(ChordQuality.dominant7.symbol == "7")
        #expect(ChordQuality.major7.symbol == "maj7")
        #expect(ChordQuality.minor7.symbol == "m7")
        #expect(ChordQuality.diminished7.symbol == "dim7")
        #expect(ChordQuality.halfDiminished7.symbol == "m7b5")
        #expect(ChordQuality.augmented7.symbol == "aug7")
        #expect(ChordQuality.minorMajor7.symbol == "mMaj7")
    }
    
    @Test
    func extendedChordQualitySymbols() {
        #expect(ChordQuality.add9.symbol == "add9")
        #expect(ChordQuality.major9.symbol == "maj9")
        #expect(ChordQuality.minor9.symbol == "m9")
        #expect(ChordQuality.dominant9.symbol == "9")
        #expect(ChordQuality.major11.symbol == "maj11")
        #expect(ChordQuality.minor11.symbol == "m11")
        #expect(ChordQuality.dominant11.symbol == "11")
        #expect(ChordQuality.major13.symbol == "maj13")
        #expect(ChordQuality.minor13.symbol == "m13")
        #expect(ChordQuality.dominant13.symbol == "13")
    }
    
    @Test
    func japaneseDescriptions() {
        #expect(ChordQuality.major.japaneseDescription == "長三和音")
        #expect(ChordQuality.minor.japaneseDescription == "短三和音")
        #expect(ChordQuality.diminished.japaneseDescription == "減三和音")
        #expect(ChordQuality.augmented.japaneseDescription == "増三和音")
        #expect(ChordQuality.dominant7.japaneseDescription == "属7")
        #expect(ChordQuality.major7.japaneseDescription == "長7")
        #expect(ChordQuality.minor7.japaneseDescription == "短7")
    }
    
    @Test
    func basicTriadIntervals() {
        #expect(ChordQuality.major.intervals == [0, 4, 7])
        #expect(ChordQuality.minor.intervals == [0, 3, 7])
        #expect(ChordQuality.diminished.intervals == [0, 3, 6])
        #expect(ChordQuality.augmented.intervals == [0, 4, 8])
        #expect(ChordQuality.sus2.intervals == [0, 2, 7])
        #expect(ChordQuality.sus4.intervals == [0, 5, 7])
    }
    
    @Test
    func seventhChordIntervals() {
        #expect(ChordQuality.dominant7.intervals == [0, 4, 7, 10])
        #expect(ChordQuality.major7.intervals == [0, 4, 7, 11])
        #expect(ChordQuality.minor7.intervals == [0, 3, 7, 10])
        #expect(ChordQuality.diminished7.intervals == [0, 3, 6, 9])
        #expect(ChordQuality.halfDiminished7.intervals == [0, 3, 6, 10])
        #expect(ChordQuality.augmented7.intervals == [0, 4, 8, 10])
        #expect(ChordQuality.minorMajor7.intervals == [0, 3, 7, 11])
    }
    
    @Test
    func extendedChordIntervals() {
        #expect(ChordQuality.add9.intervals == [0, 4, 7, 14])
        #expect(ChordQuality.major9.intervals == [0, 4, 7, 11, 14])
        #expect(ChordQuality.minor9.intervals == [0, 3, 7, 10, 14])
        #expect(ChordQuality.dominant9.intervals == [0, 4, 7, 10, 14])
    }
    
    @Test
    func seventhChordClassification() {
        // 7thコード
        #expect(ChordQuality.dominant7.isSeventh == true)
        #expect(ChordQuality.major7.isSeventh == true)
        #expect(ChordQuality.minor7.isSeventh == true)
        #expect(ChordQuality.diminished7.isSeventh == true)
        #expect(ChordQuality.halfDiminished7.isSeventh == true)
        #expect(ChordQuality.augmented7.isSeventh == true)
        #expect(ChordQuality.minorMajor7.isSeventh == true)
        
        // 非7thコード
        #expect(ChordQuality.major.isSeventh == false)
        #expect(ChordQuality.minor.isSeventh == false)
        #expect(ChordQuality.diminished.isSeventh == false)
        #expect(ChordQuality.augmented.isSeventh == false)
        #expect(ChordQuality.sus2.isSeventh == false)
        #expect(ChordQuality.sus4.isSeventh == false)
    }
    
    @Test
    func extendedChordClassification() {
        // 拡張コード
        #expect(ChordQuality.add9.isExtended == true)
        #expect(ChordQuality.major9.isExtended == true)
        #expect(ChordQuality.minor9.isExtended == true)
        #expect(ChordQuality.dominant9.isExtended == true)
        #expect(ChordQuality.major11.isExtended == true)
        #expect(ChordQuality.minor11.isExtended == true)
        #expect(ChordQuality.dominant11.isExtended == true)
        #expect(ChordQuality.major13.isExtended == true)
        #expect(ChordQuality.minor13.isExtended == true)
        #expect(ChordQuality.dominant13.isExtended == true)
        
        // 非拡張コード
        #expect(ChordQuality.major.isExtended == false)
        #expect(ChordQuality.minor.isExtended == false)
        #expect(ChordQuality.dominant7.isExtended == false)
        #expect(ChordQuality.major7.isExtended == false)
        #expect(ChordQuality.minor7.isExtended == false)
    }
    
    @Test
    func chordQualityCaseIterable() {
        let allQualities = ChordQuality.allCases
        #expect(allQualities.count == 23) // 実装で定義された23種類のコード品質
        #expect(allQualities.contains(.major))
        #expect(allQualities.contains(.minor))
        #expect(allQualities.contains(.dominant7))
        #expect(allQualities.contains(.major9))
    }
    
    @Test
    func chordQualityEqualityAndHashability() {
        let major1 = ChordQuality.major
        let major2 = ChordQuality.major
        let minor = ChordQuality.minor
        
        #expect(major1 == major2)
        #expect(major1 != minor)
        #expect(major1.hashValue == major2.hashValue)
    }
}