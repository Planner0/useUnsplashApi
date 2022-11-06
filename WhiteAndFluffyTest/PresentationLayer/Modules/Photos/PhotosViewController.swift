//
//  FavoriteList.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 13.10.2022.
//

import UIKit

final class PhotosViewController: UIViewController {
    
    private enum State {
        case loading
        case loaded(data: [Photo])
        case error(_ error: NetworkError)
    }
    
    var randomPhotos = UnsplashData.shared
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
//        collection.register(PhotosCollectionViewCell.self,forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collection.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collection
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let networkService: NetworkServiceProtocol = NetworkService()
    
    private var state: State = .loading
    
    private let dataType: SceneDelegate.DataType
    //private let databaseCoordinator: DatabaseCoordinatable
    
    init(dataType: SceneDelegate.DataType) {
        self.dataType = dataType
        //self.databaseCoordinator = databaseCoordinator
        super.init(nibName: nil, bundle: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(removeArticleFromFavorites(_:)),
//                                               name: .didRemoveArticleFromFavorites,
//                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        self.obtainData()
    }

//        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidReceiveData), name: NSNotification.Name("myNewEvent"), object: nil)
//    }
    //        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData), name: .didReceiveData, object: nil)

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Photos"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.activityIndicator)

        let collectionViewConstraints = self.collectionViewConstraints()
        let activityIndicatorConstaints = self.activityIndicatorConstaints()
        
        NSLayoutConstraint.activate(
            collectionViewConstraints +
            activityIndicatorConstaints
        )
    }
    
    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        let topConstraint = self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leftConstraint = self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let rightConstraint = self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        return [
            topConstraint, leftConstraint, rightConstraint, bottomConstraint
        ]
    }
    
    private func activityIndicatorConstaints() -> [NSLayoutConstraint] {
        let centerYConstraint = self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let centerXConstraint = self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        return [
            centerYConstraint, centerXConstraint
        ]
    }
    private func obtainData() {
        let dispatchGroup = DispatchGroup()
        
        var obtainedError: NetworkError?
        var obtainedPhotos: [Photo] = []
        //var obtainedArticleRealmModels: [ArticleRealmModel] = []
    
        let completion: (Result<Data, NetworkError>) -> Void = { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let photos = try self.parse([Photo].self, from: data)
                    
//                    guard let photos = self.filterData(Photo) else {
//                        obtainedError = .parseError(reason: "Could't filter received data")
//                        return
//                    }
                    
                    obtainedPhotos = photos
                } catch let error {
                    if let error = error as? NetworkError {
                        obtainedError = error
                    } else {
                        obtainedError = .unknownError
                    }
                }
            case .failure(let error):
                obtainedError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.dataType == .request
        ? self.fetchPhotos(completion: completion)
        : self.fetchMockData(completion: completion)
        
//        dispatchGroup.enter()
//        self.databaseCoordinator.fetchAll(ArticleRealmModel.self) { result in
//            switch result {
//            case .success(let articleRealmModels):
//                obtainedArticleRealmModels = articleRealmModels
//            case .failure:
//                break
//            }
//            dispatchGroup.leave()
//        }
        
        dispatchGroup.notify(queue: .main) {
            guard obtainedError == nil else {
                self.stopAnimating()
                self.state = .error(obtainedError ?? .default)
                return
            }
            
            guard !obtainedPhotos.isEmpty else {
                self.stopAnimating()
                self.state = .loaded(data: obtainedPhotos)
                self.collectionView.reloadData()
                return
            }
            
//            for (index, photos) in obtainedPhotos.enumerated() {
//                var favoriteArticle = article
//                guard let articleRealmModel = obtainedArticleRealmModels.first(where: { $0.url == favoriteArticle.url }) else { continue }
//
//                favoriteArticle.isFavorite = articleRealmModel.isFavorite
//                obtainedArticles[index] = favoriteArticle
//            }
            
            self.stopAnimating()
            self.state = .loaded(data: obtainedPhotos)
            self.collectionView.reloadData()
        }
    }
    
    private func parse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            let model = try self.decoder.decode(T.self, from: data)
            print("🍏", dump(model))
            return model
        } catch let error {
            print("🍎", error)
            throw NetworkError.parseError(reason: error.localizedDescription)
        }
    }
    
    private func fetchMockData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        self.startAnimating()
        if let path = Bundle.main.path(forResource: "photos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("🍏", String(data: data, encoding: .utf8))
                completion(.success(data))
            } catch let error {
                print("🍎", error)
                completion(.failure(.parseError(reason: error.localizedDescription)))
            }
        } else {
            print("🍎 Invalid filename/path.")
            completion(.failure(.unknownError))
        }
    }
    
    private func fetchPhotos(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let endPoint = self.urlComponents()
        if let url = endPoint.url {
            self.startAnimating()
            self.sendRequest(for: url, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
    }
    
    private func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos/random"
        urlComponents.queryItems = [
            URLQueryItem(name: "count", value: "30"),
            URLQueryItem(name: "client_id", value: "7Yt8mtpoG6x8DwBciVCVGHBh6ERwSFKsnFBBan_Vsos"),
        ]
        return urlComponents
    }
    
    private func sendRequest(for url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        self.networkService.request(url: url) { result in
            switch result {
            case .success(let data):
//                print("🍏", String(data: data, encoding: .utf8))
                completion(.success(data))
            case .failure(let error):
//                print("🍎", error)
                completion(.failure(error))
            }
        }
    }
    
    private func startAnimating() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.stopAnimating()
    }
//    private func filterData<T>(_ data: T) -> T? {
//        if let articles = data as? [Photo] {
//            let filterArticles = articles.filter({ $0.publishedAtString?.isEmpty == false && $0.publishedAtString?.isFirstCharacterWhitespace == false })
//            return filterArticles as? T
//        }
//
//        if let articlesViewModel = data as? [ArticleTableViewCell.ViewModel] {
//            let filterArticlesViewModel = articlesViewModel.filter({ !$0.publishedAt.isEmpty && !$0.publishedAt.isFirstCharacterWhitespace })
//            return filterArticlesViewModel as? T
//        }
//
//        return nil
//    }
//   @objc func onDidReceiveData() {
//       print("OK")
//       self.collectionView.reloadData()
//    }
}
extension PhotosViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.state {
        case .loading, .error:
            return 0
        case .loaded(let photos):
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.state {
        case .loading, .error:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        case .loaded(let photos):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotosCollectionViewCell else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            let photo = photos[indexPath.row]
//            let model = PhotosCollectionViewCell.ViewModel(title: article.title,
//                                                       description: article.description,
//                                                       publishedAt: article.publishedAtString ?? .empty,
//                                                       url: article.url,
//                                                       isFavorite: article.isFavorite)
//            cell.delegate = self
//            cell.setup(with: model)
            
            URLSession.shared.dataTask(with: photo.urls.thumbUrl) { (data, response, error) in
                if let error = error {
                    print("Erorr: \(error)")
                } else if let data = data {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
            
            return cell
        }
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
//
//        URLSession.shared.dataTask(with: randomPhotos.photoArray[indexPath.row].urls.thumbUrl) { (data, response, error) in
//            if let error = error {
//                print("Erorr: \(error)")
//            } else if let data = data {
//                DispatchQueue.main.async {
//                    cell.photoImageView.image = UIImage(data: data)
//
//                }
//                }
//            }.resume()
//        return cell
    }
}
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor(collectionView.frame.width / 3) - 12, height: floor(collectionView.frame.width / 3) - 12)
    }
}
