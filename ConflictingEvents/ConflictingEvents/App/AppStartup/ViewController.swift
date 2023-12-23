import UIKit

final class ViewController: UIViewController, UITableViewDataSource {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Readonly properties
    
    var eventDataSource: EventDataSourceProtocol = EventDataSource()
    
    var dataSource: [DateEvents] = []
        
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - <UITableViewDataSource>
    
    func numberOfSections(in tableView: UITableView) -> Int { 
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].events.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "-- \(dataSource[section].dateKey) --"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = dataSource[indexPath.section].events[indexPath.row]

        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.name,
                                                          for: indexPath) as! EventTableViewCell
        tableViewCell.selectionStyle = .none

        tableViewCell.update(title: event.title,
                             startDate: event.startTimeOnlyString,
                             endDate: event.endTimeOnlyString,
                             hasConflict: event.hasConflict)
        
        return tableViewCell
    }
    
    // MARK: - Private methods
    
    private func setup() {
        dataSource = eventDataSource.build()
        
        let eventTableViewCellNib = UINib(nibName: EventTableViewCell.name,
                                          bundle: nil)
        
        tableView.register(eventTableViewCellNib,
                           forCellReuseIdentifier: EventTableViewCell.name)
    }
}
