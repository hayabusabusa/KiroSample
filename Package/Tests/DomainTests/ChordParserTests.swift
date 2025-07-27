import Testing
@testable import Domain
@testable import SharedModels

/// ChordParser テストスイート
struct ChordParserTests {
    
    // テスト用のパーサーインスタンス
    let parser = ChordParser()
    
    // MARK: - 基本的なメジャーコード解析テスト
    
    @Test
    func parseBasicMajorChords() throws {
        let cMajor = try parser.parse("C")
        #expect(cMajor.root == .c)
        #expect(cMajor.quality == .major)
        #expect(cMajor.extensions.isEmpty)
        #expect(cMajor.bass == nil)
        #expect(cMajor.symbol == "C")
        
        let gMajor = try parser.parse("G")
        #expect(gMajor.root == .g)
        #expect(gMajor.quality == .major)
        #expect(gMajor.symbol == "G")
        
        let fSharpMajor = try parser.parse("F#")
        #expect(fSharpMajor.root == .fSharp)
        #expect(fSharpMajor.quality == .major)
        #expect(fSharpMajor.symbol == "F#")
        
        let bFlatMajor = try parser.parse("Bb")
        #expect(bFlatMajor.root == .bFlat)
        #expect(bFlatMajor.quality == .major)
        #expect(bFlatMajor.symbol == "Bb")
    }
    
    // MARK: - マイナーコード解析テスト
    
    @Test
    func parseMinorChords() throws {
        let aMinor = try parser.parse("Am")
        #expect(aMinor.root == .a)
        #expect(aMinor.quality == .minor)
        #expect(aMinor.extensions.isEmpty)
        #expect(aMinor.bass == nil)
        #expect(aMinor.symbol == "Am")
        
        let fSharpMinor = try parser.parse("F#m")
        #expect(fSharpMinor.root == .fSharp)
        #expect(fSharpMinor.quality == .minor)
        #expect(fSharpMinor.symbol == "F#m")
        
        let cMinor = try parser.parse("Cm")
        #expect(cMinor.root == .c)
        #expect(cMinor.quality == .minor)
        #expect(cMinor.symbol == "Cm")
    }
    
    // MARK: - セブンスコード解析テスト
    
    @Test
    func parseSeventhChords() throws {
        // ドミナント7th
        let g7 = try parser.parse("G7")
        #expect(g7.root == .g)
        #expect(g7.quality == .dominant7)
        #expect(g7.symbol == "G7")
        
        // メジャー7th
        let cmaj7 = try parser.parse("Cmaj7")
        #expect(cmaj7.root == .c)
        #expect(cmaj7.quality == .major7)
        #expect(cmaj7.symbol == "Cmaj7")
        
        // マイナー7th
        let am7 = try parser.parse("Am7")
        #expect(am7.root == .a)
        #expect(am7.quality == .minor7)
        #expect(am7.symbol == "Am7")
        
        // ディミニッシュ7th
        let bdim7 = try parser.parse("Bdim7")
        #expect(bdim7.root == .b)
        #expect(bdim7.quality == .diminished7)
        #expect(bdim7.symbol == "Bdim7")
        
        // ハーフディミニッシュ7th
        let bm7b5 = try parser.parse("Bm7b5")
        #expect(bm7b5.root == .b)
        #expect(bm7b5.quality == .halfDiminished7)
        #expect(bm7b5.symbol == "Bm7b5")
    }
    
    // MARK: - サスペンデッドコード解析テスト
    
    @Test
    func parseSuspendedChords() throws {
        let csus2 = try parser.parse("Csus2")
        #expect(csus2.root == .c)
        #expect(csus2.quality == .sus2)
        #expect(csus2.symbol == "Csus2")
        
        let fsus4 = try parser.parse("Fsus4")
        #expect(fsus4.root == .f)
        #expect(fsus4.quality == .sus4)
        #expect(fsus4.symbol == "Fsus4")
    }
    
    // MARK: - オーギュメント・ディミニッシュコード解析テスト
    
    @Test
    func parseAugmentedAndDiminishedChords() throws {
        let caug = try parser.parse("Caug")
        #expect(caug.root == .c)
        #expect(caug.quality == .augmented)
        #expect(caug.symbol == "Caug")
        
        let fdim = try parser.parse("Fdim")
        #expect(fdim.root == .f)
        #expect(fdim.quality == .diminished)
        #expect(fdim.symbol == "Fdim")
    }
    
    // MARK: - 拡張コード解析テスト
    
