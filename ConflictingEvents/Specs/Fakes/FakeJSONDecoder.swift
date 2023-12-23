import Foundation
@testable import ConflictingEvents

final class FakeJSONDecoder: JSONDecoderProtocol {
    // MARK: - Captured properties
    
    var capturedDecodeTypeAsString: String?
    var capturedDecodeFromData: Data?
    
    // MARK: - Stubbed properties
    
    var shouldThrowErrorDecoding = false
    
    var stubbedDecodedItem: Any?
    
    // MARK: - JSONDecoderProtocol
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        capturedDecodeTypeAsString = "\(T.Type.self)"
        capturedDecodeFromData = data
        
        if shouldThrowErrorDecoding {
            throw FakeError.whoCares
        }
        
        return stubbedDecodedItem as! T
    }
}
