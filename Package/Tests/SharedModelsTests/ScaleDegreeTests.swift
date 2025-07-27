import Testing
@testable import SharedModels

/// ScaleDegree enumのテストスイート
struct ScaleDegreeTests {
    
    @Test
    func scaleDegreeRawValues() {
        #expect(ScaleDegree.i.rawValue == 1)
        #expect(ScaleDegree.ii.rawValue == 2)
        #expect(ScaleDegree.iii.rawValue == 3)
        #expect(ScaleDegree.iv.rawValue == 4)
        #expect(ScaleDegree.v.rawValue == 5)
        #expect(ScaleDegree.vi.rawValue == 6)
        #expect(ScaleDegree.vii.rawValue == 7)
    }
    
    @Test
    func majorKeyRomanNumerals() {
        #expect(ScaleDegree.i.majorRomanNumeral == "I")
        #expect(ScaleDegree.ii.majorRomanNumeral == "ii")
        #expect(ScaleDegree.iii.majorRomanNumeral == "iii")
        #expect(ScaleDegree.iv.majorRomanNumeral == "IV")
        #expect(ScaleDegree.v.majorRomanNumeral == "V")
        #expect(ScaleDegree.vi.majorRomanNumeral == "vi")
        #expect(ScaleDegree.vii.majorRomanNumeral == "vii°")
    }
    
    @Test
    func minorKeyRomanNumerals() {
        #expect(ScaleDegree.i.minorRomanNumeral == "i")
        #expect(ScaleDegree.ii.minorRomanNumeral == "ii°")
        #expect(ScaleDegree.iii.minorRomanNumeral == "III")
        #expect(ScaleDegree.iv.minorRomanNumeral == "iv")
        #expect(ScaleDegree.v.minorRomanNumeral == "v")
        #expect(ScaleDegree.vi.minorRomanNumeral == "VI")
        #expect(ScaleDegree.vii.minorRomanNumeral == "VII")
    }
    
    @Test
    func romanNumeralForKeyMode() {
        let degree = ScaleDegree.i
        #expect(degree.romanNumeral(for: .major) == "I")
        #expect(degree.romanNumeral(for: .minor) == "i")
        
        let fifthDegree = ScaleDegree.v
        #expect(fifthDegree.romanNumeral(for: .major) == "V")
        #expect(fifthDegree.romanNumeral(for: .minor) == "v")
        
        let seventhDegree = ScaleDegree.vii
        #expect(seventhDegree.romanNumeral(for: .major) == "vii°")
        #expect(seventhDegree.romanNumeral(for: .minor) == "VII")
    }
    
    @Test
    func scaleDegreeAllCases() {
        let allCases = ScaleDegree.allCases
        #expect(allCases.count == 7)
        #expect(allCases.contains(.i))
        #expect(allCases.contains(.ii))
        #expect(allCases.contains(.iii))
        #expect(allCases.contains(.iv))
        #expect(allCases.contains(.v))
        #expect(allCases.contains(.vi))
        #expect(allCases.contains(.vii))
    }
    
    @Test
    func scaleDegreeEquality() {
        #expect(ScaleDegree.i == ScaleDegree.i)
        #expect(ScaleDegree.i != ScaleDegree.ii)
        #expect(ScaleDegree.v == ScaleDegree.v)
        #expect(ScaleDegree.v != ScaleDegree.vi)
    }
    
    @Test
    func scaleDegreeComparison() {
        #expect(ScaleDegree.i.rawValue < ScaleDegree.ii.rawValue)
        #expect(ScaleDegree.v.rawValue > ScaleDegree.iv.rawValue)
        #expect(ScaleDegree.vii.rawValue == 7)
    }
    
    @Test
    func scaleDegreeHashability() {
        let degree1 = ScaleDegree.i
        let degree2 = ScaleDegree.i
        let degree3 = ScaleDegree.ii
        
        #expect(degree1.hashValue == degree2.hashValue)
        #expect(degree1.hashValue != degree3.hashValue)
    }
}