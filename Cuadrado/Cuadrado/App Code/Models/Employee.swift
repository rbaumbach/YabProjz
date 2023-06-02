import Foundation

enum EmployeeType: String, Equatable {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
    
    func display() -> String {
        switch self {
        case .fullTime:
            return "Full Time"
        case .partTime:
            return "Part Time"
        case .contractor:
            return "Contractor"
        }
    }
}

struct Employee: Equatable {
    // MARK: - Readonly public properties
    
    let id: String
    let fullname: String
    let phoneNumber: String?
    let email: String
    let biography: String?
    let smallPhotoURL: URL?
    let largePhotoURL: URL?
    let team: String
    let type: EmployeeType
    
    // MARK: - Init method
    
    init(id: String,
         fullname: String,
         phoneNumber: String? = nil,
         email: String,
         biography: String? = nil,
         smallPhotoURL: URL? = nil,
         largePhotoURL: URL? = nil,
         team: String,
         type: EmployeeType) {
        self.id = id
        self.fullname = fullname
        self.phoneNumber = phoneNumber
        self.email = email
        self.biography = biography
        self.smallPhotoURL = smallPhotoURL
        self.largePhotoURL = largePhotoURL
        self.team = team
        self.type = type
    }
}
