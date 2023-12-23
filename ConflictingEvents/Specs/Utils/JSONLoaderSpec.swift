import Quick
import Moocher
@testable import ConflictingEvents

final class JSONLoaderSpec: QuickSpec {
    override class func spec() {
        describe("JSONLoader") {
            var subject: JSONLoader!
            
            var fakeBundle: FakeBundle!
            var fakeStringFileLoader: FakeStringFileLoader!
            var fakeJSONDecoder: FakeJSONDecoder!
            
            beforeEach {
                fakeBundle = FakeBundle()
                fakeStringFileLoader = FakeStringFileLoader()
                fakeJSONDecoder = FakeJSONDecoder()
                
                subject = JSONLoader(bundle: fakeBundle,
                                     stringFileLoader: fakeStringFileLoader,
                                     jsonDecoder: fakeJSONDecoder)
            }
            
            describe("#buildEvents()") {
                var events: [Event]!
                
                describe("when the json file path cannot be loaded") {
                    beforeEach {
                        fakeBundle.stubbedPath = nil
                        
                        events = subject.buildEvents()
                    }
                    
                    it("doesn't return any events") {
                        expect(fakeBundle.capturedPathForResource).to.equal("mock")
                        expect(fakeBundle.capturedPathOfType).to.equal("json")
                        
                        expect(events).to.beEmpty()
                    }
                }
                
                describe("when the json data cannot be loaded") {
                    beforeEach {
                        fakeStringFileLoader.shouldThrowErrorLoadingData = true
                        
                        events = subject.buildEvents()
                    }
                    
                    it("doesn't return any events") {
                        expect(fakeStringFileLoader.capturedLoadDataPath).to.equal(fakeBundle.stubbedPath)
                        expect(fakeBundle.capturedPathForResource).to.equal("mock")
                        expect(fakeBundle.capturedPathOfType).to.equal("json")
                        
                        expect(events).to.beEmpty()
                    }
                }
                
                describe("when the json data cannot be decoded") {
                    beforeEach {
                        fakeJSONDecoder.shouldThrowErrorDecoding = true
                        
                        events = subject.buildEvents()
                    }
                    
                    it("doesn't return any events") {
                        expect(fakeStringFileLoader.capturedLoadDataPath).to.equal(fakeBundle.stubbedPath)
                        expect(fakeJSONDecoder.capturedDecodeFromData).to.equal(fakeStringFileLoader.stubbedLoadData)
                        expect(fakeBundle.capturedPathForResource).to.equal("mock")
                        expect(fakeBundle.capturedPathOfType).to.equal("json")
                        
                        expect(events).to.beEmpty()
                    }
                }
                
                describe("when everything is great...") {
                    beforeEach {
                        fakeJSONDecoder.stubbedDecodedItem = [Event(title: "",
                                                                    startDate: Date(),
                                                                    startJSONDateString: "",
                                                                    startTimeOnlyString: "",
                                                                    startDateOnlyString: "",
                                                                    endDate: Date(),
                                                                    endDateJSONString: "",
                                                                    endTimeOnlyString: "")]
                        
                        events = subject.buildEvents()
                    }
                    
                    it("returns events") {
                        expect(fakeStringFileLoader.capturedLoadDataPath).to.equal(fakeBundle.stubbedPath)
                        expect(fakeJSONDecoder.capturedDecodeFromData).to.equal(fakeStringFileLoader.stubbedLoadData)
                        expect(fakeBundle.capturedPathForResource).to.equal("mock")
                        expect(fakeBundle.capturedPathOfType).to.equal("json")
                        
                        expect(events).toNot.beEmpty()
                    }
                }
            }
        }
    }
}
