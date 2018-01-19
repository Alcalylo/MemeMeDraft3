//
//  MemeStructure.swift
//  MemeMeDraft3
//
//  Created by ALCALY LO on 1/4/18.
//  Copyright © 2018 ALCALY LO. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText : String
    var bottomText : String
    var memeOriginal : UIImage
    var memedImage : UIImage
    
    init (topText: String, bottomText: String, memeOriginal: UIImage, memedImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.memeOriginal = memeOriginal
        self.memedImage = memedImage
    }
}
