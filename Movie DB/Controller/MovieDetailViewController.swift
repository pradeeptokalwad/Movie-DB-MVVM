//
//  MovieDetailViewController.swift
//  Movie DB
//
//  Created by webwerks on 6/23/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import UIKit
import SVProgressHUD

class MovieDetailViewController: UIViewController {

    lazy var lblTitle : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.33)
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.text = "Title"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lblBudgete : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.33)
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.text = "Budget"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var lblPopularity : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.33)
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.text = "Popular"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lblReleaseDate : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.33)
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.text = "Release"
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

    
    var movieID: Int = 0 {
        didSet {
            self.fetchMovieDetails(movieID: movieID)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imgView)
        view.addSubview(lblTitle)
        view.addSubview(lblBudgete)
        view.addSubview(lblPopularity)
        view.addSubview(lblReleaseDate)

        lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:5.0).isActive = true
        lblTitle.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 20.0).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20.0).isActive = true

        imgView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 10.0).isActive = true
        imgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 20.0).isActive = true
        imgView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20.0).isActive = true
        
        lblBudgete.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant:10.0).isActive = true
        lblBudgete.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        lblBudgete.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 20.0).isActive = true
        lblBudgete.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20.0).isActive = true

        lblPopularity.topAnchor.constraint(equalTo: lblBudgete.bottomAnchor, constant:10.0).isActive = true
        lblPopularity.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        lblPopularity.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 20.0).isActive = true
        lblPopularity.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20.0).isActive = true
        
        lblReleaseDate.topAnchor.constraint(equalTo: lblPopularity.bottomAnchor, constant:10.0).isActive = true
        lblReleaseDate.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-10.0).isActive = true
        lblReleaseDate.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        lblReleaseDate.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 20.0).isActive = true
        lblReleaseDate.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20.0).isActive = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchMovieDetails(movieID: Int) {
        
        SVProgressHUD.show(withStatus: "Fetching Details...")
        APIManager().getServiceRequest(path: "/movie/\(movieID)?api_key=\(Constants.APIKey)", params: nil, isAPIRequired: true, domain: .v3) { (status, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                guard let responseData = response as? JSONDict else {
                    return
                }
                
                
                let movieDetails:MovieDetailModel = MovieDetailModel(json: responseData)
                self.configureMovieData(movie: movieDetails)
            }
        }
    }
    
    func configureMovieData(movie:MovieDetailModel) {
        lblTitle.text = movie.title
        if let budget = movie.budget {
            lblBudgete.text = "Budget = $ \(budget)"
        }
        
        if let popular = movie.popularity {
            lblPopularity.text = "Popularity = \(popular)"
        }
        
        if let date = movie.release_date {
            lblReleaseDate.text = "Released on: \(date)"
        }

        if let posterURL = movie.poster_path {
            imgView.kf.setImage(with: URL(string: "\(Constants.ImageURL)\(posterURL)"),
                                placeholder: #imageLiteral(resourceName: "placeholder"),
                                options: [.transition(.fade(1))],
                                progressBlock: nil,
                                completionHandler: nil)
            
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
