import Foundation

protocol BundleProtocol {
    func path(forResource name: String?,
              ofType ext: String?) -> String?
}

extension Bundle: BundleProtocol { }
