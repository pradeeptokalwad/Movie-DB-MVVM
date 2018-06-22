//
//  MovieViewModel.swift
//  Movie DB
//
//  Created by webwerks on 6/22/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import Foundation
import UIKit

class MovieViewModel: NSObject {
    
    var aryMovies:[MovieModel] = [MovieModel]()
    var total_pages: Int = 1

    func fetchFilterOptions(parameters:JSONDict, movies: @escaping ()->Void){
        APIManager().postServiceRequest(path: "/discover/movie", params: parameters, isAPIRequired: true, domain: .v3) { (status, response, error) in
            DispatchQueue.main.async {
                
                guard let responseData = response as? JSONDict else {
                    movies()
                    return
                }
                
                if let ary:[JSONDict] = responseData["results"] as? [JSONDict] {
                    let aryModel = (ary.map({MovieModel(json: $0)}) )
                    self.appendRecords(aryModels: aryModel)
                }
                
                if let total_pages = responseData["total_pages"] as? Int {
                    self.total_pages = total_pages
                }
                movies()
            }
        }
    }
    
    func appendRecords(aryModels: [MovieModel]) {
        self.aryMovies.append(contentsOf: aryModels)
    }
    
    func numberOfRows() -> Int {
        return aryMovies.count
    }
    
    func fetchMovieAtIndexPath(indexPath:IndexPath) -> MovieModel {
       return aryMovies[indexPath.row]
    }
    
    
}
