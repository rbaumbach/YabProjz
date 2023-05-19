import Foundation

@testable import Weatherz

final class MockFileManager: FileManagerProtocol {
    var capturedReadFromDocumentsDirFilename: String?
    
    var capturedSaveToDocumentsDirData: Codable?
    var capturedSaveToDocumentsDirFilename: String?
    
    var stubbedDocumentsDirectoryURL = URL(string: "http://jnb77dhdh8jH.hit")!
    
    var stubbedReadFromDocumentsDir: Any? = nil
    
    
    func documentsDirectory() -> URL {
        return stubbedDocumentsDirectoryURL
    }
    
    func readFromDocumentsDir<T>(filename: String) -> T? where T : Decodable, T : Encodable {
        capturedReadFromDocumentsDirFilename = filename
        
        return stubbedReadFromDocumentsDir as? T
    }
    
    func saveToDocumentsDir(data: Codable, filename: String) {
        capturedSaveToDocumentsDirData = data
        capturedSaveToDocumentsDirFilename = filename
    }
}
