//
//  ViewController.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 13.10.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemYellow
        setupNavigationBar()
        
        // Do any additional setup after loading the view.
    }
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favorites"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
