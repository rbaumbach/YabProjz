import XCTest
@testable import Weatherz

final class TemperatureViewTests: XCTestCase {
    var subject: TemperatureView!
    
    override func setUp() {
        super.setUp()
        
        subject = TemperatureView(frame: CGRect.zero)
    }
    
    func testLabels() {
        XCTAssertTrue(subject.cityLabel.isHidden)
        XCTAssertTrue(subject.weatherLabel.isHidden)
        XCTAssertTrue(subject.degreesLabel.isHidden)
        
        XCTAssertEqual(subject.cityLabel.text, "city")
        XCTAssertEqual(subject.weatherLabel.text, "Weather Temp")
        XCTAssertEqual(subject.degreesLabel.text, "71")
    }
}
    
