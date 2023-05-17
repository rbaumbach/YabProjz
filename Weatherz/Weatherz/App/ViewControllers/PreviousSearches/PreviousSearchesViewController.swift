import UIKit

final class PreviousSearchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Readonly properties
    
    var dataSource: [WeatherModel]!
    
    var userDefaults = UserDefaults.standard
        
    var viewControllerBuilder = ViewControllerBuilder()
    
    var temperatureConverter = TemperatureConverter()
    
    // MARK: - Private properties
    
    var isSortedInDescendingOrder = true
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViewController()
    }
    
    // MARK: - UIViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviousSearchesAggregateViewControllerSegue" {
            guard let viewController = segue.destination as? PreviousSearchesAggregatesViewController else {
                return
            }
            
            viewController.dataSource = dataSource
        }
    }
    
    // MARK: - <UITableViewDataSource>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let weatherModel = dataSource[indexPath.row]
        
        var temperature = String(weatherModel.temperature)
        
        if !userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: weatherModel.temperature)
            
            temperature = String(tempInFahrenheit)
        }
        
        let displayText = "City: \(String(weatherModel.city)) - Weather: \(String(temperature)) @ \(String(weatherModel.timestamp.description))"
        
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = displayText
        
        return cell
    }
    
    // MARK: - <UITableViewDelegate>
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: PreviousWeatherDetailViewController = viewControllerBuilder.build(name: "PreviousWeatherDetailViewController")
        vc.weatherModel = dataSource[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    
    func sortBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if isSortedInDescendingOrder {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.SystemImageName.UpArrow)
            
            dataSource.sort { weatherModel1, weatherModel2 in
                return weatherModel1.timestamp > weatherModel2.timestamp
            }
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.SystemImageName.DownArrow)
            
            dataSource.sort { weatherModel1, weatherModel2 in
                return weatherModel1.timestamp < weatherModel2.timestamp
            }
        }
        
        isSortedInDescendingOrder = !isSortedInDescendingOrder
        
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupViewController() {
        if navigationController != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.SystemImageName.DownArrow),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(sortBarButtonItemTapped))
        }
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
