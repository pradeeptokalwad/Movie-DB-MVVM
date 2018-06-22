//
//  MovieListCollectionViewCell.swift
//  Movie DB
//
//  Created by webwerks on 6/22/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCollectionViewCell: UICollectionViewCell {
    
    lazy var lblTitle : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.33)
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = "Title"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imgView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "placeholder")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMovieListCollectionViewCell()
    }
    
    func setupMovieListCollectionViewCell() {
        addSubview(imgView)
        addSubview(lblTitle)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        lblTitle.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    func configureCellData(movie:MovieModel) {
        lblTitle.text = movie.original_title
        
        if let posterURL = movie.poster_path {
            imgView.kf.setImage(with: URL(string: "\(Constants.ImageURL)\(posterURL)"), placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(.fade(1))],progressBlock: nil, completionHandler: nil)
        }
    }
}
