import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Public properties
    
    var dataSource: [Article] = []
    var articleFetcher = ArticleFetcher()
    var asyncImageLoader = AsyncImageFetcher()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        articleFetcher.fetch { [weak self] articles in
            self?.activityIndicatorView.stopAnimating()
                        
            self?.dataSource = articles
                        
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - <UITableViewDataSource>
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ArticleTableViewCell
        
        cell.selectionStyle = .none
        
        let article = dataSource[indexPath.row]
        
        cell.articleTitle.text = article.title
        
        let fetchDataTaskUUID = asyncImageLoader.fetchImage(imageURLString: article.imageURLString) { image in
            DispatchQueue.main.async {
                if let image = image {
                    cell.articleImageView.image = image
                }
            }
        }
        
        if let fetchDataTaskUUID = fetchDataTaskUUID {
            cell.onReuse = { [weak self] in
                self?.asyncImageLoader.cancelImageFetch(fetchDataTaskUUID)
            }
        }
                        
        return cell
    }
    
    // MARK: - Private methods
    
    private func setup() {
        title = "Articles"
        
        setupTableView()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: "cell")

        tableView.tableFooterView = UIView(frame: .zero)
    }
}
