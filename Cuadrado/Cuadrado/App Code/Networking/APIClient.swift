import Foundation
import Capsule

struct APIClientConstants {
    static let baseURLString = "https://s3.amazonaws.com"
}

enum APIClientError: Error {
    case sessionError
    case statusCodeError
    case malformedResponseError
}

protocol APIClientProtocol {
    func get(endpoint: String, completionHandler: @escaping (Result<Any, APIClientError>) -> Void)
}

class APIClient: APIClientProtocol {
    // MARK: -
    
    let baseURL: URL
    let urlSession: URLSessionProtocol
    let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Init methods
    
    convenience init() {
        let defaultBaseURL = URL(string: APIClientConstants.baseURLString)!
        
        self.init(baseURL: defaultBaseURL)
    }
    
    init(baseURL: URL,
         urlSession: URLSessionProtocol = URLSession(configuration: .default),
         dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    // MARK: - Public methods
    
    func get(endpoint: String, completionHandler: @escaping (Result<Any, APIClientError>) -> Void) {
        let fullPathURL = buildPathURL(endpoint: endpoint)
                        
        buildAndExecuteDataTask(url: fullPathURL, completionHandler: completionHandler)
    }
    
    // MARK: - Private methods
    
    private func buildPathURL(endpoint: String) -> URL {
        return baseURL.appendingPathComponent(endpoint)
    }
    
    private func buildAndExecuteDataTask(url: URL, completionHandler: @escaping (Result<Any, APIClientError>) -> Void) {
        let dataTask = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(.failure(.sessionError))
                }
                
                return
            }
            
            guard let data = data else {
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(.failure(.sessionError))
                }
                
                return
            }
            
            guard error == nil else {
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(.failure(.sessionError))
                }
                
                return
            }
            
            guard response.statusCode == 200 else {
                self.dispatchQueueWrapper.mainAsync {
                    completionHandler(.failure(.statusCodeError))
                }
                
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
                completionHandler(.failure(.malformedResponseError))

                return
            }
            
            self.dispatchQueueWrapper.mainAsync {
                completionHandler(.success(jsonResponse))
            }
        }
        
        dataTask.resume()
    }
}
