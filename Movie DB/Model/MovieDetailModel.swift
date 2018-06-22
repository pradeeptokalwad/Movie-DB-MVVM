//
//  MovieDetailModel.swift
//  Movie DB
//
//  Created by webwerks on 6/23/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import Foundation

class MovieDetailModel {
    
    var budget: Double?
    var popularity: Double?
    var release_date: String?
    var overview: String?
    var title: String?
    var poster_path: String?

    init(json: JSONDict) {

        if let title = json["title"] as? String {
            self.title = title
        }
        
        if let poster_path = json["poster_path"] as? String {
            self.poster_path = poster_path
        }
        
        if let overview = json["overview"] as? String {
            self.overview = overview
        }
        
        if let budget = json["budget"] as? Double {
            self.budget = budget
        }
        
        if let popularity = json["popularity"] as? Double {
            self.popularity = popularity
        }
        
        if let release_date = json["release_date"] as? String {
            self.release_date = release_date
        }
    }
}
