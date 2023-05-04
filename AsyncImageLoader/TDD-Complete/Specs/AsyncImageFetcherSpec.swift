import Quick
import Nimble
import Capsule

@testable import AsyncImageFetcherDemo

class AsyncImageFetcherSpec: QuickSpec {
    override func spec() {
        describe("AsyncImageFetcher") {
            var subject: AsyncImageFetcher!
            
            var anImageViewImageCache: NSCache<NSString, UIImage>!
            
            var fakeUUID: FakeUUID!
            var fakeURLSession: FakeURLSession!
            
            beforeEach {
                anImageViewImageCache = NSCache<NSString, UIImage>()
                fakeUUID = FakeUUID()
                fakeURLSession = FakeURLSession(configuration: .default)
                
                subject = AsyncImageFetcher(imageViewImageCache: anImageViewImageCache,
                                            uuid: fakeUUID,
                                            urlSession: fakeURLSession)
            }
            
            describe("fetch(imageURLString:completionHandler:)") {
                var imageFetchUUID: String!
                var capturedImage: UIImage!
                
                describe("when the image url string is nil") {
                    beforeEach {
                        imageFetchUUID = subject.fetch(imageURLString: nil) { image in
                            capturedImage = image
                        }
                    }
                    
                    it("returns a nil imageFetchUUID") {
                        expect(imageFetchUUID).to(beNil())
                    }
                    
                    it("completes without an image") {
                        expect(capturedImage).to(beNil())
                    }
                }
                
                describe("when the image url string is not a legit url") {
                    beforeEach {
                        imageFetchUUID = subject.fetch(imageURLString: "$$Fi:/    /fakey-wakey") { image in
                            capturedImage = image
                        }
                    }
                    
                    it("returns a nil imageFetchUUID") {
                        expect(imageFetchUUID).to(beNil())
                    }
                    
                    it("completes without an image") {
                        expect(capturedImage).to(beNil())
                    }
                }
                
                describe("when the image has already been downloaded and is cached") {
                    var justAnImage: UIImage!
                    
                    beforeEach {
                        justAnImage = UIImage()
                        
                        anImageViewImageCache.setObject(justAnImage, forKey: "http://it-dont-matter" as NSString)
                        
                        imageFetchUUID = subject.fetch(imageURLString: "http://it-dont-matter") { image in
                            capturedImage = image
                        }
                    }
                    
                    it("returns a nil imageFetchUUID") {
                        expect(imageFetchUUID).to(beNil())
                    }
                    
                    it("completes with the cached image") {
                        expect(capturedImage).to(equal(justAnImage))
                    }
                }
                
                describe("when everything is all good and we can attempt to fetch an image") {
                    beforeEach {
                        imageFetchUUID = subject.fetch(imageURLString: "http://anImage.png") { image in
                            capturedImage = image
                        }
                    }
                    
                    it("returns a imageFetchUUID") {
                        expect(imageFetchUUID).to(equal("uuid-amigos-012345"))
                    }
                    
                    it("adds the image fetch data task to the inProgress dictionary") {
                        expect(subject.inProgressImageDataTasks["uuid-amigos-012345"]).to(equal(fakeURLSession.stubbedDataTask))
                    }
                    
                    describe("on completion of fetching an image") {
                        describe("when the data task was cancelled (NSURLErrorCancelled Error)") {
                            beforeEach {
                                let fakeError = NSError(domain: "fake-domain", code: NSURLErrorCancelled, userInfo: nil)
                                
                                fakeURLSession.capturedCompletionHandler?(nil, nil, fakeError)
                            }
                            
                            it("completes without an image") {
                                expect(capturedImage).to(beNil())
                            }
                            
                            it("removes the data task from the inProgress dictionary") {
                                expect(subject.inProgressImageDataTasks).to(beEmpty())
                            }
                        }
                        
                        describe("when there is no image data") {
                            beforeEach {
                                fakeURLSession.capturedCompletionHandler?(nil, nil, nil)
                            }
                            
                            it("completes without an image") {
                                expect(capturedImage).to(beNil())
                            }
                            
                            it("removes the data task from the inProgress dictionary") {
                                expect(subject.inProgressImageDataTasks).to(beEmpty())
                            }
                        }
                        
                        describe("when there is any other error") {
                            beforeEach {
                                let fakeError = NSError(domain: "fake-domain", code: 100, userInfo: nil)
                                
                                fakeURLSession.capturedCompletionHandler?(nil, nil, fakeError)
                            }
                            
                            it("completes without an image") {
                                expect(capturedImage).to(beNil())
                            }
                            
                            it("removes the data task from the inProgress dictionary") {
                                expect(subject.inProgressImageDataTasks).to(beEmpty())
                            }
                        }
                        
                        describe("when the image data is bogus") {
                            beforeEach {
                                let data = "burritos".data(using: .utf8)!
                                
                                fakeURLSession.capturedCompletionHandler?(data, nil, nil)
                            }
                            
                            it("completes without an image") {
                                expect(capturedImage).to(beNil())
                            }
                            
                            it("removes the data task from the inProgress dictionary") {
                                expect(subject.inProgressImageDataTasks).to(beEmpty())
                            }
                        }
                        
                        describe("when everything is good") {
                            beforeEach {
                                let bundle = Bundle.init(for: type(of: self))
                                let image = UIImage(named: "la-costa-burrito.jpg", in: bundle, compatibleWith: nil)!
                                let data = image.jpegData(compressionQuality: 1.0)!
                                
                                
                                fakeURLSession.capturedCompletionHandler?(data, nil, nil)
                            }
                            
                            it("adds the image to the image cache") {
                                let cachedImage = anImageViewImageCache.object(forKey: "http://anImage.png" as NSString)
                                
                                expect(cachedImage).toNot(beNil())
                            }
                            
                            it("removes the data task from the inProgress dictionary") {
                                expect(subject.inProgressImageDataTasks).to(beEmpty())
                            }
                            
                            it("completes with the fetched image") {
                                expect(capturedImage).toNot(beNil())
                            }
                        }
                    }
                }
            }
            
            describe("cancel(imageFetchUUID:)") {
                beforeEach {
                    anImageViewImageCache.setObject(UIImage(), forKey: "http://it-dont-matter" as NSString)
                }
                
                it("removes the data task from the inProgress dictionary") {
                    expect(subject.inProgressImageDataTasks).to(beEmpty())
                }
            }
        }
    }
}
