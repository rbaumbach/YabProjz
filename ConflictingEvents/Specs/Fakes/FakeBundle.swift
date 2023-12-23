import Foundation
@testable import ConflictingEvents

final class FakeBundle: BundleProtocol {
    // MARK: - Captured properties
    
    var capturedPathForResource: String?
    var capturedPathOfType: String?
    
    // MARK: - Stubbed propreties
    
    var stubbedPath: String? = "/no/where/but/here.json"
    
    // MARK: - BundleProtocol
    
    func path(forResource name: String?, ofType ext: String?) -> String? {
        capturedPathForResource = name
        capturedPathOfType = ext
        
        return stubbedPath
    }
}
