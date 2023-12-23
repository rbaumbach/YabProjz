import Foundation

protocol JSONLoaderProtocol {
    func buildEvents() -> [Event]
}

final class JSONLoader: JSONLoaderProtocol {
    // MARK: - Private properties
    
    private let bundle: BundleProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private let stringFileLoader: StringFileLoaderProtocol
    
    // MARK: - Init methods
    
    init(bundle: BundleProtocol = Bundle.main,
         stringFileLoader: StringFileLoaderProtocol = StringFileLoader(),
         jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.bundle = bundle
        self.stringFileLoader = stringFileLoader
    }
    
    // MARK: - Public methods
    
    func buildEvents() -> [Event] {
        guard let bundlePath = bundle.path(forResource: "mock", ofType: "json") else {
            print("Unable to find JSON file")
            
            return []
        }
        
        guard let jsonData = try? stringFileLoader.loadData(path: bundlePath) else {
            print("Unable to load JSON data")
            
            return []
        }
        
        guard let events = try? jsonDecoder.decode([Event].self, from: jsonData) else {
            print("Unable to decode JSON")
            
            return []
        }
        
        return events
    }
}
