import XCTest
@testable import Weatherz

final class WeatherDetailViewModelTests: XCTestCase {
    var subject: WeatherDetailViewModel!
    
    var mockUserDefaults: MockUserDefaults!
    var mockFileManager: MockFileManager!
    var mockWeatherNetworkService: MockWeatherNetworkService!
    var mockDelegate: MockWeatherDetailViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        
        mockUserDefaults = MockUserDefaults()
        mockFileManager = MockFileManager()
        mockWeatherNetworkService = MockWeatherNetworkService()
        mockDelegate = MockWeatherDetailViewModelDelegate()
        
        subject = WeatherDetailViewModel(userDefaults: mockUserDefaults,
                                         fileManager: mockFileManager,
                                         weatherNetworkService: mockWeatherNetworkService)
        subject.delegate = mockDelegate
    }
    
    func testActivateOnSuccessWhenInCelsiusAndHasNotBeenPersisted() {
        subject.activate(city: "Hill Valley")
        
        let weatherModel = WeatherModel(city: "Hill Valley",
                                        region: "Cali",
                                        country: "USA",
                                        lat: 0.0,
                                        long: 1.1,
                                        timestamp: Date(),
                                        temperature: 30.0)
        
        XCTAssertEqual(mockWeatherNetworkService.capturedGetCurrentWeatherCity, "Hill Valley")
        
        mockUserDefaults.stubbedBool = true
        
        let success: Result<WeatherModel, Error> = .success(weatherModel)
        
        mockWeatherNetworkService.capturedGetCurrentWeatherCompletionHandler?(success)
        
        let actualModelPersisted = mockFileManager.capturedSaveToDocumentsDirData as! [WeatherModel]
        
        XCTAssertEqual(actualModelPersisted, [weatherModel])
        
        XCTAssertEqual(mockDelegate.capturedDidUpdateCity, "Hill Valley")
        XCTAssertEqual(mockDelegate.capturedDidUpateTemperature, "30.0")
    }
    
    func testActivateOnSuccessWhenInCelsiusAndHasBeenPersisted() {
        subject.activate(city: "Hill Valley")
        
        let weatherModel = WeatherModel(city: "Hill Valley",
                                        region: "Cali",
                                        country: "USA",
                                        lat: 0.0,
                                        long: 1.1,
                                        timestamp: Date(),
                                        temperature: 30.0)
        
        XCTAssertEqual(mockWeatherNetworkService.capturedGetCurrentWeatherCity, "Hill Valley")
        
        mockUserDefaults.stubbedBool = true
        
        let previouslyPersistedWeatherModel = WeatherModel(city: "Hilldale",
                                                           region: "Cali",
                                                           country: "USA",
                                                           lat: 2.0,
                                                           long: 3.0,
                                                           timestamp: Date(),
                                                           temperature: 100.0)
        
        mockFileManager.stubbedReadFromDocumentsDir = [previouslyPersistedWeatherModel]
        
        let success: Result<WeatherModel, Error> = .success(weatherModel)
        
        mockWeatherNetworkService.capturedGetCurrentWeatherCompletionHandler?(success)
        
        let actualModelPersisted = mockFileManager.capturedSaveToDocumentsDirData as! [WeatherModel]
        
        XCTAssertEqual(actualModelPersisted, [previouslyPersistedWeatherModel, weatherModel])
        
        XCTAssertEqual(mockDelegate.capturedDidUpdateCity, "Hill Valley")
        XCTAssertEqual(mockDelegate.capturedDidUpateTemperature, "30.0")
    }
    
    func testActivateOnSuccessWhenInFahrenheitAndHasNotBeenPersisted() {
        subject.activate(city: "Hill Valley")
        
        let weatherModel = WeatherModel(city: "Hill Valley",
                                        region: "Cali",
                                        country: "USA",
                                        lat: 0.0,
                                        long: 1.1,
                                        timestamp: Date(),
                                        temperature: 30.0)
        
        XCTAssertEqual(mockWeatherNetworkService.capturedGetCurrentWeatherCity, "Hill Valley")
                
        let success: Result<WeatherModel, Error> = .success(weatherModel)
        
        mockWeatherNetworkService.capturedGetCurrentWeatherCompletionHandler?(success)
        
        let actualModelPersisted = mockFileManager.capturedSaveToDocumentsDirData as! [WeatherModel]
        
        XCTAssertEqual(actualModelPersisted, [weatherModel])
        
        XCTAssertEqual(mockDelegate.capturedDidUpdateCity, "Hill Valley")
        XCTAssertEqual(mockDelegate.capturedDidUpateTemperature, "86.0")
    }
    
    func testActivateOnSuccessWhenInFahrenheitAndHasBeenPersisted() {
        subject.activate(city: "Hill Valley")
        
        let weatherModel = WeatherModel(city: "Hill Valley",
                                        region: "Cali",
                                        country: "USA",
                                        lat: 0.0,
                                        long: 1.1,
                                        timestamp: Date(),
                                        temperature: 30.0)
        
        XCTAssertEqual(mockWeatherNetworkService.capturedGetCurrentWeatherCity, "Hill Valley")
                
        let previouslyPersistedWeatherModel = WeatherModel(city: "Hilldale",
                                                           region: "Cali",
                                                           country: "USA",
                                                           lat: 2.0,
                                                           long: 3.0,
                                                           timestamp: Date(),
                                                           temperature: 100.0)
        
        mockFileManager.stubbedReadFromDocumentsDir = [previouslyPersistedWeatherModel]
        
        let success: Result<WeatherModel, Error> = .success(weatherModel)
        
        mockWeatherNetworkService.capturedGetCurrentWeatherCompletionHandler?(success)
        
        let actualModelPersisted = mockFileManager.capturedSaveToDocumentsDirData as! [WeatherModel]
        
        XCTAssertEqual(actualModelPersisted, [previouslyPersistedWeatherModel, weatherModel])
        
        XCTAssertEqual(mockDelegate.capturedDidUpdateCity, "Hill Valley")
        XCTAssertEqual(mockDelegate.capturedDidUpateTemperature, "86.0")
    }
    
    func testActivateOnFailure() {
        subject.activate(city: "Hill Valley")
        
        XCTAssertEqual(mockWeatherNetworkService.capturedGetCurrentWeatherCity, "Hill Valley")
        
        mockUserDefaults.stubbedBool = true
        
        let failure: Result<WeatherModel, Error> = .failure(MockError.whoCares)
        
        mockWeatherNetworkService.capturedGetCurrentWeatherCompletionHandler?(failure)
        
        XCTAssertEqual(mockDelegate.capturedDidError as! MockError, MockError.whoCares)
    }
}
