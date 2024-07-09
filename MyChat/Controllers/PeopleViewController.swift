//
//  PeopleViewController.swift
//  MyChat
//
//  Created by white4ocolate on 16.04.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    
    var nearblyPeople = [MyUser]()
    enum Section: Int, CaseIterable {
        case nearblyPeople
        func description(usersCount: Int) -> String {
            switch self {
            case .nearblyPeople:
                return "\(usersCount) people nearbly"
            }
        }
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, MyUser>?
    var collectionView: UICollectionView!
    private let currentUser: MyUser
    private var usersListener: ListenerRegistration?
    
    init(currentUser: MyUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        usersListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        usersListener = ListenerService.shared.usersObserve(users: nearblyPeople, completion: { result in
            switch result {
            case .success(let users):
                self.nearblyPeople = users
                self.performQuery(with: nil)
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        })
    }
    
    @objc private func logOut() {
        let alertController = UIAlertController(title: "Log Out?", message: "Are you surre want logout?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .destructive) { _ in
            do{
                try Auth.auth().signOut()
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = AuthViewController()
            } catch {
                print("Error with logout: \(error.localizedDescription)")
            }
        }
        let noButton = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        present(alertController, animated: true)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        collectionView.register(NearblyUserCell.self, forCellWithReuseIdentifier: NearblyUserCell.reuseId)
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
    }
    
    private func performQuery(with searchText: String?) {
        let fileteredPeople = nearblyPeople.filter { user -> Bool in
            user.contains(searchText: searchText)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section , MyUser>()
        snapshot.appendSections([.nearblyPeople])
        snapshot.appendItems(fileteredPeople, toSection: .nearblyPeople)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

//MARK: - Data Source
extension PeopleViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MyUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .nearblyPeople:
                return self.configure(collectionView: collectionView, cellType: NearblyUserCell.self, with: user, for: indexPath)
            }
        })
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can't create section header") }
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            let items = self.dataSource?.snapshot().itemIdentifiers(inSection: .nearblyPeople)
            sectionHeader.configure(text: section.description(usersCount: items!.count), font: .systemFont(ofSize: 36, weight: .light ), textColor: .label)
            
            return sectionHeader
        }
    }
}

//MARK: - Setup Layout
extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .nearblyPeople:
                return self.createUsersList()
            }
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        return layout
    }
    
    private func createUsersList() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize =  NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
}

//MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

//MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true)
    }
}
