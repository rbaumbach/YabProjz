import XCTest
@testable import Weatherz

final class WeatherzTests: XCTestCase {
    var subject: WeatherModel!
    var testDate: Date!
    
    override func setUp() {
        super.setUp()
        
        testDate = Date()
    }
    
    func testWeatherModelProperties(){
        subject = WeatherModel(city: "West City",
                               region: "West Area",
                               country: "West Area",
                               lat: 0.0,
                               long: 1.1,
                               timestamp: testDate,
                               temperature: 90.0)
        
        XCTAssertEqual(subject.city, "West City")
        XCTAssertEqual(subject.region, "West Area")
        XCTAssertEqual(subject.country, "West Area")
        XCTAssertEqual(subject.lat, 0.0, accuracy: 0.1)
        XCTAssertEqual(subject.long, 1.1, accuracy: 0.1)
        XCTAssertEqual(subject.timestamp, testDate)
        XCTAssertEqual(subject.temperature, 90.0, accuracy: 0.1)
        
    }
}
