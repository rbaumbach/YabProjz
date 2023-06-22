import Foundation

struct ImgurItem: Codable, Equatable {
    // MARK: - Readonly properties
    
    let id: String
    let title: String
    let images: [ImgurImage]
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case images
    }
    
    // MARK: - Init methods
    
    init(id: String, title: String, images: [ImgurImage]) {
        self.id = id
        self.title = title
        self.images = images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        images = try container.decodeIfPresent([ImgurImage].self, forKey: .images) ?? []
    }
}
