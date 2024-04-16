import Foundation
import UIKit

class RestaurantCell: UITableViewCell {
    private lazy var venueImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .label
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    private var venue: Venue?
    private let viewModel: RestaurantCellViewModel = RestaurantCellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        [venueImage, titleLabel, subtitleLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            venueImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            venueImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            venueImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            venueImage.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: venueImage.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: venueImage.trailingAnchor, constant: 10),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            subtitleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setup(item: Item, isFavorite: Bool) {
        Task {
            do {
                guard let url = URL(string: item.image.url) else { throw URLError(.badURL) }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                DispatchQueue.main.async {
                    self.venueImage.image = UIImage(data: data)
                }
            } catch { print(error) }
        }
        venue = item.venue
        venue?.isFavorite = isFavorite
        titleLabel.text = item.venue.name
        subtitleLabel.text = item.venue.description
        favoriteButton.setImage(UIImage(systemName: venue?.isFavorite ?? false ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc func favoriteButtonTapped() {
        guard var venue = self.venue else { return }
        venue.isFavorite.toggle()
        viewModel.setFavoriteVenue(venue)
        DispatchQueue.main.async {
            UIView.transition(with: self.favoriteButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.favoriteButton.setImage(UIImage(systemName: venue.isFavorite ? "heart.fill" : "heart"), for: .normal)
            }, completion: nil)
            self.venue = venue
        }
    }
}
