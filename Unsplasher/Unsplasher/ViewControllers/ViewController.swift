import UIKit
import UnsplashPhotoPicker

final class ViewController: UIViewController, UnsplashPhotoPickerDelegate, DetailViewControllerDelegate {
    // MARK: - Readonly properties
    
    let unsplashPhotoPickerConfiguration = UnsplashPhotoPickerConfiguration(accessKey: Constants.Unsplash.AccessKey,
                                                                            secretKey: Constants.Unsplash.SecretKey)
    
    // MARK: - Public properties
    
    private(set) var unsplashPhotoPicker: UnsplashPhotoPicker!
    
    var viewControllerBuilder: ViewControllerBuilderProtocol = ViewControllerBuilder()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - <UnsplashPhotoPickerDelegate>
    
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker,
                             didSelectPhotos photos: [UnsplashPhoto]) {
        let imageURL = photos[0].urls[.small]
        
        displayDetailViewController(imageURL: imageURL)
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        // Note: Remove the cancel from my forked copy of unsplash-photo-picker
        // Or make it configurable to the user.  For now this method does nothing.
    }
    
    // MARK: - <DetailViewControllerDelegate>
    
    func didClose() {
        dismiss(animated: true)
    }
    
    // MARK: - Private methpds
    
    private func setup() {
        displayUnsplashPhotoPicker()
    }
    
    private func displayUnsplashPhotoPicker() {
        unsplashPhotoPicker = UnsplashPhotoPicker(configuration: unsplashPhotoPickerConfiguration)
        unsplashPhotoPicker.photoPickerDelegate = self
        unsplashPhotoPicker.shouldHideCancelButton = true
        
        addChild(unsplashPhotoPicker)
        view.addSubview(unsplashPhotoPicker.view)
        unsplashPhotoPicker.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            unsplashPhotoPicker.view.topAnchor.constraint(equalTo: view.topAnchor),
            unsplashPhotoPicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            unsplashPhotoPicker.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            unsplashPhotoPicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func displayDetailViewController(imageURL: URL?) {
        let detailViewController: DetailViewController = viewControllerBuilder.build(name: "DetailViewController")
        
        detailViewController.delegate = self
        detailViewController.imageURL = imageURL
        
        present(detailViewController, animated: true)
    }
}
