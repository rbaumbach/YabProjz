@testable import Hyperloop

final class FakeImageNetworkService: ImageNetworkServiceProtocol {
    // MARK: - Captured properties
    
    var capturedSearchTerm: String?
    var capturedSortType: ImgurImageSortType?
    var capturedPage: Int?
    var capturedCompletionHander: ((Result<[ImgurImage], Error>) -> Void)?
    
    // Deprecated and no longer used
    
    func getImages(searchTerm: String,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void) { }
    
    func getImages(searchTerm: String,
                   sortType: ImgurImageSortType,
                   page: Int,
                   completionHandler: @escaping (Result<[ImgurImage], Error>) -> Void) {
        capturedSearchTerm = searchTerm
        capturedSortType = sortType
        capturedPage = page
        capturedCompletionHander = completionHandler
    }
}
