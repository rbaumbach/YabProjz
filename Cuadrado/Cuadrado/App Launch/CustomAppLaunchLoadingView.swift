import UIKit

class CustomAppLaunchLoadingView: UIView {
    // MARK: - Init methods
    
    public init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private func setup() {
        self.backgroundColor = .white
        
        setupLogoImageView()
        setupActivityIndicatorView()
    }
    
    private func setupLogoImageView() {
        let cuadradoLogoImage = UIImage(named: "cuadrado-logo")
        
        let logoImageView = UIImageView(image: cuadradoLogoImage)
        logoImageView.contentMode = .scaleAspectFit
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.30),
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.30)
        ])
    }
    
    private func setupActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView()
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.bottomAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 50.0)
        ])

        activityIndicatorView.style = .large
        activityIndicatorView.color = .black
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
}
