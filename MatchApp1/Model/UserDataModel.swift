//
//  UserDataModel.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/09.
//

import Foundation

//比較可能なプロトコルに準拠させておく
struct UserDataModel:Equatable {
    
    
    let name:String?
    let age:String?
    let price:String?
    let need:String?
    let industry:String?
    let position:String?
    let profile:String?
    let profileImageString:String?
    let uid:String?
    let quickWord:String?
    let hobby:String?
    let date:Double?
    let onlineORNot:Bool?
    
}
