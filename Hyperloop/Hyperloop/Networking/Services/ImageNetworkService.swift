import Foundation

enum ImgurImageSortType: String {
    case time
    case viral
    case top
}

protocol ImageNetworkServiceProtocol {
    @available(*, deprecated, message: "Use getImages(searchTerm:sortType:page:completionHandler:) instead")
    func getImages(searchTerm: String,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void)
    
    func getImages(searchTerm: String,
                   sortType: ImgurImageSortType,
                   page: Int,
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
    
    @available(*, deprecated, message: "Use getImages(searchTerm:sortType:page:completionHandler:) instead")
    func getImages(searchTerm: String,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void) {
        apiClient.requestAndDeserialize(endpoint: basicEndpoint(),
                                        parameters: parameters(searchTerm: searchTerm),
                                        headers: headers()) { [weak self] (result: Result<ImgurResponse, Error>) in
            self?.requestHandler(result: result,
                                 completionHandler: completionHandler)
        }
    }
    
    func getImages(searchTerm: String,
                   sortType: ImgurImageSortType,
                   page: Int,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void) {
        let endpoint = endpoint(sortType: sortType,
                                  page: page)
                
        apiClient.requestAndDeserialize(endpoint: endpoint,
                                        parameters: parameters(searchTerm: searchTerm),
                                        headers: headers()) { [weak self] (result: Result<ImgurResponse, Error>) in
            self?.requestHandler(result: result,
                                 completionHandler: completionHandler)
        }
    }
    
    // MARK: - Private methods
    
    private func basicEndpoint() -> String {
        return "/3/gallery/search/"
    }
    
    private func endpoint(sortType: ImgurImageSortType,
                          page: Int) -> String {
        return "/3/gallery/search/\(sortType.rawValue)/page/\(page)/"
    }
    
    private func parameters(searchTerm: String) -> [String: String] {
        return ["q": searchTerm]
    }
    
    private func headers() -> [String: String] {
        return [Constants.Imgur.ClientIDKey: Constants.Imgur.ClientIDValue]
    }
    
    private func requestHandler(result: Result<ImgurResponse, Error>,
                                completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void) {
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
