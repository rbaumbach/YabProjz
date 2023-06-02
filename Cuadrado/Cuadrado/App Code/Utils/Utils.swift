import Foundation
import UIKit

// MARK: - AppLaunchLoader

protocol AppLaunchLoaderProtocol {
    func load(completionHandler: @escaping (Result<[Employee], APIClientError>) -> Void)
}

class AppLaunchLoader: AppLaunchLoaderProtocol {
    // MARK: - Private properties
    
    private let sdWebImageWrapper: SDWebImageWrapperProtocol
    private let employeeNetworkService: EmployeeNetworkServiceProtocol
    
    // MARK: - Init methods
    
    init(sdWebImageWrapper: SDWebImageWrapperProtocol = SDWebImageWrapper(),
         employeeNetworkService: EmployeeNetworkServiceProtocol = EmployeeNetworkService()) {
        self.sdWebImageWrapper = sdWebImageWrapper
        self.employeeNetworkService = employeeNetworkService
    }
    
    // MARK: - Public methods
    
    func load(completionHandler: @escaping (Result<[Employee], APIClientError>) -> Void) {
        sdWebImageWrapper.neverExpireImageCache()
        
        employeeNetworkService.getEmployees { result in
            completionHandler(result)
        }
    }
}
