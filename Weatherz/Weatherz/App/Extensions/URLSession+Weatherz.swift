import Foundation

protocol URLSessionProtocol {    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let dataTask: URLSessionDataTask = dataTask(with: request,
                                                    completionHandler: completionHandler)
        
        return dataTask
    }
}
