import Foundation

enum QuoteModelError: Error {
    case requestError
    case malformedResponseError
    case invalidStatusCodeError
    case dataNotFound
    case unableToParseJSONData
    case unableToDeserialize
}

struct Quote: Codable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "q"
    }
}

protocol QuoteModelProtocol {
    func fetchQuotes(completionHandler: @escaping (Result<[Quote], Error>) -> Void)
}

final class QuoteModel: QuoteModelProtocol {
    // MARK: - Constants
    
    private let apiURLString = "https://zenquotes.io/api/quotes/"
    
    // MARK: - Public methods
    
    func fetchQuotes(completionHandler: @escaping (Result<[Quote], Error>) -> Void) {
        let request = URLRequest(url: URL(string: apiURLString)!)
                
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            guard error == nil else {
                let result: Result<[Quote], Error> = Result.failure(QuoteModelError.requestError)

                DispatchQueue.main.async {
                    completionHandler(result)
                }

                return
            }

            guard let response = (response as? HTTPURLResponse) else {
                let result: Result<[Quote], Error> = Result.failure(QuoteModelError.malformedResponseError)

                DispatchQueue.main.async {
                    completionHandler(result)
                }

                return
            }

            guard (200...299).contains(response.statusCode) else {
                let result: Result<[Quote], Error> = Result.failure(QuoteModelError.invalidStatusCodeError)

                DispatchQueue.main.async {
                    completionHandler(result)
                }

                return
            }

            guard let data = data else {
                let result: Result<[Quote], Error> = .failure(QuoteModelError.dataNotFound)

                DispatchQueue.main.async {
                    completionHandler(result)
                }

                return
            }

            let result = self.decodeJSONResponseData(data)

            DispatchQueue.main.async {
                completionHandler(result)
            }
        }.resume()
    }
    
    // MARK: - Private methods
    
    private func deserializeJSONResponse(_ response: Any) -> Result<[Quote], Error> {
        guard let serializedJSONResponse = response as? [[String: String]] else {
            return .failure(QuoteModelError.unableToParseJSONData)
        }
        
        let quotes: [Quote] = serializedJSONResponse.map { serializedQuote in
            guard let content = serializedQuote["q"] else {
                return nil
            }
            
            return Quote(content: content)
        }.compactMap { $0 }

        // Since I think it's impossible to have no quotes at all, I'm going to simplify the error handling
        // by failing if this ever happens.
        
        guard !quotes.isEmpty else {
            return .failure(QuoteModelError.unableToDeserialize)
        }
        
        return .success(quotes)
    }
    
    private func decodeJSONResponseData(_ data: Data) -> Result<[Quote], Error> {
        do {
            let decodedData = try JSONDecoder().decode([Quote].self, from: data)
            
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
