import Foundation

protocol FileManagerProtocol {
    func readFromDocumentsDir<T: Codable>(fileName: String) -> T?
    func saveToDocumentsDir(data: Codable, fileName: String)
}

extension FileManager: FileManagerProtocol {
    func documentsDirectory() -> URL {
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))[0]
    }
    
    func readFromDocumentsDir<T: Codable>(fileName: String) -> T? {
        let documentsDir = documentsDirectory()
        let fullURL = documentsDir.appendingPathComponent(fileName)
                
        print(fullURL)
        
        guard let encodedData = FileManager.default.contents(atPath: fullURL.path) else {
            return nil
        }
        
        let decodedData = try! JSONDecoder().decode(T.self, from: encodedData)
        
        return decodedData
    }
    
    func saveToDocumentsDir(data: Codable, fileName: String) {
        let documentsDir = documentsDirectory()
        let fullURL = documentsDir.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fullURL.path) {
            try! FileManager.default.removeItem(at: fullURL)
        }
        
        let encodedData =  try! JSONEncoder().encode(data)
        
        try! encodedData.write(to: fullURL)
    }
}
