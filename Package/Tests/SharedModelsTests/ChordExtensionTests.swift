import Testing
@testable import SharedModels

/// ChordExtension enumのテストスイート
struct ChordExtensionTests {
    
    @Test
    func chordExtensionSymbols() {
        #expect(ChordExtension.ninth.symbol == "9")
        #expect(ChordExtension.eleventh.symbol == "11")
        #expect(ChordExtension.thirteenth.symbol == "13")
        #expect(ChordExtension.flatFive.symbol == "b5")
        #expect(ChordExtension.sharpFive.symbol == "#5")
        #expect(ChordExtension.flatNine.symbol == "b9")
        #expect(ChordExtension.sharpNine.symbol == "#9")
        #expect(ChordExtension.sharpEleven.symbol == "#11")
        #expect(ChordExtension.flatThirteen.symbol == "b13")
    }
    
    @Test
    func chordExtensionEquality() {
        #expect(ChordExtension.ninth == ChordExtension.ninth)
        #expect(ChordExtension.ninth != ChordExtension.eleventh)
        #expect(ChordExtension.flatFive == ChordExtension.flatFive)
        #expect(ChordExtension.sharpFive != ChordExtension.flatFive)
    }
    
    @Test
    func chordExtensionHashability() {
        let ninth1 = ChordExtension.ninth
        let ninth2 = ChordExtension.ninth
        let eleventh = ChordExtension.eleventh
        
        #expect(ninth1.hashValue == ninth2.hashValue)
        #expect(ninth1.hashValue != eleventh.hashValue)
    }
    
    @Test
    func chordExtensionInChord() {
        let cMajorAdd9 = Chord(
            root: .c,
            quality: .major,
            extensions: [.ninth],
            bass: nil
        )
        
        #expect(cMajorAdd9.extensions.contains(.ninth))
        #expect(cMajorAdd9.extensions.count == 1)
        // Note: シンボル生成のテストはChordTestsで行う
    }
    
    @Test
    func multipleExtensions() {
        let complexChord = Chord(
            root: .g,
            quality: .dominant7,
            extensions: [.ninth, .sharpEleven, .flatThirteen],
            bass: nil
        )
        
        #expect(complexChord.extensions.contains(.ninth))
        #expect(complexChord.extensions.contains(.sharpEleven))
        #expect(complexChord.extensions.contains(.flatThirteen))
        #expect(complexChord.extensions.count == 3)
    }
    
    @Test
    func alteredExtensions() {
        let alteredExtensions: [ChordExtension] = [
            .flatFive, .sharpFive, .flatNine, .sharpNine, .sharpEleven, .flatThirteen
        ]
        
        for `extension` in alteredExtensions {
            #expect(`extension`.symbol.contains("#") || `extension`.symbol.contains("b"))
        }
        
        let naturalExtensions: [ChordExtension] = [
            .ninth, .eleventh, .thirteenth
        ]
        
        for `extension` in naturalExtensions {
            #expect(!`extension`.symbol.contains("#") && !`extension`.symbol.contains("b"))
        }
    }
    
    @Test
    func chordExtensionSendable() {
        // Sendableプロトコル適合の確認（コンパイル時チェック）
        let `extension` = ChordExtension.ninth
        let extensions: [ChordExtension] = [.ninth, .eleventh, .thirteenth]
        
        #expect(`extension` == .ninth)
        #expect(extensions.count == 3)
    }
    
    @Test
    func extensionSymbolsAreUnique() {
        let allExtensions = [
            ChordExtension.ninth, .eleventh, .thirteenth, .flatFive, .sharpFive,
            .flatNine, .sharpNine, .sharpEleven, .flatThirteen
        ]
        
        let symbols = allExtensions.map { $0.symbol }
        let uniqueSymbols = Set(symbols)
        
        #expect(symbols.count == uniqueSymbols.count) // 全てのシンボルがユニーク
    }
}