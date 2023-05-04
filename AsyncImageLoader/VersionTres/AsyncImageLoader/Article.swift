import Foundation

// MARK: - Article

struct Article {
    // MARK: - Public properties
    
    var title: String
    var imageURLString: String?
}

// MARK: - Article Fetcher

class ArticleFetcher {
    // MARK: - Private Constants
    
    private let jsonURL = "https://gist.githubusercontent.com/rbaumbach/e084ff63f8188bbcb7637628b3ba8e71/raw/5d3fd684466c893a531e578da1d94efce5a40e2b/feed.json"
    
    // MARK: - Private properties
    
    private let articleDeserializer = ArticleDeserializer()
    
    // MARK: - Public methods
    
    func fetch(completionHandler: @escaping ([Article]) -> Void) {
        let url = URL(string: jsonURL)!
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let `self` = self else {
                completionHandler([])
                
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                completionHandler([])
                
                return
            }
            
            let serializedArticles = jsonResponse["articles"] as! [[String: Any]]
            let deserializedArticles = self.articleDeserializer.deserialize(articles: serializedArticles)
                                    
            DispatchQueue.main.async {
                completionHandler(deserializedArticles)
            }
        }
        
        dataTask.resume()
    }
}

// MARK: - ArticleDeserializer

class ArticleDeserializer {
    // MARK: - Public methods
    
    func deserialize(articles: [[String: Any]]) -> [Article] {
        let deserializedArticles: [Article] = articles.map { articleDict in
            let title = articleDict["title"] as! String
            
            if let imageURLString = articleDict["urlToImage"] as? String {
                return Article(title: title, imageURLString: imageURLString)
            } else {
                return Article(title: title, imageURLString: nil)
            }
        }
        
        return deserializedArticles
    }
}
