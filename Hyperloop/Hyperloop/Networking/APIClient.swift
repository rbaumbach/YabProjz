import Foundation

enum APIClientError: Error {
    case requestError
    case dataError
    case invalidStatusCodeError
    case malformedResponseError
    case responseJSONError
}

protocol APIClientProtocol {
    func requestAndDeserialize<T: Codable>(endpoint: String,
                                           parameters: [String: String],
                                           headers: [String: String]?,
                                           completionHandler: @escaping (Result<T, Error>) -> Void)
}

final class APIClient: APIClientProtocol {
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
    
    convenience init() {
        self.init(baseURL: Constants.Imgur.BaseURL)
    }
    
    func requestAndDeserialize<T: Codable>(endpoint: String,
                                           parameters: [String: String],
                                           headers: [String: String]?,
                                           completionHandler: @escaping (Result<T, Error>) -> Void) {
        requestData(endpoint: endpoint,
                    parameters: parameters,
                    headers: headers) { [weak self] data, error in
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
                
                print(error)
                
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            }
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
                             headers: [String: String]?,
                             completionHandler: @escaping (Data?, Error?) -> Void) {
        let urlRequest = constructURLRequest(baseURL: baseURL,
                                             endpoint: endpoint,
                                             headers: headers,
                                             parameters: parameters)
        print(urlRequest)
        
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
