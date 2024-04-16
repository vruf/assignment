import Foundation
import Combine
import UIKit
import CoreData

struct Coordinates {
    let lat: String
    let lon: String
}


class RestaurantsViewModel {
    final private let fetchURL: String = "https://restaurant-api.wolt.com/v1/pages/restaurants"
    final private var coordinates: [Coordinates] = [
        .init(lat: "60.170187", lon: "24.930599"),
        .init(lat: "60.169418", lon: "24.931618"),
        .init(lat: "60.169818", lon: "24.932906"),
        .init(lat: "60.170005", lon: "24.935105"),
        .init(lat: "60.169108", lon: "24.936210"),
        .init(lat: "60.168355", lon: "24.934869"),
        .init(lat: "60.167560", lon: "24.932562"),
        .init(lat: "60.168254", lon: "24.931532"),
        .init(lat: "60.169012", lon: "24.930341"),
        .init(lat: "60.170085", lon: "24.929569"),
    ]
    final private let itemsLimit: Int = 15
    
    
    var items: [Item]?
    var itemsCount: Int {
        items?.count ?? 0
    }
    var favoriteItems: Set<String> = []
    
    func loadItems(completion: @escaping () -> Void) {
        guard let url = URL(string: "\(fetchURL)?lat=\(coordinates[0].lat)&lon=\(coordinates[0].lon)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(RestaurantsResponse.self, from: data)
                guard let section = data.sections.first(where: {
                    $0.template == "venue-vertical-list"
                }) else {
                    self.items = []
                    return
                }
                
                self.items = Array(section.items[0..<15])
                self.favoriteItems = self.getFavoriteVenues()
                completion()
            } catch {
                print("error while parsing")
                print(error.localizedDescription)
                return
            }
        }.resume()
        
        coordinates.append(coordinates.removeFirst())
    }
    
    func getFavoriteVenues() -> Set<String> {
        return FavoritesPlistRepository.shared.loadFavorites()
    }
    
    func isFavoriteVenue(for id: String) -> Bool {
        return favoriteItems.contains(id)
    }
}
