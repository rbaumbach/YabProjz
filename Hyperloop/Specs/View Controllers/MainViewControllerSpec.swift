import Quick
import Nimble
import Utensils
@testable import Hyperloop

class MainViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("MainViewController") {
            var subject: MainViewController!
            var fakeImageNetworkService: FakeImageNetworkService!
            var fakeViewControllerBuilder: FakeViewControllerBuilder!
            var fakeDebouncer: FakeDebouncer!
            
            beforeEach {
                fakeImageNetworkService = FakeImageNetworkService()
                fakeViewControllerBuilder = FakeViewControllerBuilder()
                fakeDebouncer = FakeDebouncer()
                
                let navController = ViewControllerBuilder().build(name: "MainViewController") as! UINavigationController

                subject = (navController.topViewController as! MainViewController)
                subject.imageNetworkService = fakeImageNetworkService
                subject.viewControllerBuilder = fakeViewControllerBuilder
                subject.debouncer = fakeDebouncer
            }
            
            it("has an empty dataSource") {
                expect(subject.dataSource).to(beEmpty())
            }
            
            describe("when the view loads") {
                beforeEach {
                    _ = subject.view
                }
                
                it("has correct title") {
                    expect(subject.title).to(equal(Constants.App.mainTitle))
                }
                
                it("has a properly configured search controller") {
                    expect(subject.searchController.searchResultsUpdater === subject).to(beTruthy())
                    expect(subject.searchController.hidesNavigationBarDuringPresentation).to(beFalsy())
                    expect(subject.searchController.searchBar.placeholder).to(equal(Constants.App.defaultSearchTerm))
                    expect(subject.navigationItem.searchController === subject.searchController).to(beTruthy())
                }
                
                it("attempts to fetch images with the default search term for 1st page") {
                    expect(fakeImageNetworkService.capturedSearchTerm).to(equal(Constants.App.defaultSearchTerm))
                    expect(fakeImageNetworkService.capturedSortType).to(equal(.time))
                    expect(fakeImageNetworkService.capturedPage).to(equal(1))
                    expect(fakeImageNetworkService.capturedCompletionHander).toNot(beNil())
                }
                
                describe("when attempting to fetch the images") {
                    describe("on image fetch success") {
                        var result: Result<[ImgurImage], Error>!
                        
                        describe("when images are fetched") {
                            var images: [ImgurImage]!

                            beforeEach {
                                images = [ImgurImage(id: "2",
                                                         description: "Dos",
                                                         mediaType: .image,
                                                         url: nil)]
                                
                                result = .success(images)
                                
                                fakeImageNetworkService.capturedCompletionHander?(result)
                            }
                            
                            it("updates the dataSource") {
                                expect(subject.dataSource).to(equal(images))
                            }
                            
                            it("hides the error") {
                                expect(subject.errorLabel.isHidden).to(beTruthy())
                                expect(subject.tableView.isHidden).to(beFalsy())
                            }
                        }
                        
                        describe("when no images are fetched") {
                            beforeEach {
                                result = .success([])
                                
                                fakeImageNetworkService.capturedCompletionHander?(result)
                            }
                            
                            it("updates the dataSource") {
                                expect(subject.dataSource).to(equal([]))
                            }
                            
                            it("shows the error") {
                                expect(subject.errorLabel.text).to(equal("Unable to find images for: Chihuahua"))
                                expect(subject.errorLabel.isHidden).to(beFalsy())
                                expect(subject.tableView.isHidden).to(beTruthy())
                            }
                        }
                    }
                    
                    describe("on image fetch failure") {
                        beforeEach {
                            let result: Result<[ImgurImage], Error> = .failure(FakeError.whoCares)
                            
                            fakeImageNetworkService.capturedCompletionHander?(result)
                        }
                        
                        it("empties out the dataSource") {
                            expect(subject.dataSource).to(beEmpty())
                        }
                        
                        it("shows the error") {
                            expect(subject.errorLabel.text).to(equal("Error: whoCares"))
                            expect(subject.errorLabel.isHidden).to(beFalsy())
                            expect(subject.tableView.isHidden).to(beTruthy())
                        }
                    }
                }
                
                describe("<UITableViewDataSource>") {
                    beforeEach {
                        // Give the subject a dataSource so that #tableView(_:cellForRowAt:)
                        // can be tested
                        
                        subject.dataSource = [ImgurImage(id: "1",
                                                         description: "Image-1",
                                                         mediaType: .image,
                                                         url: nil)]
                    }
                    describe("#numberOfSections(in:)") {
                        var numberOfSections: Int!
                        
                        beforeEach {
                            numberOfSections = subject.numberOfSections(in: subject.tableView)
                        }
                        
                        it("always returns 1") {
                            expect(numberOfSections).to(equal(1))
                        }
                    }
                    
                    describe("#tableView(_:numberOfRowsInSection)") {
                        var numberOfSections: Int!
                        
                        beforeEach {
                            numberOfSections = subject.tableView(subject.tableView, numberOfRowsInSection: 0)
                        }
                        
                        it("returns the total amount of items in the dataSource") {
                            expect(subject.dataSource.count).to(equal(numberOfSections))
                        }
                    }
                    
                    describe("#tableView(_:cellForRowAt:)") {
                        var cell: ImgurImageTableViewCell!

                        beforeEach {
                            cell = (subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ImgurImageTableViewCell)
                        }
                        
                        it("returns a cell that is properly configured") {
                            expect(cell.imgurImageView).toNot(beNil())
                            expect(cell.descriptionLabel.text).to(equal("Image-1"))
                            expect(cell.selectionStyle).to(equal(UITableViewCell.SelectionStyle.none))
                        }

                        it("exists") {
                            expect(cell).toNot(beNil())
                        }
                    }
                }
                
                describe("<UITableViewDelegate>") {
                    describe("#tableView(_:heightForRowAt:)") {
                        var rowHeight: CGFloat!
                        
                        beforeEach {
                            rowHeight = subject.tableView(subject.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
                        }
                        
                        it("always returns the mainTableViewHeight") {
                            expect(rowHeight).to(beCloseTo(Constants.App.mainTableViewCellHeight))
                        }
                    }
                    
                    describe("#tableView(_:didSelectRowAt:)") {
                        // These tests require some additions to the MainViewController to keep a reference to the
                        // DetailViewController.  This will be done at a later time.
                    }
                }
            }
        }
    }
}
