import Foundation

protocol UserDefaultsProtocol {
    func bool(forKey defaultName: String) -> Bool
}

extension UserDefaults: UserDefaultsProtocol { }
