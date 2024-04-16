import Foundation

struct RestaurantsResponse: Codable {
    let sections: [Section]
}

struct Section: Codable {
    let template: String
    let items: [Item]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(String.self, forKey: .template) {
            case "venue-vertical-list":
                let items = try container.decode([Item].self, forKey: .items)
                self.template = "venue-vertical-list"
                self.items = items
            default:
                self.items = []
                self.template = ""
        }
    }
}

struct Item: Codable {
    let image: Image
    var venue: Venue
}

struct Image: Codable {
    let url: String
    let blurhash: String?
}

struct Venue: Codable {
    let id: String
    let name: String
    let description: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "short_description"
    }
}
