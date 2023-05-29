import Foundation

enum APIClientError: Error {
    case requestError
    case dataError
    case invalidStatusCodeError
    case malformedResponseError
    case responseJSONError
}

final class APIClient {
    // MARK: - Private properties
    
    private let urlSession: URLSessionProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Readonly properties
    
    let baseURL: String
    
    // MARK: - Init methods
    
    init(baseURL: String,
         urlSession: URLSessionProtocol = URLSession.shared,
         dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    // TODO: Share dataTask logic between both request methods
    
    func request(endpoint: String,
                 headers: [String: String]? = nil,
                 parameters: [String: String],
                 completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlRequest = constructURLRequest(baseURL: baseURL,
                                             endpoint: endpoint,
                                             headers: headers,
                                             parameters: parameters)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }

            guard error == nil else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.requestError)
                                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.malformedResponseError)
                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.invalidStatusCodeError)
                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard let data = data else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.dataError)
                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard let dictResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                let result: Result<[String : Any], Error> = Result.failure(APIClientError.responseJSONError)
                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
                        
            let result: Result<[String : Any], Error> = Result.success(dictResponse)
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(result)
            }
        }
        
        dataTask.resume()
    }
    
    func requestAndDeserialize<T: Codable>(endpoint: String,
                                           parameters: [String: String],
                                           completionHandler: @escaping (Result<T, Error>) -> Void) {
        requestData(endpoint: endpoint, parameters: parameters) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                let result: Result<T, Error> = Result.failure(error)
                                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            guard let data = data else {
                let result: Result<T, Error> = Result.failure(APIClientError.dataError)
 
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
                
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                
                let result: Result<T, Error> = Result.success(decodedData)

                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            } catch {
                let result: Result<T, Error> = Result.failure(error)
                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            }
        }
    }
    
    func requestAndDeserializeFakeResponse<T: Codable>(response: String,
                                                       completionHandler: @escaping (Result<T, Error>) -> Void) {
        do {
            let responseData = Data(response.utf8)
            
            let decodedData = try JSONDecoder().decode(T.self, from: responseData)
            
            let success: Result<T, Error> = Result.success(decodedData)

            completionHandler(success)
        } catch {
            let failure: Result<T, Error> = Result.failure(error)
            
            completionHandler(failure)
        }
    }
    
    // MARK: - Private methods
    
    private func constructURLRequest(baseURL: String,
                                     endpoint: String,
                                     headers: [String: String]?,
                                     parameters: [String: String]) -> URLRequest {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = endpoint
        
        urlComponents.queryItems = parameters.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    private func requestData(endpoint: String,
                             parameters: [String: String],
                             completionHandler: @escaping (Data?, Error?) -> Void) {
        let urlRequest = constructURLRequest(baseURL: baseURL,
                                             endpoint: endpoint,
                                             headers: nil,
                                             parameters: parameters)
        let dataTask: URLSessionDataTaskProtocol = urlSession.dataTask(with: urlRequest) { data, response, error in
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
