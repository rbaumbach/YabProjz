import UIKit
import SDWebImage

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetailViewControllerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    var imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService()
    var viewControllerBuilder: ViewControllerBuilderProtocol = ViewControllerBuilder()
    
    var dataSource: [ImgurImage] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
                                        placeholderImage: UIImage(systemName: "photo"))
        
        cell.descriptionLabel.text = imgurImage.description ?? "N/A"
        
        return cell
    }
    
    // MARK: - <UITableViewDelegate>
    
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return 132.0
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
        setupTableView()
        
        fetchImages()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: ImgurImageTableViewCell.identifier, bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: ImgurImageTableViewCell.identifier)
    }
    
    private func fetchImages() {
        imageNetworkService.getImages(searchTerm: "Chihuahua") { [weak self] result in
            guard let self = self else { return }
                        
            switch result {
            case .success(let imgurImages):
                self.dataSource = Array(imgurImages[0..<10])
            case .failure(let error):
                print(error)
            }
            
            self.tableView.reloadData()
        }
    }
}
