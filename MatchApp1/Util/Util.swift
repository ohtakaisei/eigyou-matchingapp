//
//  Util.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/09.
//

import Foundation
import UIKit
import Hex
import Lottie
import ImpressiveNotifications

class Util {
    
    static func price()->[Int]{
        return
            [1000,10000,50000,100000,500000,1000000,2000000]
    }
    
    static func industry()->[String]{
        return
            ["転職・求人","士業","教育・習い事","投資・M&A","不動産・建築","不動産・物品賃貸","家事・生活","スキルシェア","その他"]
    }
    
    static func rectButton(button:UIButton){
        
//        色を統一するメソッド
        button.layer.cornerRadius = 5.0
        button.backgroundColor = UIColor(hex:"#42c4cc")
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    static func starAnimation(name:String,view:UIView){
        
        let animationView = AnimationView()
        
        let animation = Animation.named(name)
        animationView.frame = view.bounds
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play { finishd in
            
            if finishd{
                animationView.removeFromSuperview()
            }
        }
        
    }
    
    //通知アクション
    static func matchNotification(name:String,id:String){
        
        INNotifications.show(type: .success, data: INNotificationData(title: "\(name)さんとマッチングしました!", description: "さっそくメッセージしてみろい！", image: UIImage(named: "match"), delay: 3, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .cyan, titleColor: .white, descriptionColor: .purple, imageSize: CGSize(width: 100.0, height: 100.0)))
    }
    
    static func serChatColor(jibun:Bool)->UIColor{
        
        if jibun == true{
        let chatColor = UIColor(hex: "#42c4cc")
        return chatColor
    }else{
    
        let chatColor = UIColor(hex: "#eceef")
        return chatColor
    }
}

}
