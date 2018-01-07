//
//  Movie.swift
//  MovieApp
//
//  Created by Yerlan Ismailov on 07.01.2018.
//  Copyright © 2018 ismailov.com. All rights reserved.
//

import Foundation

struct Movies: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    
    let title: String
    let releaseDate: Date
    let posterPath: String
    
}
