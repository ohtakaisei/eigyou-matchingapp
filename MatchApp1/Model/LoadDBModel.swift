//
//  LoadDBModel.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/10.
//

import Foundation
import Firebase

protocol GetProfileDataProtocol {

    func getProfileData(userDataModelArray:[UserDataModel])

}

protocol GetLikeCountProtocol {
    func getLikeCount(likeCount:Int,likeFlag:Bool)
}

protocol GetLikeDataProtocol {
    func getLikeDataProtocol(userDataModelArray:[UserDataModel])
}

protocol GetWhoisMatchListProtocol {
    func getWhoisMatchListProtocol(userDataModelArray:[UserDataModel])
}

protocol GetAshiatoDataProtocol {
    func getAshiatoDataProtocol(userDataModelArray:[UserDataModel])
    
    }


class LoadDBModel {
    
    var db = Firestore.firestore()
    var profileModelArray = [UserDataModel]()
    var getProfileDataProtcol:GetProfileDataProtocol?
    var getLikeCountProtocol:GetLikeCountProtocol?
    var getLikeDataProtocol:GetLikeDataProtocol?
    var getWhoisMatchListProtocol:GetWhoisMatchListProtocol?
    var getAshiatoDataProtocol:GetAshiatoDataProtocol?
    
    
    var matchingIDArray = [String]()
    
    
    //        ユーザーデータを受信する
    func loadUserProfile(position:String){
        
        db.collection("Users").whereField("position", isNotEqualTo: position).addSnapshotListener{ snapShot, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents
            {
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let price = data["price"] as? String,let need = data["need"] as? String,let industry = data["industry"] as? String,let hobby = data["hobby"] as? String,let position = data["position"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let quickWord = data["quickWord"] as? String,let uid = data["uid"] as? String,let onlineORNot = data["onlineORNot"] as? Bool{
                        
                        
                        let userDataModel = UserDataModel(name: name, age: age, price: price, need: need, industry: industry, position: position, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, hobby: hobby, date:0, onlineORNot: onlineORNot)
                        
                    
                        self.profileModelArray.append(userDataModel)
                        print("aaaaa")
                    }
                }
               
                self.getProfileDataProtcol?.getProfileData(userDataModelArray: self.profileModelArray)
                
            }
        }
            
    }
    
    //likeの数を取得する
    
    func loadLikeCount(uuid:String){
        var likeFlag = Bool()
        db.collection("Users").document(uuid).collection("like").addSnapshotListener{snapShot, error in
            
            if error != nil{
                return
            }
        
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    if doc.documentID == Auth.auth().currentUser?.uid{
                        if let like = data["like"] as? Bool{
                            
                            likeFlag = like
                            
                        }
                    }
                }
                
                let docCount = snapShotDoc.count
                self.getLikeCountProtocol?.getLikeCount(likeCount: docCount, likeFlag: likeFlag)
                
            }
        }
    }
    
    func loadLikeList(){
        
//        self.profileModelArray = []
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").addSnapshotListener{ snapShot, error in
        
        
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents
            {
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let price = data["price"] as? String,let need = data["need"] as? String,let industry = data["industry"] as? String,let hobby = data["hobby"] as? String,let position = data["position"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let quickWord = data["quickWord"] as? String,let uid = data["uid"] as? String{
                        
                        
                        let userDataModel = UserDataModel(name: name, age: age, price: price, need: need, industry: industry, position: position, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, hobby: hobby, date:0, onlineORNot: true)
                        
                    
                        self.profileModelArray.append(userDataModel)
                       
                    }
                }
               
                self.getLikeDataProtocol?.getLikeDataProtocol(userDataModelArray: self.profileModelArray)
                
            }
        }
    }
    
    //matching以下のデータ(人)を取得する
    func loadMatchingPersonData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").addSnapshotListener{ snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,let age = data["age"] as? String,let price = data["price"] as? String,let need = data["need"] as? String,let industry = data["industry"] as? String,let hobby = data["hobby"] as? String,let position = data["position"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let quickWord = data["quickWord"] as? String,let uid = data["uid"] as? String{
                        
                        //idを取得、比較、idがない場合はそのidの名前でnotificationを出す
                        self.matchingIDArray = KeyChainConfig.getKeyArrayListData(key: "matchingID")
                        
                        //このidを含んでいないなら
                        if self.matchingIDArray.contains(where: {$0 == uid}) == false{
                            
                            if uid == Auth.auth().currentUser?.uid{
                                
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                                
                            }else{
                            
                            Util.matchNotification(name: name, id: uid)
                                
                            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                            
                            self.matchingIDArray.append(uid)
                            KeyChainConfig.setKeyArrayData(value: self.matchingIDArray, key: "matchingID")
                                
                            }
                        }
                        
                        let userDataModel = UserDataModel(name: name, age: age, price: price, need: need, industry: industry, position: position, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, hobby: hobby, date: 0, onlineORNot: true)
                        self.profileModelArray.append(userDataModel)
                    }
                }
                
                self.getWhoisMatchListProtocol?.getWhoisMatchListProtocol(userDataModelArray: self.profileModelArray)
                
            }
        }
        
    }
    
    func loadAshiatoData(){
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ashiato").order(by: "date").addSnapshotListener{snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                self.profileModelArray = []
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    
                    if let name = data["name"] as? String,let age = data["age"] as? String,let price = data["price"] as? String,let need = data["need"] as? String,let industry = data["industry"] as? String,let hobby = data["hobby"] as? String,let position = data["position"] as? String,let profile = data["profile"] as? String,let profileImageString = data["profileImageString"] as? String,let quickWord = data["quickWord"] as? String,let uid = data["uid"] as? String,let date = data["date"] as? Double{
                            
                        let userDataModel = UserDataModel(name: name, age: age, price: price, need: need, industry: industry, position: position, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, hobby: hobby, date: date, onlineORNot: true)
                        self.profileModelArray.append(userDataModel)
                    
                    }
                    
                    
                }
                
                self.getAshiatoDataProtocol?.getAshiatoDataProtocol(userDataModelArray: self.profileModelArray)
            }
            
        }
    }
    
}
