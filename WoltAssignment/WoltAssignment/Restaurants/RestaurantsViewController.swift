import UIKit
import Combine

class RestaurantsViewController: UIViewController {
    final private let cellIdentifier: String = "RestaurantCell"
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        return tableView
    }()
    private lazy var viewModel = RestaurantsViewModel()
    private lazy var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: cellIdentifier)

        view.addSubview(tableView)
        setupConstraints()

        loadItems()
        startUpdating()
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func startUpdating() {
        Timer.publish(every: 10, tolerance: 1, on: .main, in: .common)
            .autoconnect()
            .map { _ in Date() }
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.loadItems()
            }
            .store(in: &cancellables)
    }

    private func loadItems() {
        viewModel.loadItems {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath
        ) as? RestaurantCell else {
            fatalError()
        }
        guard let item = self.viewModel.items?[indexPath.row] else { fatalError() }
        let isFavorite: Bool = self.viewModel.isFavoriteVenue(for: item.venue.id)
        cell.setup(item: item, isFavorite: isFavorite)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}
