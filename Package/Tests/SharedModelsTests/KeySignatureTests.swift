import Testing
@testable import SharedModels

/// KeySignature structのテストスイート
struct KeySignatureTests {
    
    @Test
    func keySignatureInitialization() {
        let cMajorSignature = KeySignature(accidentals: 0)
        #expect(cMajorSignature.accidentals == 0)
        #expect(cMajorSignature.sharps.isEmpty)
        #expect(cMajorSignature.flats.isEmpty)
        
        let gMajorSignature = KeySignature(accidentals: 1)
        #expect(gMajorSignature.accidentals == 1)
        #expect(gMajorSignature.sharps.count == 1)
        #expect(gMajorSignature.flats.isEmpty)
        
        let fMajorSignature = KeySignature(accidentals: -1)
        #expect(fMajorSignature.accidentals == -1)
        #expect(fMajorSignature.sharps.isEmpty)
        #expect(fMajorSignature.flats.count == 1)
    }
    
    @Test
    func sharpKeySignatures() {
        // シャープ系のキー
        let signatures = [
            KeySignature(accidentals: 0), // C major
            KeySignature(accidentals: 1), // G major
            KeySignature(accidentals: 2), // D major
            KeySignature(accidentals: 3), // A major
            KeySignature(accidentals: 4), // E major
            KeySignature(accidentals: 5), // B major
            KeySignature(accidentals: 6), // F# major
            KeySignature(accidentals: 7), // C# major
        ]
        
        for (index, signature) in signatures.enumerated() {
            #expect(signature.accidentals == index)
            #expect(signature.sharps.count == index)
            #expect(signature.flats.isEmpty)
        }
    }
    
    @Test
    func flatKeySignatures() {
        // フラット系のキー
        let signatures = [
            KeySignature(accidentals: 0),  // C major
            KeySignature(accidentals: -1), // F major
            KeySignature(accidentals: -2), // Bb major
            KeySignature(accidentals: -3), // Eb major
            KeySignature(accidentals: -4), // Ab major
            KeySignature(accidentals: -5), // Db major
            KeySignature(accidentals: -6), // Gb major
            KeySignature(accidentals: -7), // Cb major
        ]
        
        for (index, signature) in signatures.enumerated() {
            #expect(signature.accidentals == -index)
            #expect(signature.sharps.isEmpty)
            #expect(signature.flats.count == index)
        }
    }
    
    @Test
    func keySignatureEquality() {
        let signature1 = KeySignature(accidentals: 1)
        let signature2 = KeySignature(accidentals: 1)
        let signature3 = KeySignature(accidentals: -1)
        let signature4 = KeySignature(accidentals: 2)
        
        #expect(signature1 == signature2)
        #expect(signature1 != signature3)
        #expect(signature1 != signature4)
        #expect(signature3 != signature4)
    }
    
    @Test
    func keySignatureHashability() {
        let signature1 = KeySignature(accidentals: 1)
        let signature2 = KeySignature(accidentals: 1)
        let signature3 = KeySignature(accidentals: -1)
        
        #expect(signature1.hashValue == signature2.hashValue)
        #expect(signature1.hashValue != signature3.hashValue)
    }
    
    @Test
    func keySignatureValidation() {
        // 理論的に、シャープとフラットは同時に存在しない
        let cMajor = KeySignature(accidentals: 0)
        #expect(cMajor.sharps.isEmpty && cMajor.flats.isEmpty) // OK
        
        let gMajor = KeySignature(accidentals: 1)
        #expect(!gMajor.sharps.isEmpty && gMajor.flats.isEmpty) // OK
        
        let fMajor = KeySignature(accidentals: -1)
        #expect(fMajor.sharps.isEmpty && !fMajor.flats.isEmpty) // OK
        
        // 極端なケース
        let manySharp = KeySignature(accidentals: 7)
        #expect(manySharp.sharps.count == 7 && manySharp.flats.isEmpty)
        
        let manyFlats = KeySignature(accidentals: -7)
        #expect(manyFlats.sharps.isEmpty && manyFlats.flats.count == 7)
    }
    
    @Test
    func extremeKeySignatures() {
        // 理論上の極端なケース
        let manySharp = KeySignature(accidentals: 7) // C# major
        #expect(manySharp.sharps.count == 7)
        #expect(manySharp.flats.isEmpty)
        #expect(manySharp.description == "7♯")
        
        let manyFlats = KeySignature(accidentals: -7) // Cb major
        #expect(manyFlats.sharps.isEmpty)
        #expect(manyFlats.flats.count == 7)
        #expect(manyFlats.description == "7♭")
    }
    
    @Test
    func keySignatureInKeyContext() {
        // Key構造体との統合テスト
        let cMajor = Key(tonic: .c, mode: .major)
        #expect(cMajor.keySignature.accidentals == 0)
        #expect(cMajor.keySignature.sharps.isEmpty)
        #expect(cMajor.keySignature.flats.isEmpty)
        
        let gMajor = Key(tonic: .g, mode: .major)
        #expect(gMajor.keySignature.accidentals == 1)
        #expect(gMajor.keySignature.sharps.count == 1)
        #expect(gMajor.keySignature.flats.isEmpty)
        
        let fMajor = Key(tonic: .f, mode: .major)
        #expect(fMajor.keySignature.accidentals == -1)
        #expect(fMajor.keySignature.sharps.isEmpty)
        #expect(fMajor.keySignature.flats.count == 1)
    }
    
    @Test
    func keySignatureSendable() {
        // Sendableプロトコル適合の確認（コンパイル時チェック）
        let signature = KeySignature(accidentals: 1)
        let signatures: [KeySignature] = [
            KeySignature(accidentals: 0),
            KeySignature(accidentals: 1),
            KeySignature(accidentals: -1)
        ]
        
        #expect(signature.accidentals == 1)
        #expect(signatures.count == 3)
    }
    
    @Test
    func keySignatureDescription() {
        let cMajor = KeySignature(accidentals: 0)
        #expect(cMajor.description == "♮")
        
        let gMajor = KeySignature(accidentals: 1)
        #expect(gMajor.description == "1♯")
        
        let fMajor = KeySignature(accidentals: -1)
        #expect(fMajor.description == "1♭")
        
        let eMajor = KeySignature(accidentals: 4)
        #expect(eMajor.description == "4♯")
        
        let abMajor = KeySignature(accidentals: -4)
        #expect(abMajor.description == "4♭")
    }
    
    @Test
    func keySignatureSharpOrder() {
        let signature = KeySignature(accidentals: 3) // A major (F#, C#, G#)
        let expectedSharps: [Note] = [.f, .c, .g]
        #expect(signature.sharps == expectedSharps)
    }
    
    @Test
    func keySignatureFlatOrder() {
        let signature = KeySignature(accidentals: -3) // Eb major (Bb, Eb, Ab)
        let expectedFlats: [Note] = [.b, .e, .a]
        #expect(signature.flats == expectedFlats)
    }
}