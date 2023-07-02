import UIKit

final class ViewController: UIViewController, UITableViewDataSource {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Public properties
    
    var dataSource: [Quote] = []
    
    var quoteModel: QuoteModelProtocol = QuoteModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    // MARK: - <UITableViewDataSouce>
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = dataSource[indexPath.row].content
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func setup() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        quoteModel.fetchQuotes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let quotes):
                self.errorLabel.isHidden = true
                
                self.dataSource = quotes
                self.tableView.reloadData()
                self.tableView.isHidden = false
            case .failure(let error):
                self.dataSource = []
                self.tableView.reloadData()
                self.tableView.isHidden = true
                
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.isHidden = false
            }
        }
    }
}
