import UIKit
import SDWebImage

class CuadradoViewController: UIViewController, UITableViewDataSource {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basicStatusLabel: UILabel!
    
    // MARK: - Public properties
        
    var employeesResult: Result<[Employee], APIClientError>!
    var dataSource: [Employee] = []
    
    var sdWebImageWrapper: SDWebImageWrapperProtocol = SDWebImageWrapper()
        
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
        let cell = dequeueEmployeeTableViewCell(indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupDataSource()
        setupTableView()
    }
    
    private func setupDataSource() {
        switch employeesResult {
        case .success(let employees):
            handleSuccess(employees: employees)
                        
        case .failure(_):
            handleFailure()
            
        case .none:
            preconditionFailure("CuadradoViewController has no employeesResult")
        }
    }
    
    private func setupTableView() {
        tableView.register(EmployeeTableViewCell.nib,
                           forCellReuseIdentifier: EmployeeTableViewCell.reuseId)
        
        tableView.tableFooterView = UIView()
    }
    
    private func handleSuccess(employees: [Employee]) {
        if employees.isEmpty {
            basicStatusLabel.text = "There are no employees"
            basicStatusLabel.isHidden = false
            
            return
        }
        
        dataSource = employees
    }
    
    private func handleFailure() {
        basicStatusLabel.isHidden = false
    }
    
    private func dequeueEmployeeTableViewCell(indexPath: IndexPath) -> EmployeeTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseId, for: indexPath) as! EmployeeTableViewCell
        
        let employee = dataSource[indexPath.row]
        
        cell.fullnameLabel.text = employee.fullname
        cell.emailLabel.text = employee.email
        cell.teamLabel.text = employee.team
        cell.typeLabel.text = employee.type.display()
        cell.phoneNumberLabel.text = employee.phoneNumber
        cell.biographyLabel.text = employee.biography
        
        if let profilePhotoSmallImageURL = employee.smallPhotoURL {
            sdWebImageWrapper.getImage(url: profilePhotoSmallImageURL) { image in
                if let image = image {
                    cell.profilePhotoImageView.image = image
                }
            }
        }
        
        return cell
    }
}
