import Foundation

struct ImgurResponse: Codable {
    let data: [ImgurItem]
}

struct ImgurItem: Codable {
    let id: String
    let title: String
    let images: [ImgurImage]
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        images = try container.decodeIfPresent([ImgurImage].self, forKey: .images) ?? []
    }
}

enum ImgurMediaType: String {
    case image = "image/jpeg"
    case video = "video/mp4"
    case unknown
}

struct ImgurImage: Codable {
    let id: String
    let description: String?
    let mediaType: ImgurMediaType
    let url: URL?
    
    enum CodingKeys: CodingKey {
        case id
        case description
        case type
        case link
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        let rawType = try container.decode(String.self, forKey: .type)
        mediaType = ImgurMediaType(rawValue: rawType) ?? .unknown
        
        let urlString = try container.decode(String.self, forKey: .link)
        url = URL(string: urlString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(mediaType.rawValue, forKey: .type)
        
        try container.encodeIfPresent(url?.absoluteString, forKey: .link)
    }
}
