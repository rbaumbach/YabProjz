import Quick
import Nimble
import Capsule
@testable import Cuadrado

class APIClientSpec: QuickSpec {
    override func spec() {
        describe("APIClient") {
            var subject: APIClient!
            
            var fakeURLSession: FakeURLSession!
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!

            beforeEach {
                fakeURLSession = FakeURLSession(configuration: .default)
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
            }
            
            it("is built with default url session configuration") {
                expect(fakeURLSession.capturedInitConfiguration).to(equal(.default))
            }
            
            it("is built with constant baseURLString with empty init") {
                subject = APIClient()
                
                expect(subject.baseURL).to(equal(URL(string: "https://s3.amazonaws.com")!))
            }
            
            describe("#get(endpoint:completionHandler:)") {
                var capturedResult: Result<Any, APIClientError>!
                
                beforeEach {
                    subject = APIClient(baseURL: URL(string: "https://ryan.codes")!,
                                        urlSession: fakeURLSession,
                                        dispatchQueueWrapper: fakeDispatchQueueWrapper)
                }
                
                it("loads up the URLSession with the correct url") {
                    subject.get(endpoint: "/not-a-real-endpoint") { _ in }
                    
                    expect(fakeURLSession.capturedURL).to(equal(URL(string: "https://ryan.codes/not-a-real-endpoint")!))
                }
                
                describe("errors") {
                    describe("on invalid HTTPURLResponse") {
                        beforeEach {
                            subject.get(endpoint: "/not-a-real-endpoint") { result in
                                capturedResult = result
                            }
                            
                            let fakeData = Data("fakeData".utf8)
                            
                            fakeURLSession.capturedCompletionHandler?(fakeData, nil, nil)
                            fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler?()
                        }
                        
                        it("returns a result that has an sessionError on main queue") {
                            do {
                                _ = try capturedResult.get()
                            } catch {
                                expect(error).to(matchError(APIClientError.sessionError))
                            }
                            
                            expect(fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler).toNot(beNil())
                        }
                    }
                    
                    describe("on nil data") {
                        beforeEach {
                            subject.get(endpoint: "/not-a-real-endpoint") { result in
                                capturedResult = result
                            }
                            
                            let fakeHTTPURLResponse = HTTPURLResponse()
                            
                            fakeURLSession.capturedCompletionHandler?(nil, fakeHTTPURLResponse, nil)
                            fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler?()
                        }
                        
                        it("returns a result that has an sessionError") {
                            do {
                                _ = try capturedResult.get()
                            } catch {
                                expect(error).to(matchError(APIClientError.sessionError))
                            }
                            
                            expect(fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler).toNot(beNil())
                        }
                    }
                    
                    describe("on session error") {
                        beforeEach {
                            subject.get(endpoint: "/not-a-real-endpoint") { result in
                                capturedResult = result
                            }
                            
                            let fakeData = Data("fakeData".utf8)
                            let fakeHTTPURLResponse = HTTPURLResponse()
                            
                            fakeURLSession.capturedCompletionHandler?(fakeData, fakeHTTPURLResponse, FakeURLSessionError.whocares)
                            fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler?()
                        }
                        
                        it("returns a result that has an sessionError") {
                            do {
                                _ = try capturedResult.get()
                            } catch {
                                expect(error).to(matchError(APIClientError.sessionError))
                            }
                            
                            expect(fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler).toNot(beNil())
                        }
                    }

                    describe("on a non-200 status code") {
                        beforeEach {
                            subject.get(endpoint: "/not-a-real-endpoint") { result in
                                capturedResult = result
                            }
                            
                            let fakeData = Data("fakeData".utf8)
                            let fakeHTTPURLResponse = HTTPURLResponse(url: URL(string: "https://whocares.com")!, statusCode: 999, httpVersion: "1.1", headerFields: nil)
                            
                            fakeURLSession.capturedCompletionHandler?(fakeData, fakeHTTPURLResponse, nil)
                            fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler?()
                        }
                        
                        it("returns a result that has an statusErrorCode") {
                            do {
                                _ = try capturedResult.get()
                            } catch {
                                expect(error).to(matchError(APIClientError.statusCodeError))
                            }
                            
                            expect(fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler).toNot(beNil())
                        }
                    }
                    
                    describe("on a json response error") {
                        beforeEach {
                            subject.get(endpoint: "/not-a-real-endpoint") { result in
                                capturedResult = result
                            }
                            
                            let fakeData = Data("fakeData".utf8)
                            let fakeHTTPURLResponse = HTTPURLResponse(url: URL(string: "https://whocares.com")!, statusCode: 999, httpVersion: "1.1", headerFields: nil)
                            
                            fakeURLSession.capturedCompletionHandler?(fakeData, fakeHTTPURLResponse, nil)
                            fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler?()
                        }
                        
                        it("returns a result that has an statusErrorCode") {
                            do {
                                _ = try capturedResult.get()
                            } catch {
                                expect(error).to(matchError(APIClientError.statusCodeError))
                            }
                            
                            expect(fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler).toNot(beNil())
                        }
                    }
                }
                
                describe("on success") {
                    var capturedResult: Result<Any, APIClientError>!
                    
                    beforeEach {
                        subject.get(endpoint: "/not-a-real-endpoint") { result in
                            capturedResult = result
                        }
                        
                        let fakeData = createData(dict: ["yay": "sir"])
                        let fakeHTTPURLResponse = HTTPURLResponse(url: URL(string: "https://whocares.com")!,
                                                                  statusCode: 200,
                                                                  httpVersion: "1.1",
                                                                  headerFields: nil)
                        
                        fakeURLSession.capturedCompletionHandler?(fakeData, fakeHTTPURLResponse, nil)
                        fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler?()
                    }
                    
                    it("returns a result with a json response (dictionary) on the main queue") {
                        do {
                            let jsonResponse = try capturedResult.get() as! [String: String]

                            expect(jsonResponse).to(equal(["yay": "sir"]))
                        } catch {
                            XCTFail("Your jsonResponse success case is failing")
                        }
                        
                        expect(fakeDispatchQueueWrapper.capturedMainAsyncCompletionHandler).toNot(beNil())
                    }
                }
            }
        }
    }
}

