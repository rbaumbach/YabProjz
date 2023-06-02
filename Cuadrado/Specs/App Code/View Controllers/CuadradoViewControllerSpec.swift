import Quick
import Nimble
@testable import Cuadrado

class CuadradoViewControllerSpec: QuickSpec {
    override func spec() {
        describe("CuadradoViewController") {
            var subject: CuadradoViewController!
            
            var fakeDeserializer: FakeEmployeeDeserializer!
            var fakeEmployeesResult: Result<[Employee], APIClientError>!
            var fakeSDWebImageWrapper: FakeSDWebImageWrapper!

            beforeEach {
                subject = loadStoryboard(name: "CuadradoViewController")
                
                fakeSDWebImageWrapper = FakeSDWebImageWrapper()
                
                subject.sdWebImageWrapper = fakeSDWebImageWrapper
                
                // Easy access to some generated employees
                
                fakeDeserializer = FakeEmployeeDeserializer()
            }
            
            describe("when employees result fetch has successfully retrieved employee array") {
                describe("when there are no employees") {
                    beforeEach {
                        fakeEmployeesResult = .success([])
                        
                        subject.employeesResult = fakeEmployeesResult
                        
                        _ = subject.view
                    }

                    it("it displays proper message") {
                        expect(subject.basicStatusLabel.text).to(equal("There are no employees"))
                        expect(subject.basicStatusLabel.isHidden).to(beFalsy())
                    }
                    
                    it("it doesn't show separator lines because there is an empty footer view") {
                        expect(subject.tableView.tableFooterView).toNot(beNil())
                    }
                }
                
                describe("when there is at least one employee") {
                    beforeEach {
                        fakeEmployeesResult = .success(fakeDeserializer.stubbedEmployees)
                        
                        subject.employeesResult = fakeEmployeesResult
                        
                        _ = subject.view
                    }
                    
                    it("loads up the data source") {
                        expect(subject.dataSource).to(equal(fakeDeserializer.stubbedEmployees))
                    }
                }
            }
            
            describe("when employees result fetch has failed") {
                beforeEach {
                    fakeEmployeesResult = .failure(.sessionError)
                    
                    subject.employeesResult = fakeEmployeesResult
                    
                    _ = subject.view
                }
                
                it("displays proper error message") {
                    let expectedErrorMessage = "Error: Unable to fetch employees"
                    
                    expect(subject.basicStatusLabel.isHidden).to(beFalsy())
                    expect(subject.basicStatusLabel.text).to(equal(expectedErrorMessage))
                }
            }
            
            describe("<UITableViewDataSource>") {
                beforeEach {
                    fakeEmployeesResult = .success(fakeDeserializer.stubbedEmployees)
                    
                    subject.employeesResult = fakeEmployeesResult
                    
                    _ = subject.view
                }
                
                describe("#numberOfSections(in:)") {
                    var numberOfSections: Int!
                    
                    beforeEach {
                        numberOfSections = subject.numberOfSections(in: subject.tableView)
                    }
                    
                    it("is always 1") {
                        expect(numberOfSections).to(equal(1))
                    }
                }
                
                describe("#tableView(_:numberOfRowsInSection:)") {
                    var numberOfRows: Int!
                    
                    beforeEach {
                        numberOfRows = subject.tableView(subject.tableView, numberOfRowsInSection: 0)
                    }
                    
                    it("returns the same number of rows that are in the data source") {
                        expect(numberOfRows).to(equal(subject.dataSource.count))
                    }
                }
                                
                describe("#tableView(_:cellForRowAt:)") {
                    var employeeTableViewCell: EmployeeTableViewCell!
                    
                    describe("when a user has a profile photo") {
                        beforeEach {
                            let employee = Employee(id: "123",
                                                    fullname: "Billy Goat",
                                                    phoneNumber: "333-333-3333",
                                                    email: "billy@goat.com",
                                                    biography: "Just an ordinary billy goat",
                                                    smallPhotoURL: URL(string: "https://not.a.real.photo.com/99")!,
                                                    largePhotoURL: nil,
                                                    team: "horns",
                                                    type: .fullTime)
                            
                            subject.dataSource = [employee]
                            
                            employeeTableViewCell = (subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! EmployeeTableViewCell)
                        }
                        
                        it("attempts to fetch the profile photo") {
                            expect(fakeSDWebImageWrapper.capturedGetImageURL).to(equal(URL(string: "https://not.a.real.photo.com/99")!))
                        }
                        
                        describe("when image fetch is successful") {
                            var bogusImage: UIImage!
                            
                            beforeEach {
                                bogusImage = UIImage()
                                
                                fakeSDWebImageWrapper.capturedGetImageCompletionHandler?(bogusImage)
                            }
                            
                            it("updates the profile image view image with the fetched image") {
                                expect(employeeTableViewCell.profilePhotoImageView.image).to(equal(bogusImage))
                            }
                        }
                        
                        describe("when image fetch fails") {
                            beforeEach {
                                fakeSDWebImageWrapper.capturedGetImageCompletionHandler?(nil)
                            }
                            
                            it("does nothing") {
                                expect(employeeTableViewCell.profilePhotoImageView.image).toNot(beNil())
                            }
                        }
                    }
                    
                    describe("when a user DOES NOT have a profile photo") {
                        beforeEach {
                            subject.dataSource = fakeDeserializer.stubbedEmployees
                            
                            employeeTableViewCell = (subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! EmployeeTableViewCell)
                        }
                        
                        it("returns a fully loaded employee table view cell") {
                            expect(employeeTableViewCell.fullnameLabel.text).to(equal("Billy Goat"))
                            expect(employeeTableViewCell.imageView).toNot(beNil())
                            expect(employeeTableViewCell.emailLabel.text).to(equal("billy@goat.com"))
                            expect(employeeTableViewCell.teamLabel.text).to(equal("horns"))
                            expect(employeeTableViewCell.typeLabel.text).to(equal("Full Time"))
                            expect(employeeTableViewCell.phoneNumberLabel.text).to(equal("333-333-3333"))
                            expect(employeeTableViewCell.biographyLabel.text).to(equal("Just an ordinary billy goat"))
                        }
                    }
                }
            }
        }
    }
}