    @Test
    func parseExtendedChords() throws {
        let cmaj9 = try parser.parse("Cmaj9")
        #expect(cmaj9.root == .c)
        #expect(cmaj9.quality == .major9)
        #expect(cmaj9.symbol == "Cmaj9")
        
        let am9 = try parser.parse("Am9")
        #expect(am9.root == .a)
        #expect(am9.quality == .minor9)
        #expect(am9.symbol == "Am9")
        
        let g9 = try parser.parse("G9")
        #expect(g9.root == .g)
        #expect(g9.quality == .dominant9)
        #expect(g9.symbol == "G9")
        
        let cadd9 = try parser.parse("Cadd9")
        #expect(cadd9.root == .c)
        #expect(cadd9.quality == .add9)
        #expect(cadd9.symbol == "Cadd9")
    }
    
    // MARK: - スラッシュコード（ベース音付き）解析テスト
    
    @Test
    func parseSlashChords() throws {
        let cOverE = try parser.parse("C/E")
        #expect(cOverE.root == .c)
        #expect(cOverE.quality == .major)
        #expect(cOverE.bass == .e)
        #expect(cOverE.symbol == "C/E")
        
        let am7OverC = try parser.parse("Am7/C")
        #expect(am7OverC.root == .a)
        #expect(am7OverC.quality == .minor7)
        #expect(am7OverC.bass == .c)
        #expect(am7OverC.symbol == "Am7/C")
        
        let fOverG = try parser.parse("F/G")
        #expect(fOverG.root == .f)
        #expect(fOverG.quality == .major)
        #expect(fOverG.bass == .g)
        #expect(fOverG.symbol == "F/G")
    }
    
    // MARK: - 複雑なコード解析テスト
    
    @Test
    func parseComplexChords() throws {
        let gmaj13 = try parser.parse("Gmaj13")
        #expect(gmaj13.root == .g)
        #expect(gmaj13.quality == .major13)
        #expect(gmaj13.symbol == "Gmaj13")
        
        let dm11 = try parser.parse("Dm11")
        #expect(dm11.root == .d)
        #expect(dm11.quality == .minor11)
        #expect(dm11.symbol == "Dm11")
        
        let c13 = try parser.parse("C13")
        #expect(c13.root == .c)
        #expect(c13.quality == .dominant13)
        #expect(c13.symbol == "C13")
        
        let amMaj7 = try parser.parse("AmMaj7")
        #expect(amMaj7.root == .a)
        #expect(amMaj7.quality == .minorMajor7)
        #expect(amMaj7.symbol == "AmMaj7")
    }
    
    // MARK: - 大文字小文字無視テスト
    
    @Test
    func parseCaseInsensitive() throws {
        let lowerCaseC = try parser.parse("c")
        #expect(lowerCaseC.root == .c)
        #expect(lowerCaseC.quality == .major)
        
        let mixedCaseAm = try parser.parse("am")
        #expect(mixedCaseAm.root == .a)
        #expect(mixedCaseAm.quality == .minor)
        
        let upperCaseF7 = try parser.parse("F7")
        #expect(upperCaseF7.root == .f)
        #expect(upperCaseF7.quality == .dominant7)
    }
    
    // MARK: - 空白文字処理テスト
    
    @Test
    func parseWithWhitespace() throws {
        let withSpaces = try parser.parse("  C  ")
        #expect(withSpaces.root == .c)
        #expect(withSpaces.quality == .major)
        
        let withTabsAndSpaces = try parser.parse(" Am7 ")
        #expect(withTabsAndSpaces.root == .a)
        #expect(withTabsAndSpaces.quality == .minor7)
    }
    
    // MARK: - バリデーション機能テスト
    
    @Test
    func validateValidChords() {
        // 有効なコード
        #expect(parser.validate("C") == true)
        #expect(parser.validate("Am") == true)
        #expect(parser.validate("F#7") == true)
        #expect(parser.validate("Bm7b5") == true)
        #expect(parser.validate("Csus4") == true)
        #expect(parser.validate("G/B") == true)
        #expect(parser.validate("Dmaj9") == true)
    }
    
    @Test
    func validateInvalidChords() {
        // 無効なコード
        #expect(parser.validate("") == false)
        #expect(parser.validate("   ") == false)
        #expect(parser.validate("H") == false) // 存在しない音名
        #expect(parser.validate("Cmajor") == false) // 正しくない記法
        #expect(parser.validate("A#b") == false) // 矛盾した記法
        #expect(parser.validate("C/") == false) // 不完全なベース音
        #expect(parser.validate("/E") == false) // ルート音なし
        #expect(parser.validate("123") == false) // 数字のみ
    }
    
