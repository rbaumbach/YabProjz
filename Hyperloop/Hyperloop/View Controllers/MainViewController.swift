import UIKit
import SDWebImage
import Utensils

class MainViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate, DetailViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Views
    
    var searchController: UISearchController!
    
    // MARK: - Public properties
    
    var imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService()
    var viewControllerBuilder: ViewControllerBuilderProtocol = ViewControllerBuilder()
    var debouncer: DebouncerProtocol = Debouncer()
    
    var dataSource: [ImgurImage] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        title = Constants.App.mainTitle
    }
    
    // MARK: - <UISearchResultsUpdating>
    
    func updateSearchResults(for searchController: UISearchController) {
        guard var searchText = searchController.searchBar.text else { return }
        
        debouncer.mainDebounce(seconds: Constants.App.defaultDebouncerTime) {
            if searchText == String.empty {
                searchText = Constants.App.defaultSearchTerm
            }
            
            self.fetchImages(searchTerm: searchText)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ImgurImageTableViewCell.identifier,
                                                 for: indexPath) as! ImgurImageTableViewCell
        
        let imgurImage = dataSource[indexPath.row]
        
        cell.imgurImageView.sd_setImage(with: imgurImage.url,
                                        placeholderImage: UIImage(systemName: Constants.App.imagePlaceholderName))
        
        cell.descriptionLabel.text = imgurImage.description ?? Constants.App.defaultImgurImageDescription
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - <UITableViewDelegate>
    
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return Constants.App.mainTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = viewControllerBuilder.build(name: "DetailViewController")
        detailViewController.delegate = self
        
        let cell = tableView.cellForRow(at: indexPath) as! ImgurImageTableViewCell
        let image = cell.imgurImageView.image
        
        detailViewController.image = image
        
        present(detailViewController, animated: true)
    }
    
    // MARK: - <DetailViewControllerDelegate>
    
    func didClose() {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupSearchController()
        setupTableView()
        fetchImages(searchTerm: Constants.App.defaultSearchTerm)
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Constants.App.defaultSearchTerm
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: ImgurImageTableViewCell.identifier, bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: ImgurImageTableViewCell.identifier)
    }
    
    private func fetchImages(searchTerm: String) {
        imageNetworkService.getImages(searchTerm: searchTerm) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imgurImages):
                defer {
                    self.dataSource = imgurImages
                    self.tableView.reloadData()
                }
                
                guard imgurImages.count != 0 else {
                    self.showError(text: "Unable to find images for: \(searchTerm)")
                    
                    return
                }
                
                self.hideError()
            case .failure(let error):
                defer {
                    self.dataSource = []
                    self.tableView.reloadData()
                }
                
                self.showError(text: "Error: \(error)")
            }
        }
    }

    private func showError(text: String) {
        errorLabel.text = text
        errorLabel.isHidden = false
        tableView.isHidden = true
    }
    
    private func hideError() {
        errorLabel.isHidden = true
        
        tableView.isHidden = false
    }
}
