import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Public properties
    
    var dataSource: [Article] = []
    var articleFetcher = ArticleFetcher()
    var asyncImageFetcher = AsyncImageFetcher()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        articleFetcher.fetch { [weak self] articles in
            self?.articleFetchHandler(articles: articles)
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
        let cell = dequeueReusableCell(indexPath: indexPath)
                
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
    
    private func dequeueReusableCell(indexPath: IndexPath) -> ArticleTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ArticleTableViewCell
        
        cell.selectionStyle = .none
        
        let article = dataSource[indexPath.row]
        
        cell.articleTitle.text = article.title
        
        let dataTaskUUID = asyncImageFetcher.fetch(imageURLString: article.imageURLString) { image in
            guard let image = image else {
                return
            }
            
            DispatchQueue.main.async {
                cell.articleImageView.image = image
            }
        }
        
        if let dataTaskUUID = dataTaskUUID {
            cell.onReuse = { [weak self] in
                self?.asyncImageFetcher.cancel(imageFetchUUID: dataTaskUUID)
            }
        }
        
        return cell
    }
    
    private func articleFetchHandler(articles: [Article]) {
        activityIndicatorView.stopAnimating()
        dataSource = articles
        tableView.reloadData()
    }
}
