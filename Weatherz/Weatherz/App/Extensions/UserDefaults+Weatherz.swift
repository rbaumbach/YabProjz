import Foundation

protocol UserDefaultsProtocol {
    func bool(forKey defaultName: String) -> Bool
    
    func object(forKey: String) -> Any?
}

extension UserDefaults: UserDefaultsProtocol { }
