//
//  RSSParser.swift
//  PHS App
//
//  Created by Patrick Cui on 8/29/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

class NewsArticle: NSObject {
    
    var title = String()
    var link = String()
    var pubDate = Date()
    var author = String()
    var category1 = String()
    var category2: String?
    var category3: String?
    var content = String()
    var image: UIImage?
    var imageLink: URL?
    
}
