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
                print("HTTP Request Failed \(String(describing: error))")
                
                return
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                print("HTTP Request Failed: Response is malformed")
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("HTTP Request Failed: Non 200 status code")
                
                return
            }
            
            guard let data = data else {
                print("HTTP Request Failed: Data is nil")
                
                return
            }
            
            guard let dictResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("HTTP Request Failed: Cannot parse response")
                
                return
            }
            
            print(dictResponse)
            
            let result: Result<[String : Any], Error> = Result.success(dictResponse)
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
        
        dataTask.resume()
    }
}
