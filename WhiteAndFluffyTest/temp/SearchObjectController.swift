//
//  File.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 16.10.2022.
//
//
//import Foundation
//
//class SearchObjectController: ObservableObject {
//    static let shared = SearchObjectController()
//    private init() {}
//
//    //@Published var result = [Result]()
//    @Published var searchText: String = "london"
//
//    func search() {
//
//        // MARK: UrlComponents
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.unsplash.com"
//        urlComponents.path = "/search/photos"
//        urlComponents.query = "query=\(searchText)"
//
//        let accessKey = "7Yt8mtpoG6x8DwBciVCVGHBh6ERwSFKsnFBBan_Vsos" // Authorization: Client-ID YOUR_ACCESS_KEY
//
//        if let url = urlComponents.url {
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//
//            request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization") // Basic auth
//            print(request.allHTTPHeaderFields)
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let unwrappedData = data {
//                    do {
//                        let res = try JSONDecoder().decode([Photo].self, from: unwrappedData)
//
////                        DispatchQueue.main.async {
////                            UILabel.text = planet.orbitalPeriod
////                        }
//                        print(res)
//                    }
//                    catch let error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//
//            task.resume()
//        }
//    }
//}
