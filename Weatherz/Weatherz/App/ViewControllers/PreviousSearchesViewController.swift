import UIKit

final class PreviousSearchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Readonly properties
    
    var dataSource: [Location]!
    
    var userDefaults = UserDefaults.standard
    
    var fileManager = FileManager.default
    
    var viewControllerBuilder = ViewControllerBuilder()
    
    var temperatureConverter = TemperatureConverter()
    
    // MARK: - Private properties
    
    var isSortedInDescendingOrder = true
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    // MARK: - <UITableViewDataSource>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let location = dataSource[indexPath.row]
        
        var temperature = String(location.temperature)
        
        if !userDefaults.bool(forKey: Constants.UserDefaultKeys.ShouldShowWeatherInCelsiusKey) {
            let tempInFahrenheit = temperatureConverter.convertCelsiusToFahrenheit(temperature: location.temperature)
            
            temperature = String(tempInFahrenheit)
        }
        
        let displayText = "City: \(String(location.city)) - Weather: \(String(temperature)) @ \(String(location.timestamp.description))"
        
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = displayText
        
        return cell
    }
    
    // MARK: - <UITableViewDelegate>
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: PreviousWeatherDetailViewController = viewControllerBuilder.build(name: "PreviousWeatherDetailViewController")
        vc.location = dataSource[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    
    func sortBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if isSortedInDescendingOrder {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.SystemImageName.UpArrow)
            
            dataSource.sort { location1, location2 in
                return location1.timestamp > location2.timestamp
            }
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.SystemImageName.DownArrow)
            
            dataSource.sort { location1, location2 in
                return location1.timestamp < location2.timestamp
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
        
        setupDataSource()
        setupTableView()
    }
    
    private func setupDataSource() {
        let dataSourceFileName = Constants.FileManagerFileNames.PersistedLocationsFileName
        
        dataSource = fileManager.readFromDocumentsDir(fileName: dataSourceFileName)
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
