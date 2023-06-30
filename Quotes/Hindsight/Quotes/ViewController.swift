import UIKit

struct Quote {
    let content: String
}

class ViewController: UIViewController, UITableViewDataSource {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
//    var dataSource = ["uno", "dos", "tres"]

    var dataSource: [Quote] = []
    
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
        
        cell.textLabel?.text = dataSource[indexPath.row].content
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func setup() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        fetchQuotes()
    }
    
    private func fetchQuotes() {
        let urlString = "https://zenquotes.io/api/quotes/"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // In an exercise with more time I'd check for error and check for response == 200
            // and use a Result type with the final array of Quotes or an Error type to be
            // consumable.
            
            guard let data = data else {
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data,
                                                                       options: JSONSerialization.ReadingOptions.mutableContainers)
            else {
                return
            }
            
            let deserializedQuotes = self?.deserializeJSONResponse(jsonResponse) ?? []
            
            print(deserializedQuotes)
            
            DispatchQueue.main.async {
                self?.dataSource = deserializedQuotes
                
                self?.tableView.reloadData()
            }
        }.resume()
    }
    
    private func deserializeJSONResponse(_ response: Any) -> [Quote] {
        guard let serializedJSONResponse = response as? [[String: Any]] else {
                    return []
                }
                
        var quotes: [Quote] = []
        
        serializedJSONResponse.forEach { serializedQuote in
            let typedSerializedQuote = serializedQuote as! [String: String]
            
            let quote = Quote(content: typedSerializedQuote["q"]!)
            
            quotes.append(quote)
        }
        
        return quotes
    }
}
