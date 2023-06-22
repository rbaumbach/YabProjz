import Foundation

struct Constants {
    struct Imgur {
        static let ClientIDKey = "Authorization"
        static let ClientIDValue = "Client-ID <Enter your ClientID here>"
        static let BaseURL = "https://api.imgur.com"
    }
    
    struct App {
        static let mainTitle = "Imgur Search"
        static let imagePlaceholderName = "photo"
        static let defaultImgurImageDescription = "N/A"
        static let defaultSearchTerm = "Chihuahua"
        
        static let mainTableViewCellHeight = 132.0
        static let defaultDebouncerTime = 0.3
    }
}
