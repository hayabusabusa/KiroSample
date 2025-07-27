import Testing
@testable import SharedModels

/// Key structのテストスイート
struct KeyTests {
    
    @Test
    func keyInitialization() {
        let cMajor = Key(tonic: .c, mode: .major)
        #expect(cMajor.tonic == .c)
        #expect(cMajor.mode == .major)
        #expect(cMajor.shortName == "C")
        
        let aminor = Key(tonic: .a, mode: .minor)
        #expect(aminor.tonic == .a)
        #expect(aminor.mode == .minor)
        #expect(aminor.shortName == "Am")
    }
    
    @Test
    func majorKeyNames() {
        let cMajor = Key(tonic: .c, mode: .major)
        #expect(cMajor.shortName == "C")
        
        let gMajor = Key(tonic: .g, mode: .major)
        #expect(gMajor.shortName == "G")
        
        let fSharpMajor = Key(tonic: .fSharp, mode: .major)
        #expect(fSharpMajor.shortName == "F#")
        
        let bFlatMajor = Key(tonic: .bFlat, mode: .major)
        #expect(bFlatMajor.shortName == "Bb")
    }
    
    @Test
    func minorKeyNames() {
        let aminor = Key(tonic: .a, mode: .minor)
        #expect(aminor.shortName == "Am")
        
        let fSharpMinor = Key(tonic: .fSharp, mode: .minor)
        #expect(fSharpMinor.shortName == "F#m")
        
        let cMinor = Key(tonic: .c, mode: .minor)
        #expect(cMinor.shortName == "Cm")
        
        let eFlatMinor = Key(tonic: .eFlat, mode: .minor)
        #expect(eFlatMinor.shortName == "Ebm")
    }
    
    @Test
    func keySignatureGeneration() {
        // シャープ系メジャーキー
        let cMajor = Key(tonic: .c, mode: .major)
        #expect(cMajor.keySignature.sharps.count == 0)
        #expect(cMajor.keySignature.flats.count == 0)
        
        let gMajor = Key(tonic: .g, mode: .major)
        #expect(gMajor.keySignature.sharps.count == 1)
        #expect(gMajor.keySignature.flats.count == 0)
        
        let dMajor = Key(tonic: .d, mode: .major)
        #expect(dMajor.keySignature.sharps.count == 2)
        #expect(dMajor.keySignature.flats.count == 0)
        
        // フラット系メジャーキー
        let fMajor = Key(tonic: .f, mode: .major)
        #expect(fMajor.keySignature.sharps.count == 0)
        #expect(fMajor.keySignature.flats.count == 1)
        
        let bFlatMajor = Key(tonic: .bFlat, mode: .major)
        #expect(bFlatMajor.keySignature.sharps.count == 0)
        #expect(bFlatMajor.keySignature.flats.count == 2)
    }
    
    @Test
    func minorKeySignatureGeneration() {
        // Aマイナー（Cメジャーと同じ調号）
        let aminor = Key(tonic: .a, mode: .minor)
        #expect(aminor.keySignature.sharps.count == 0)
        #expect(aminor.keySignature.flats.count == 0)
        
        // Eマイナー（Gメジャーと同じ調号）
        let eMinor = Key(tonic: .e, mode: .minor)
        #expect(eMinor.keySignature.sharps.count == 1)
        #expect(eMinor.keySignature.flats.count == 0)
        
        // Dマイナー（Fメジャーと同じ調号）
        let dMinor = Key(tonic: .d, mode: .minor)
        #expect(dMinor.keySignature.sharps.count == 0)
        #expect(dMinor.keySignature.flats.count == 1)
    }
    
    @Test
    func keyEquality() {
        let cMajor1 = Key(tonic: .c, mode: .major)
        let cMajor2 = Key(tonic: .c, mode: .major)
        let cMinor = Key(tonic: .c, mode: .minor)
        let gMajor = Key(tonic: .g, mode: .major)
        
        #expect(cMajor1 == cMajor2)
        #expect(cMajor1 != cMinor)
        #expect(cMajor1 != gMajor)
        #expect(cMinor != gMajor)
    }
    
    @Test
    func keyHashability() {
        let cMajor1 = Key(tonic: .c, mode: .major)
        let cMajor2 = Key(tonic: .c, mode: .major)
        let cMinor = Key(tonic: .c, mode: .minor)
        
        #expect(cMajor1.hashValue == cMajor2.hashValue)
        #expect(cMajor1.hashValue != cMinor.hashValue)
    }
    
    @Test
    func relativeKeys() {
        // メジャーキーと関係短調
        let cMajor = Key(tonic: .c, mode: .major)
        let aminor = Key(tonic: .a, mode: .minor)
        
        // 調号が同じかチェック
        #expect(cMajor.keySignature.sharps == aminor.keySignature.sharps)
        #expect(cMajor.keySignature.flats == aminor.keySignature.flats)
        #expect(cMajor.keySignature.accidentals == aminor.keySignature.accidentals)
        
        // Gメジャーとeマイナー
        let gMajor = Key(tonic: .g, mode: .major)
        let eMinor = Key(tonic: .e, mode: .minor)
        
        #expect(gMajor.keySignature.sharps == eMinor.keySignature.sharps)
        #expect(gMajor.keySignature.flats == eMinor.keySignature.flats)
        #expect(gMajor.keySignature.accidentals == eMinor.keySignature.accidentals)
    }
    
    @Test
    func enharmonicKeys() {
        // 異名同音のキー（例：C#メジャー vs Dbメジャー）
        let cSharpMajor = Key(tonic: .cSharp, mode: .major)
        let dFlatMajor = Key(tonic: .dFlat, mode: .major)
        
        // 音楽理論的には同じキーだが、オブジェクトとしては異なる
        #expect(cSharpMajor != dFlatMajor)
        #expect(cSharpMajor.shortName != dFlatMajor.shortName)
        
        // 実際の調号の数をチェック（C#とDbは同じsemitoneValueのため、Db -5がマッチ）
        #expect(cSharpMajor.keySignature.sharps.count == 0) // Dbマッチのためフラット
        #expect(dFlatMajor.keySignature.flats.count == 5)
        #expect(cSharpMajor.keySignature.accidentals == -5) // DbマッチでDb Major -5
        #expect(dFlatMajor.keySignature.accidentals == -5)
    }
}