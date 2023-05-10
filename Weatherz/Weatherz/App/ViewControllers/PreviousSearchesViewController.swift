import UIKit

final class PreviousSearchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Readonly properties
    
    var dataSource: [Location]!
    
    var fileManager = FileManager.default
    
    var viewControllerBuilder = ViewControllerBuilder()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        
        setupTableView()
    }
    
    // MARK: - <UITableViewDataSource>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let location = dataSource[indexPath.row]
        
        let displayText = "City: \(String(location.city)) - Weather: \(String(location.temperature)) @ \(String(location.timestamp.description))"
        
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
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        let dataSourceFileName = Constants.FileManagerFileNames.PersistedLocationsFileName
        
        dataSource = fileManager.readFromDocumentsDir(fileName: dataSourceFileName)
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
