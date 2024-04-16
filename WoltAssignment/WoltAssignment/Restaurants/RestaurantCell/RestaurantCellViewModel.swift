import Foundation

class RestaurantCellViewModel {
    private let plistRepository = FavoritesPlistRepository.shared
    
    func setFavoriteVenue(_ venue: Venue) {
        venue.isFavorite ? saveToFavorites(venue) : removeFromFavorites(venue)
    }
    
    func saveToFavorites(_ venue: Venue) {
        var favoriteItems: Set<String> = plistRepository.loadFavorites()
        favoriteItems.insert(venue.id)
        plistRepository.saveFavorites(favoriteItems)
    }
    func removeFromFavorites(_ venue: Venue) {
        var favoriteItems: Set<String> = plistRepository.loadFavorites()
        favoriteItems.remove(venue.id)
        plistRepository.saveFavorites(favoriteItems)
    }
}
