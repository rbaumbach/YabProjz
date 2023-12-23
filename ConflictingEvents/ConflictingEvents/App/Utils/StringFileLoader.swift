import Foundation

protocol StringFileLoaderProtocol {
    func loadString(path: String) throws -> String
    func loadData(path: String) throws -> Data?
}

final class StringFileLoader: StringFileLoaderProtocol {
    func loadString(path: String) throws -> String {
        return try String(contentsOfFile: path)
    }
    
    func loadData(path: String) throws -> Data? {
        return try loadString(path: path).data(using: .utf8)
    }
}
