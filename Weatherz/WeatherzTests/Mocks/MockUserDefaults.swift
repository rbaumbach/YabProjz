@testable import Weatherz

final class MockUserDefaults: UserDefaultsProtocol {
    var capturedBoolKey: String?
    
    var capturedObjectKey: String?
    
    var stubbedBool = false
    
    var stubbedObject: Any? = nil
    
    func bool(forKey defaultName: String) -> Bool {
        capturedBoolKey = defaultName
        
        return stubbedBool
    }
    
    func object(forKey: String) -> Any? {
        capturedObjectKey = forKey
        
        return stubbedObject
    }
}
