import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    var imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService()
    
    var dataSource: [ImgurImage] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - <UITableViewDataSource>
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row].url?.absoluteString
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        setupTableView()
        
        fetchImages()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func fetchImages() {
        imageNetworkService.getImages(searchTerm: "Chihuahua") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imgurImages):
                self.dataSource = imgurImages
            case .failure(let error):
                print(error)
            }
            
            self.tableView.reloadData()
        }
    }
}
