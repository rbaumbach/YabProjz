import UIKit
import SDWebImage

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ImgurImageTableViewCell.identifier,
                                                 for: indexPath) as! ImgurImageTableViewCell
        
        let imgurImage = dataSource[indexPath.row]
        
        cell.imgurImageView.sd_setImage(with: imgurImage.url,
                                        placeholderImage: UIImage(systemName: "trash"))
        
        cell.descriptionLabel.text = imgurImage.description ?? "N/A"
        
        return cell
    }
    
    // MARK: - <UITableViewDelegate>
    
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return 132.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Present detailed view
    }
    
    // MARK: - Private methods
    
    private func setupView() {
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
