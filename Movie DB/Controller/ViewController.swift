//
//  ViewController.swift
//  Movie DB
//
//  Created by webwerks on 6/22/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    var vmMovies:MovieViewModel = MovieViewModel()
    var pageNumber: Int = 1

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: "MovieListCollectionViewCell")

        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Movies List"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        refreshData()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        
        SVProgressHUD.show(withStatus: "Please wait...")

        let parameters: JSONDict = [
            "api_key": "\(Constants.APIKey)" as AnyObject,
            "sort_by": "popularity.desc",
            "page": pageNumber
        ]
        vmMovies.fetchFilterOptions(parameters: parameters) {            
            SVProgressHUD.dismiss()

            self.collectionView.reloadData()
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmMovies.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        cell.configureCellData(movie: vmMovies.fetchMovieAtIndexPath(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movieDetails:MovieDetailViewController = MovieDetailViewController()
        if let movieID = vmMovies.fetchMovieAtIndexPath(indexPath: indexPath).movieId {
            movieDetails.movieID = movieID
        }
        self.navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.size.width-10)/2, height:(collectionView.frame.size.width-10)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == vmMovies.numberOfRows() - 1 && pageNumber < vmMovies.total_pages {
            pageNumber += 1
            refreshData()
        }
        
    }
}

