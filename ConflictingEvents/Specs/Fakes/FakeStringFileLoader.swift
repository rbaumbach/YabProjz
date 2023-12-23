import Foundation
@testable import ConflictingEvents

enum FakeError: Error {
    case whoCares
}

final class FakeStringFileLoader: StringFileLoaderProtocol {
    // MARK: - Captured properties
    
    var capturedLoadStringPath: String?
    var capturedLoadDataPath: String?
    
    // MARK: - Stubbed properties
    
    var shouldThrowErrowLoadingString = false
    var shouldThrowErrorLoadingData = false
    
    var stubbedLoadString = "Loaded"
    var stubbedLoadData = "Loaded".data(using: .utf8)
    
    // MARK: - StringFileLoaderProtocol
    
    func loadString(path: String) throws -> String {
        capturedLoadStringPath = path
        
        if shouldThrowErrowLoadingString {
            throw FakeError.whoCares
        }
        
        return stubbedLoadString
    }
    
    func loadData(path: String) throws -> Data? {
        capturedLoadDataPath = path
        
        if shouldThrowErrorLoadingData {
            throw FakeError.whoCares
        }
        
        return stubbedLoadData
    }
}
