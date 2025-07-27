import Testing
@testable import SharedModels

/// Note enumのテストスイート
struct NoteTests {
    
    @Test
    func noteInitialization() {
        let note = Note.c
        #expect(note.name == "C")
        #expect(note.semitoneValue == 0)
        #expect(note.isNatural == true)
    }
    
    @Test
    func allNotesHaveCorrectSemitoneValues() {
        #expect(Note.c.semitoneValue == 0)
        #expect(Note.cSharp.semitoneValue == 1)
        #expect(Note.dFlat.semitoneValue == 1)
        #expect(Note.d.semitoneValue == 2)
        #expect(Note.dSharp.semitoneValue == 3)
        #expect(Note.eFlat.semitoneValue == 3)
        #expect(Note.e.semitoneValue == 4)
        #expect(Note.f.semitoneValue == 5)
        #expect(Note.fSharp.semitoneValue == 6)
        #expect(Note.gFlat.semitoneValue == 6)
        #expect(Note.g.semitoneValue == 7)
        #expect(Note.gSharp.semitoneValue == 8)
        #expect(Note.aFlat.semitoneValue == 8)
        #expect(Note.a.semitoneValue == 9)
        #expect(Note.aSharp.semitoneValue == 10)
        #expect(Note.bFlat.semitoneValue == 10)
        #expect(Note.b.semitoneValue == 11)
    }
    
    @Test
    func enharmonicEquivalents() {
        #expect(Note.cSharp.enharmonicEquivalent == Note.dFlat)
        #expect(Note.dFlat.enharmonicEquivalent == Note.cSharp)
        #expect(Note.dSharp.enharmonicEquivalent == Note.eFlat)
        #expect(Note.eFlat.enharmonicEquivalent == Note.dSharp)
        #expect(Note.fSharp.enharmonicEquivalent == Note.gFlat)
        #expect(Note.gFlat.enharmonicEquivalent == Note.fSharp)
        #expect(Note.gSharp.enharmonicEquivalent == Note.aFlat)
        #expect(Note.aFlat.enharmonicEquivalent == Note.gSharp)
        #expect(Note.aSharp.enharmonicEquivalent == Note.bFlat)
        #expect(Note.bFlat.enharmonicEquivalent == Note.aSharp)
        
        // 自然音は異名同音がない
        #expect(Note.c.enharmonicEquivalent == nil)
        #expect(Note.d.enharmonicEquivalent == nil)
        #expect(Note.e.enharmonicEquivalent == nil)
        #expect(Note.f.enharmonicEquivalent == nil)
        #expect(Note.g.enharmonicEquivalent == nil)
        #expect(Note.a.enharmonicEquivalent == nil)
        #expect(Note.b.enharmonicEquivalent == nil)
    }
    
    @Test
    func naturalNoteClassification() {
        // 自然音
        #expect(Note.c.isNatural == true)
        #expect(Note.d.isNatural == true)
        #expect(Note.e.isNatural == true)
        #expect(Note.f.isNatural == true)
        #expect(Note.g.isNatural == true)
        #expect(Note.a.isNatural == true)
        #expect(Note.b.isNatural == true)
        
        // シャープ・フラット音
        #expect(Note.cSharp.isNatural == false)
        #expect(Note.dFlat.isNatural == false)
        #expect(Note.dSharp.isNatural == false)
        #expect(Note.eFlat.isNatural == false)
        #expect(Note.fSharp.isNatural == false)
        #expect(Note.gFlat.isNatural == false)
        #expect(Note.gSharp.isNatural == false)
        #expect(Note.aFlat.isNatural == false)
        #expect(Note.aSharp.isNatural == false)
        #expect(Note.bFlat.isNatural == false)
    }
    
    @Test
    func noteTransposition() {
        let c = Note.c
        
        // 完全5度上昇（7半音）
        let g = c.transposed(by: 7)
        #expect(g.semitoneValue == 7)
        
        // 完全8度上昇（12半音）
        let cOctave = c.transposed(by: 12)
        #expect(cOctave.semitoneValue == 0) // オクターブ上のC
        
        // 短3度上昇（3半音）
        let eFlat = c.transposed(by: 3)
        #expect(eFlat.semitoneValue == 3)
        
        // 負の値でのテスト（下降）
        let f = c.transposed(by: -7)
        #expect(f.semitoneValue == 5) // Cから7半音下はF
    }
    
    @Test
    func noteStringRepresentation() {
        #expect(Note.c.name == "C")
        #expect(Note.cSharp.name == "C#")
        #expect(Note.dFlat.name == "Db")
        #expect(Note.fSharp.name == "F#")
        #expect(Note.bFlat.name == "Bb")
    }
    
    @Test
    func noteEqualityAndHashability() {
        let c1 = Note.c
        let c2 = Note.c
        let d = Note.d
        
        #expect(c1 == c2)
        #expect(c1 != d)
        #expect(c1.hashValue == c2.hashValue)
    }
}