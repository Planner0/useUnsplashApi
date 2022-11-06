//
//  PhotoCollectionViewCell.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 16.10.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    struct ViewModel: ViewModelProtocol {
//        let title: String
//        let description: String?
//        let publishedAt: String
//        let url: String
//        var isFavorite: Bool
        let createdAt: String
        let description: String?
        let urls: Urls
        let user: User
        let location: Location
        let downloads: Int
    }
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
