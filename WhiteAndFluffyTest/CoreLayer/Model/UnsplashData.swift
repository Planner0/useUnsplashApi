//
//  RandomPhotosObjectController.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 16.10.2022.
//
//import UIKit
import Foundation

class UnsplashData {
    static let shared = UnsplashData()
    private init() {
        //fetchImages()
        
    }
//    enum State {
//        case loading
//        case loaded
//    }
//    private(set) var state: State = .loading {
//        didSet {
//            stateChanged?(state)
//        }
//    }
//    var stateChanged: ((State) -> Void)?
    
    var photoArray = [Photo]()
    
    func fetchImages() {
        //NotificationCenter.default.post(name: .didReceiveData, object: self)
        
        // MARK: UrlComponents
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos/random"
        urlComponents.query = "count=30"
        
        let accessKey = "7Yt8mtpoG6x8DwBciVCVGHBh6ERwSFKsnFBBan_Vsos" // Authorization: Client-ID YOUR_ACCESS_KEY
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization") // Basic auth
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode([Photo].self, from: data)
                        for photo in json {
                            DispatchQueue.main.async {
                                self.photoArray.append(photo)
                            }
                            
                        }
                        print(self.photoArray.count)
//                      print("ID:\(element.id)/Autor:\(element.user.username)/Date: \(element.createdAt)/Location:\(element.location.name ?? "nil")/Downloads: \(element.downloads)")
//                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
            print("task end")
            NotificationCenter.default.post(name:  NSNotification.Name("myNewEvent"), object: nil)
            //self.state = .loaded
        }
        
    }
}