    // MARK: - エラーハンドリングテスト
    
    @Test
    func throwsErrorForEmptyInput() {
        do {
            _ = try parser.parse("")
            Issue.record("Should throw emptyInput error")
        } catch let error as ChordParsingError {
            #expect(error == .emptyInput)
        } catch {
            Issue.record("Should throw ChordParsingError")
        }
        
        do {
            _ = try parser.parse("   ")
            #expect(Bool(false), "Should throw emptyInput error")
        } catch let error as ChordParsingError {
            #expect(error == .emptyInput)
        } catch {
            #expect(Bool(false), "Should throw ChordParsingError")
        }
    }
    
    @Test
    func throwsErrorForInvalidFormat() {
        let invalidInputs = ["H", "123", "C/", "/E"]
        
        for input in invalidInputs {
            do {
                _ = try parser.parse(input)
                Issue.record("Should throw error for input: \(input)")
            } catch is ChordParsingError {
                // Expected error - test passes
                #expect(true)
            } catch {
                Issue.record("Should throw ChordParsingError for input: \(input)")
            }
        }
    }
    
    @Test
    func throwsErrorForUnknownQuality() {
        let invalidQualityInputs = ["Cmajor", "Cmin", "Cminor"]
        
        for input in invalidQualityInputs {
            do {
                _ = try parser.parse(input)
                Issue.record("Should throw error for input: \(input)")
            } catch is ChordParsingError {
                // Expected error (either unknownQuality or invalidFormat) - test passes
                #expect(true)
            } catch {
                Issue.record("Should throw ChordParsingError for input: \(input)")
            }
        }
    }
    
    // MARK: - パフォーマンステスト
    
    @Test
    func parsePerformance() {
        let chords = [
            "C", "Am", "F", "G", "Em", "Dm", "C7", "Am7", "F7", "G7",
            "Cmaj7", "Amaj7", "Fmaj7", "Gmaj7", "Em7", "Dm7", "Bm7b5",
            "C/E", "Am/C", "F/A", "G/B", "Csus2", "Fsus4", "Gsus4"
        ]
        
        // パフォーマンステスト: 複数のコードを連続で解析
        for chord in chords {
            do {
                let parsed = try parser.parse(chord)
                #expect(!parsed.symbol.isEmpty)
            } catch {
                Issue.record("Failed to parse chord: \(chord)")
            }
        }
    }
    
    // MARK: - エッジケーステスト
    
    @Test
    func parseEdgeCases() throws {
        // 最も短いコード
        let c = try parser.parse("C")
        #expect(c.symbol == "C")
        
        // 比較的長いコード
        let complex = try parser.parse("Gmaj13")
        #expect(complex.symbol == "Gmaj13")
        
        // 異名同音
        let cSharp = try parser.parse("C#")
        let dFlat = try parser.parse("Db")
        #expect(cSharp.root.semitoneValue == dFlat.root.semitoneValue)
        
        // ベース音とルート音が同じ場合
        let cOverC = try parser.parse("C/C")
        #expect(cOverC.root == .c)
        #expect(cOverC.bass == .c)
        #expect(cOverC.symbol == "C") // 同じ場合はベース音表示しない
    }
    
    // MARK: - プロトコル適合テスト
    
    @Test
    func protocolConformance() {
        // ChordParserProtocol適合の確認
        let protocolParser: any ChordParserProtocol = ChordParser()

        #expect(protocolParser.validate("C") == true)
        #expect(protocolParser.validate("invalid") == false)
        
        do {
            let chord = try protocolParser.parse("Am7")
            #expect(chord.root == .a)
            #expect(chord.quality == .minor7)
        } catch {
            Issue.record("Protocol method should work")
        }
    }
    
    // MARK: - Sendable適合テスト
    
    @Test
    func sendableConformance() {
        // Sendableプロトコル適合の確認（コンパイル時チェック）
        let parser1 = ChordParser()
        let parser2 = ChordParser()
        
        // 複数のパーサーインスタンスが作成できる
        #expect(parser1.validate("C") == parser2.validate("C"))
        
        // パーサーは状態を持たない（関数型）
        let parsers: [ChordParser] = [
            ChordParser(),
            ChordParser(),
            ChordParser()
        ]
        
        #expect(parsers.count == 3)
    }
}
