import Testing
import Foundation
@testable import Domain
@testable import SharedModels

/// DiatonicChordServiceのテスト
struct DiatonicChordServiceTests {
    
    private let service = DiatonicChordService()
    
    @Test
    func testCMajorDiatonicChords() {
        // Given: Cメジャーキー
        let key = Key(tonic: .c, mode: .major)
        
        // When: ダイアトニックコードを生成
        let chords = service.generateDiatonicChordsDirectly(for: key)
        
        // Then: 7つのダイアトニックコードが生成される
        #expect(chords.count == 7, "7つのダイアトニックコードが生成されること")
        
        // 各コードの確認
        #expect(chords[0].chord.root == .c && chords[0].chord.quality == .major, "Iコード: C")
        #expect(chords[1].chord.root == .d && chords[1].chord.quality == .minor, "iiコード: Dm")
        #expect(chords[2].chord.root == .e && chords[2].chord.quality == .minor, "iiiコード: Em")
        #expect(chords[3].chord.root == .f && chords[3].chord.quality == .major, "IVコード: F")
        #expect(chords[4].chord.root == .g && chords[4].chord.quality == .major, "Vコード: G")
        #expect(chords[5].chord.root == .a && chords[5].chord.quality == .minor, "viコード: Am")
        #expect(chords[6].chord.root == .b && chords[6].chord.quality == .diminished, "vii°コード: Bdim")
        
        // ローマ数字表記の確認
        #expect(chords[0].romanNumeral == "I", "Iコード")
        #expect(chords[1].romanNumeral == "ii", "iiコード")
        #expect(chords[2].romanNumeral == "iii", "iiiコード")
        #expect(chords[3].romanNumeral == "IV", "IVコード")
        #expect(chords[4].romanNumeral == "V", "Vコード")
        #expect(chords[5].romanNumeral == "vi", "viコード")
        #expect(chords[6].romanNumeral == "vii°", "vii°コード")
        
        // ハーモニック機能の確認
        #expect(chords[0].function == .tonic, "Iコード: tonic")
        #expect(chords[1].function == .subdominant, "iiコード: subdominant")
        #expect(chords[2].function == .tonic, "iiiコード: tonic")
        #expect(chords[3].function == .subdominant, "IVコード: subdominant")
        #expect(chords[4].function == .dominant, "Vコード: dominant")
        #expect(chords[5].function == .tonic, "viコード: tonic")
        #expect(chords[6].function == .dominant, "vii°コード: dominant")
    }
    
    @Test
    func testAMinorDiatonicChords() {
        // Given: Aマイナーキー
        let key = Key(tonic: .a, mode: .minor)
        
        // When: ダイアトニックコードを生成
        let chords = service.generateDiatonicChordsDirectly(for: key)
        
        // Then: 7つのダイアトニックコードが生成される
        #expect(chords.count == 7, "7つのダイアトニックコードが生成されること")
        
        // 各コードの確認
        #expect(chords[0].chord.root == .a && chords[0].chord.quality == .minor, "iコード: Am")
        #expect(chords[1].chord.root == .b && chords[1].chord.quality == .diminished, "ii°コード: Bdim")
        #expect(chords[2].chord.root == .c && chords[2].chord.quality == .major, "IIIコード: C")
        #expect(chords[3].chord.root == .d && chords[3].chord.quality == .minor, "ivコード: Dm")
        #expect(chords[4].chord.root == .e && chords[4].chord.quality == .minor, "vコード: Em")
        #expect(chords[5].chord.root == .f && chords[5].chord.quality == .major, "VIコード: F")
        #expect(chords[6].chord.root == .g && chords[6].chord.quality == .major, "VIIコード: G")
        
        // ローマ数字表記の確認
        #expect(chords[0].romanNumeral == "i", "iコード")
        #expect(chords[1].romanNumeral == "ii°", "ii°コード")
        #expect(chords[2].romanNumeral == "III", "IIIコード")
        #expect(chords[3].romanNumeral == "iv", "ivコード")
        #expect(chords[4].romanNumeral == "v", "vコード")
        #expect(chords[5].romanNumeral == "VI", "VIコード")
        #expect(chords[6].romanNumeral == "VII", "VIIコード")
        
        // ハーモニック機能の確認
        #expect(chords[0].function == .tonic, "iコード: tonic")
        #expect(chords[1].function == .subdominant, "ii°コード: subdominant")
        #expect(chords[2].function == .tonic, "IIIコード: tonic")
        #expect(chords[3].function == .subdominant, "ivコード: subdominant")
        #expect(chords[4].function == .dominant, "vコード: dominant")
        #expect(chords[5].function == .tonic, "VIコード: tonic")
        #expect(chords[6].function == .dominant, "VIIコード: dominant")
    }
    
    @Test
    func testScaleDegreeMapping() {
        // Given: Cメジャーキー
        let key = Key(tonic: .c, mode: .major)
        
        // When: ダイアトニックコードを生成
        let chords = service.generateDiatonicChordsDirectly(for: key)
        
        // Then: 各コードが正しいスケール度数を持つ
        #expect(chords[0].degree == .i, "第1度")
        #expect(chords[1].degree == .ii, "第2度")
        #expect(chords[2].degree == .iii, "第3度")
        #expect(chords[3].degree == .iv, "第4度")
        #expect(chords[4].degree == .v, "第5度")
        #expect(chords[5].degree == .vi, "第6度")
        #expect(chords[6].degree == .vii, "第7度")
    }
    
    @Test
    func testChordSymbols() {
        // Given: Cメジャーキー
        let key = Key(tonic: .c, mode: .major)
        
        // When: ダイアトニックコードを生成
        let chords = service.generateDiatonicChordsDirectly(for: key)
        
        // Then: 各コードが正しいシンボルを持つ
        #expect(chords[0].chord.symbol == "C", "Cメジャー")
        #expect(chords[1].chord.symbol == "Dm", "Dマイナー")
        #expect(chords[2].chord.symbol == "Em", "Eマイナー")
        #expect(chords[3].chord.symbol == "F", "Fメジャー")
        #expect(chords[4].chord.symbol == "G", "Gメジャー")
        #expect(chords[5].chord.symbol == "Am", "Aマイナー")
        #expect(chords[6].chord.symbol == "Bdim", "Bディミニッシュ")
    }
    
    @Test
    func testDifferentKeys() {
        // Given: さまざまなキー
        let gMajor = Key(tonic: .g, mode: .major)
        let dMinor = Key(tonic: .d, mode: .minor)
        
        // When: ダイアトニックコードを生成
        let gMajorChords = service.generateDiatonicChordsDirectly(for: gMajor)
        let dMinorChords = service.generateDiatonicChordsDirectly(for: dMinor)
        
        // Then: 正しい数のコードが生成される
        #expect(gMajorChords.count == 7, "Gメジャーキー: 7つのコード")
        #expect(dMinorChords.count == 7, "Dマイナーキー: 7つのコード")
        
        // Gメジャーキーの最初のコードはG
        #expect(gMajorChords[0].chord.root == .g && gMajorChords[0].chord.quality == .major, "GメジャーキーのIコード: G")
        
        // DマイナーキーのIコードはDm
        #expect(dMinorChords[0].chord.root == .d && dMinorChords[0].chord.quality == .minor, "Dマイナーキーのiコード: Dm")
    }
}