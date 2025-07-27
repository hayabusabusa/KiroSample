import Testing
@testable import SharedModels

/// HarmonicFunction enumのテストスイート
struct HarmonicFunctionTests {
    
    @Test
    func harmonicFunctionDescriptions() {
        #expect(HarmonicFunction.tonic.description == "トニック")
        #expect(HarmonicFunction.subdominant.description == "サブドミナント")
        #expect(HarmonicFunction.dominant.description == "ドミナント")
    }
    
    @Test
    func harmonicFunctionDetailedDescriptions() {
        #expect(HarmonicFunction.tonic.detailedDescription == "安定した響きを持つ主和音")
        #expect(HarmonicFunction.subdominant.detailedDescription == "下属和音として中間的な響きを持つ")
        #expect(HarmonicFunction.dominant.detailedDescription == "緊張感を持ち主和音へ解決する")
    }
    
    @Test
    func harmonicFunctionRawValues() {
        #expect(HarmonicFunction.tonic.rawValue == "tonic")
        #expect(HarmonicFunction.subdominant.rawValue == "subdominant")
        #expect(HarmonicFunction.dominant.rawValue == "dominant")
    }
    
    @Test
    func harmonicFunctionAllCases() {
        let allCases = HarmonicFunction.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.tonic))
        #expect(allCases.contains(.subdominant))
        #expect(allCases.contains(.dominant))
    }
    
    @Test
    func typicalDegreesInMajor() {
        let tonicDegrees = HarmonicFunction.tonic.typicalDegreesInMajor
        #expect(tonicDegrees.contains(.i))
        #expect(tonicDegrees.contains(.iii))
        #expect(tonicDegrees.contains(.vi))
        #expect(tonicDegrees.count == 3)
        
        let subdominantDegrees = HarmonicFunction.subdominant.typicalDegreesInMajor
        #expect(subdominantDegrees.contains(.ii))
        #expect(subdominantDegrees.contains(.iv))
        #expect(subdominantDegrees.count == 2)
        
        let dominantDegrees = HarmonicFunction.dominant.typicalDegreesInMajor
        #expect(dominantDegrees.contains(.v))
        #expect(dominantDegrees.contains(.vii))
        #expect(dominantDegrees.count == 2)
    }
    
    @Test
    func typicalDegreesInMinor() {
        let tonicDegrees = HarmonicFunction.tonic.typicalDegreesInMinor
        #expect(tonicDegrees.contains(.i))
        #expect(tonicDegrees.contains(.iii))
        #expect(tonicDegrees.contains(.vi))
        #expect(tonicDegrees.count == 3)
        
        let subdominantDegrees = HarmonicFunction.subdominant.typicalDegreesInMinor
        #expect(subdominantDegrees.contains(.ii))
        #expect(subdominantDegrees.contains(.iv))
        #expect(subdominantDegrees.count == 2)
        
        let dominantDegrees = HarmonicFunction.dominant.typicalDegreesInMinor
        #expect(dominantDegrees.contains(.v))
        #expect(dominantDegrees.contains(.vii))
        #expect(dominantDegrees.count == 2)
    }
    
    @Test
    func harmonicFunctionEquality() {
        #expect(HarmonicFunction.tonic == HarmonicFunction.tonic)
        #expect(HarmonicFunction.tonic != HarmonicFunction.subdominant)
        #expect(HarmonicFunction.subdominant == HarmonicFunction.subdominant)
        #expect(HarmonicFunction.dominant != HarmonicFunction.tonic)
    }
    
    @Test
    func harmonicFunctionHashability() {
        let tonic1 = HarmonicFunction.tonic
        let tonic2 = HarmonicFunction.tonic
        let subdominant = HarmonicFunction.subdominant
        
        #expect(tonic1.hashValue == tonic2.hashValue)
        #expect(tonic1.hashValue != subdominant.hashValue)
    }
    
    @Test
    func harmonicFunctionSendable() {
        // Sendableプロトコル適合の確認（コンパイル時チェック）
        let function = HarmonicFunction.tonic
        let functions: [HarmonicFunction] = [.tonic, .subdominant, .dominant]
        
        #expect(function == .tonic)
        #expect(functions.count == 3)
    }
    
    @Test
    func musicTheoryConsistency() {
        // 音楽理論的な一貫性の確認
        
        // トニック機能はI, iii, viコードに含まれる
        let tonicInMajor = HarmonicFunction.tonic.typicalDegreesInMajor
        #expect(tonicInMajor.contains(.i)) // I コード
        #expect(tonicInMajor.contains(.iii)) // iii コード
        #expect(tonicInMajor.contains(.vi)) // vi コード
        
        // サブドミナント機能はii, IVコードに含まれる
        let subdominantInMajor = HarmonicFunction.subdominant.typicalDegreesInMajor
        #expect(subdominantInMajor.contains(.ii)) // ii コード
        #expect(subdominantInMajor.contains(.iv)) // IV コード
        
        // ドミナント機能はV, vii°コードに含まれる
        let dominantInMajor = HarmonicFunction.dominant.typicalDegreesInMajor
        #expect(dominantInMajor.contains(.v)) // V コード
        #expect(dominantInMajor.contains(.vii)) // vii° コード
    }
}