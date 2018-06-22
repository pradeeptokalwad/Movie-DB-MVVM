//
//  MovieModel.swift
//  Movie DB
//
//  Created by webwerks on 6/22/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import Foundation

class MovieModel {
    
    var movieId: Int?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
    var vote_count: Int?

    init(json: JSONDict) {
        
        if let original_language = json["original_language"] as? String {
            self.original_language = original_language
        }
        
        if let movieId = json["id"] as? Int {
            self.movieId = movieId
        }
        
        if let original_title = json["original_title"] as? String {
            self.original_title = original_title
        }
        
        if let overview = json["overview"] as? String {
            self.overview = overview
        }
        
        if let popularity = json["popularity"] as? String {
            self.popularity = popularity
        }
        
        if let poster_path = json["poster_path"] as? String {
            self.poster_path = poster_path
        }
        
        if let release_date = json["release_date"] as? String {
            self.release_date = release_date
        }
        
        if let vote_average = json["vote_average"] as? Double {
            self.vote_average = vote_average
        }
        
        if let vote_count = json["vote_count"] as? Int {
            self.vote_count = vote_count
        }

    }
    
}
