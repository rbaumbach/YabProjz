import Quick
import Nimble
@testable import Hyperloop

class ImageNetworkServiceSpec: QuickSpec {
    override class func spec() {
        describe("ImageNetworkService") {
            var subject: ImageNetworkService!
            var fakeAPIClient: FakeAPIClient!
            
            beforeEach {
                fakeAPIClient = FakeAPIClient()
                
                subject = ImageNetworkService(apiClient: fakeAPIClient)
            }
            
            describe("#getImages(searchTerm:sortType:page:completionHandler:)") {
                var capturedResult: Result<[ImgurImage], Error>!
                
                describe("on success") {
                    beforeEach {
                        subject.getImages(searchTerm: "Ro-bots",
                                          sortType: .time, page: 1) { result in
                            capturedResult = result
                        }
                        
                        let imgurItems = [ImgurItem(id: "0",
                                                    title: "Moe",
                                                    images: [ImgurImage(id: "0",
                                                                        description: "Image of Moe",
                                                                        mediaType: .image,
                                                                        url: nil)]),
                                          ImgurItem(id: "1",
                                                    title: "Larry",
                                                    images: [ImgurImage(id: "0",
                                                                        description: "Image of Larry",
                                                                        mediaType: .image,
                                                                        url: nil)]),
                                          ImgurItem(id: "1",
                                                    title: "Curly",
                                                    images: [ImgurImage(id: "0",
                                                                        description: "Video of Curly",
                                                                        mediaType: .video,
                                                                        url: nil)])]
                        let response = ImgurResponse(data: imgurItems)
                        
                        let typedCompletion = fakeAPIClient.capturedCompletionHandler as! (Result<ImgurResponse, Error>) -> Void
                                                
                        typedCompletion(.success(response))
                    }
                    
                    it("uses proper endpoint") {
                        expect(fakeAPIClient.capturedEndpoint).to(equal("/3/gallery/search/time/page/1/"))
                    }
                    
                    it("uses proper parameters") {
                        expect(fakeAPIClient.capturedParamters).to(equal(["q": "Ro-bots"]))
                    }
                    
                    it("users proper headers") {
                        expect(fakeAPIClient.capturedHeaders).to(equal([Constants.Imgur.ClientIDKey: Constants.Imgur.ClientIDValue]))
                    }
                    
                    it("processes the response to an array of imgur images") {
                        let images = try! capturedResult.get()
                        
                        expect(images.count).to(equal(2))
                        
                        // Note: Curly is filtered out because he has a video instead of an image
                        
                        let expectedImages = [ImgurImage(id: "0",
                                                         description: "Image of Moe",
                                                         mediaType: .image,
                                                         url: nil),
                                              ImgurImage(id: "0",
                                                         description: "Image of Larry",
                                                         mediaType: .image,
                                                         url: nil)]
                        
                        expect(images).to(equal(expectedImages))
                    }
                }
                
                describe("on failure") {
                    beforeEach {
                        subject.getImages(searchTerm: "Ro-bots",
                                          sortType: .time, page: 1) { result in
                            capturedResult = result
                        }
                        
                        let typedCompletion = fakeAPIClient.capturedCompletionHandler as! (Result<ImgurResponse, Error>) -> Void
                        
                        let failure: Result<ImgurResponse, Error> = .failure(FakeError.whoCares)
                                                
                        typedCompletion(failure)
                    }
                    
                    it("'bubbles' up the error") {
                        if case .failure(let error) = capturedResult {
                            expect(error as? FakeError).to(equal(FakeError.whoCares))
                        }
                    }
                }
            }
        }
    }
}
