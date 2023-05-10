import Foundation

enum APIClientError: Error {
    case requestError
    case dataError
    case invalidStatusCodeError
    case malformedResponseError
    case responseJSONError
}

final class APIClient {
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func request(endpoint: String,
                 parameters: [String: String],
                 completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = endpoint
        
        urlComponents.queryItems = parameters.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        let urlRequest = URLRequest(url: urlComponents.url!)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.requestError)
                
                completionHandler(result)
                
                return
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.malformedResponseError)
                
                completionHandler(result)
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.invalidStatusCodeError)
                
                completionHandler(result)
                
                return
            }
            
            guard let data = data else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.dataError)
                
                completionHandler(result)
                
                return
            }
            
            guard let dictResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.responseJSONError)
                
                completionHandler(result)
                
                return
            }
                        
            let result: Result<[String : Any], Error> = Result.success(dictResponse)
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
        
        dataTask.resume()
    }
}
