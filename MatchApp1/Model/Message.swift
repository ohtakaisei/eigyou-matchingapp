//
//  Message.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/13.
//

import Foundation
import MessageKit

struct Message:MessageType {
    
    //必須
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    //必須ではない
    var userImagePath:String
    var date:TimeInterval
    var messageImageString:String
    
    
    
}

struct ImageMediaItem:MediaItem {
    
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(image:UIImage){
        
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        
        
    }
    
    init(imageURL:URL){
        
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
