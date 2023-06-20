import Foundation

protocol ImageNetworkServiceProtocol {
    func getImages(searchTerm: String,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void)
}

final class ImageNetworkService: ImageNetworkServiceProtocol {
    // MARK: - Private methods
    
    private let apiClient: APIClientProtocol
    
    // MARK: - Init methods
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func getImages(searchTerm: String,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void) {
        apiClient.requestAndDeserialize(endpoint: endpoint(),
                                        parameters: parameters(searchTerm: searchTerm),
                                        headers: headers()) { [weak self] (result: Result<ImgurResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let images = self.processResponse(response)
                
                let success: Result<[ImgurImage], Error> = .success(images)
                
                completionHandler(success)
            case .failure(let error):
                let failure: Result<[ImgurImage], Error> = .failure(error)
                
                completionHandler(failure)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func endpoint() -> String {
        return "/3/gallery/search/"
    }
    
    private func parameters(searchTerm: String) -> [String: String] {
        return ["q": searchTerm]
    }
    
    private func headers() -> [String: String] {
        return [Constants.Imgur.ClientIDKey: Constants.Imgur.ClientIDValue]
    }
    
    private func processResponse(_ response: ImgurResponse) -> [ImgurImage] {
        let images = response.data.map { imgurItem in
            return imgurItem.images
        }.flatMap { imgurImage in
            return imgurImage
        }.filter { imgurImage in
            return imgurImage.mediaType == .image
        }
 
        return images
    }
}
