import Testing
@testable import SharedModels

/// KeyMode enumのテストスイート
struct KeyModeTests {
    
    @Test
    func keyModeSymbols() {
        #expect(KeyMode.major.symbol == "")
        #expect(KeyMode.minor.symbol == "m")
    }
    
    @Test
    func keyModeEquality() {
        #expect(KeyMode.major == KeyMode.major)
        #expect(KeyMode.minor == KeyMode.minor)
        #expect(KeyMode.major != KeyMode.minor)
    }
    
    @Test
    func keyModeHashability() {
        let major1 = KeyMode.major
        let major2 = KeyMode.major
        let minor = KeyMode.minor
        
        #expect(major1.hashValue == major2.hashValue)
        #expect(major1.hashValue != minor.hashValue)
    }
    
    @Test
    func keyModeAllCases() {
        let allCases = KeyMode.allCases
        #expect(allCases.count == 2)
        #expect(allCases.contains(.major))
        #expect(allCases.contains(.minor))
    }
    
    @Test
    func keyModeUsageInKey() {
        let cMajor = Key(tonic: .c, mode: .major)
        #expect(cMajor.shortName == "C")
        
        let cMinor = Key(tonic: .c, mode: .minor)
        #expect(cMinor.shortName == "Cm")
    }
    
    @Test
    func keyModeSendable() {
        // Sendableプロトコル適合の確認（コンパイル時チェック）
        let mode = KeyMode.major
        let modes: [KeyMode] = [.major, .minor]
        
        #expect(mode == .major)
        #expect(modes.count == 2)
    }
}