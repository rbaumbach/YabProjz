import XCTest
@testable import Weatherz

final class PreviousWeatherDetailViewControllerTests: XCTestCase {
    var subject: PreviousWeatherDetailViewController!
    
    var mockUserDefaults: MockUserDefaults!
    var date: Date!
    var weatherModel: WeatherModel!
    
    override func setUp() {
        super.setUp()
        
        mockUserDefaults = MockUserDefaults()
        
        date = Date()
        
        weatherModel = WeatherModel(city: "New York",
                                    region: "New York",
                                    country: "USA",
                                    lat: 9.9,
                                    long: 10.9,
                                    timestamp: date,
                                    temperature: 33.0)
        
        subject = ViewControllerBuilder().build(name: "PreviousWeatherDetailViewController")
        subject.userDefaults = mockUserDefaults
        subject.weatherModel = weatherModel
    }
    
    func testsViewLoadsInCelsius() {
        mockUserDefaults.stubbedBool = true
        
        _ = subject.view
        
        XCTAssertEqual(subject.cityLabel.text, "New York")
        
        XCTAssertEqual(subject.degreesLabel.text, "33.0")
        XCTAssertEqual(subject.timestampLabel.text, date.description)
    }
    
    func testViewLoadsInFahrenheit() {
        _ = subject.view
        
        XCTAssertEqual(subject.cityLabel.text, "New York")
        
        XCTAssertEqual(subject.degreesLabel.text, "91.4")
        XCTAssertEqual(subject.timestampLabel.text, date.description)
    }
}
