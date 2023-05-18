import UIKit

final class PreviousSearchesAggregatesViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var totalSearchCountLabel: UILabel!
    @IBOutlet weak var mostSearchedCityLabel: UILabel!
    @IBOutlet weak var totalFreezingCitiesLabel: UILabel!
    @IBOutlet weak var firstCityNamedAsNumberLabel: UILabel!
    
    // MARK: - Public properties
    
    var dataSource: [WeatherModel] = []
    
    var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        
        return numberFormatter
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupView()
    }
    
    // MARK: - IBActions
    
    // Note: This is just here to use the "Exit" functionality in the Storyboard
    
    @IBAction func unwindMyself(sender: UIStoryboardSegue) { }
    
    // MARK: - Private methods
    
    private func setupView() {
        totalSearchCountLabel.text = String(dataSource.count)
        
        mostSearchedCityLabel.text = mostSearchedCity()
        totalFreezingCitiesLabel.text = totalFreezingCities()
        firstCityNamedAsNumberLabel.text = firstCityNamedAsNumber()
    }
    
    private func mostSearchedCity() -> String {
        let cityTotals = dataSource.reduce(into: [:]) { previousResult, weatherModel in
            previousResult[weatherModel.city, default: 0] += 1
        }
        
        let mostSearchedCity = cityTotals.max { pair1, pair2 in
            return pair1 < pair2
        }
        
        return mostSearchedCity?.key ?? "N/A"
    }
    
    private func totalFreezingCities() -> String {
        let freezingCities = dataSource.filter { weatherModel in
            return weatherModel.temperature <= 0.0
        }
        
        return String(freezingCities.count)
    }
    
    private func firstCityNamedAsNumber() -> String {        
        let numberCities = dataSource.compactMap { weatherModel in
            // Note: For the formatter to work, the string must be lowercased, and have dashes and not spaces
            // ex: "Eighty Four" -> "eighty-four"
            
            let processedString = weatherModel.city.lowercased().replacingOccurrences(of: " ", with: "-")
                        
            return numberFormatter.number(from: processedString)
        }
        
        guard let firstCity = numberCities.first else {
            return "N/A"
        }
        
        // Now we put the string back
        
        if let firstCityString = numberFormatter.string(from: firstCity) {
            let reprocessedString = firstCityString.replacingOccurrences(of: "-", with: " ").capitalized
            
            return reprocessedString
        } else {
            return "N/A"
        }
    }
}
