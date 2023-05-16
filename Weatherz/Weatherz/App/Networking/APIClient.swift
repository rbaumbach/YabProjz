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
        let urlRequest = constructURLRequest(baseURL: baseURL,
                                             endpoint: endpoint,
                                             parameters: parameters)
        
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
    
    func request<T: Codable>(endpoint: String,
                             parameters: [String: String],
                             completionHandler: @escaping (Result<T, Error>) -> Void) {
        requestData(endpoint: endpoint, parameters: parameters) { data, error in
            if let error = error {
                let result: Result<T, Error> = Result.failure(error)
                
                completionHandler(result)
                
                return
            }
            
            guard let data = data else {
                let result: Result<T, Error> = Result.failure(APIClientError.dataError)
                
                completionHandler(result)
                
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                let result: Result<T, Error> = Result.failure(APIClientError.responseJSONError)

                completionHandler(result)

                return
            }

            let result: Result<T, Error> = Result.success(decodedData)

            completionHandler(result)
        }
    }
    
    // MARK: - Private methods
    
    private func constructURLRequest(baseURL: String,
                                     endpoint: String,
                                     parameters: [String: String]) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = endpoint
        
        urlComponents.queryItems = parameters.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        let urlRequest = URLRequest(url: urlComponents.url!)
        
        return urlRequest
    }
    
    private func requestData(endpoint: String,
                             parameters: [String: String],
                             completionHandler: @escaping (Data?, Error?) -> Void) {
        let urlRequest = constructURLRequest(baseURL: baseURL,
                                             endpoint: endpoint,
                                             parameters: parameters)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(nil, APIClientError.requestError)
                
                return
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                completionHandler(nil, APIClientError.malformedResponseError)
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionHandler(nil, APIClientError.invalidStatusCodeError)
                
                return
            }
            
            guard let data = data else {
                completionHandler(nil, APIClientError.dataError)
                
                return
            }
                        
            DispatchQueue.main.async {
                completionHandler(data, nil)
            }
        }
        
        dataTask.resume()
    }
}
