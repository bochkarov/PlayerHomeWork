//
//  SearchViewController.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 04.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let networkDataFetcher = NetworkDataFetcher()
    let table = UITableView(frame: .zero, style: .plain)
    var timer: Timer?
    var searchResponse: SearchResponse? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        setupSearchBar()
        setupElements()
        setupConstraints()
        
        let urlString = "https://itunes.apple.com/search?term=Queen&limit=10"
        self.networkDataFetcher.fetchTracks(urlString: urlString) { (searchResponse) in
            guard let searchResponse = searchResponse else { return }
            self.searchResponse = searchResponse
            self.table.reloadData()
        }
    }
}

// MARK: - Setup View
extension SearchViewController {
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func setupElements() {
        title = "Search"
        view.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false

        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        table.delegate = self
        table.dataSource = self
    }
}

// MARK: - Setup Constrains
extension SearchViewController {
    func setupConstraints() {
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let track = searchResponse?.results[indexPath.row]
        cell.setup(track: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackViewController = TrackViewController()
        let track = searchResponse?.results[indexPath.row]
        trackViewController.set(track: track)
        trackViewController.trackDelegate = self
//        trackViewController.modalPresentationStyle = .fullScreen
        present(trackViewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=10"
            self.networkDataFetcher.fetchTracks(urlString: urlString) { (searchResponse) in
                guard let searchResponse = searchResponse else { return }
                self.searchResponse = searchResponse
                self.table.reloadData()
            }
        })
    }
}

// MARK: - TrackMovingDelegate
extension SearchViewController: TrackMovingDelegate {
    func getTrack(isForward: Bool) -> Track? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        
        if isForward {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchResponse?.results.count {
                nextIndexPath.row = 0
            }
            
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = (searchResponse?.results.count)! - 1
            }
        }
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let track = searchResponse?.results[nextIndexPath.row]
        
        return track
        
    }
    
    func moveToPreviousTrack() -> Track? {
        
        return getTrack(isForward: false)
    }
    
    func moveToNextTrack() -> Track? {
        return getTrack(isForward: true)    }
    
    
}


// MARK: - SwiftUI
import SwiftUI

struct SearchVCProvider: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                ContainerView().edgesIgnoringSafeArea(.all)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                    .previewDisplayName("iPhone 11 Pro")
                
                ContainerView().edgesIgnoringSafeArea(.all)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 7"))
                    .previewDisplayName("iPhone 7")
            }
        }
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SearchVCProvider.ContainerView>) -> MainTabBarController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: SearchVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SearchVCProvider.ContainerView>) {
            
        }
    }
}
