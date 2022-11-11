//
//  PageModel.swift
//  Pinch
//
//  Created by Philip Al-Twal on 10/13/22.
//

import Foundation


struct Page: Identifiable {
    let id: Int
    let imageName: String
}


extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
