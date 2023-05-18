import Foundation

enum DeserializationMode: Int, Codable {
    case manualMode = 0
    case codableMode = 1
    case crazyCodable = 2
}

struct JSONDeserializationMode: Codable {
    var mode: DeserializationMode
}
