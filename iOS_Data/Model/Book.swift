//
//  Book.swift
//  iOS_Data
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 Karan. All rights reserved.
//

import Foundation

class Book {
    internal init(title: String, author: String, page: Int, year: Int) {
        self.title = title
        self.author = author
        self.page = page
        self.year = year
    }
    
    var title : String
    var author: String
    var page : Int
    var year : Int
}
