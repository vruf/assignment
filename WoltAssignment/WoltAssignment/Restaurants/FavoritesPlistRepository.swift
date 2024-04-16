import Foundation

class FavoritesPlistRepository {
    static let shared: FavoritesPlistRepository = FavoritesPlistRepository()
    private let path: String = "favorites.plist"
    
    func saveFavorites(_ items: Set<String>) {
        let favoritesArray: [String] = Array(items)
        
        guard let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) else {
            return
        }
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: favoritesArray, format: .binary, options: 0)
            try data.write(to: plistURL)
        } catch {
            print("Error saving favorite item IDs: \(error)")
        }
    }
    
    func loadFavorites() -> Set<String> {
        guard let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: plistURL)
            let favorites = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String] ?? []
            return Set(favorites)
        } catch {
            if !FileManager.default.fileExists(atPath: plistURL.path) {
                // If the file doesn't exist, create it with default data
                if let defaultData = [] as NSArray? {
                    let success = defaultData.write(to: plistURL, atomically: true)
                    if success {
                        print("Plist file created successfully")
                    } else {
                        print("Error: Failed to create plist file")
                    }
                }
            }
            return []
        }
    }
}
