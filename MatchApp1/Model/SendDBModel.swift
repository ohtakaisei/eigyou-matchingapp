//
//  SendDBModel.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/10.
//

import Foundation
import Firebase

protocol ProfileSendDone {
    
    func profileSendDone()
}

protocol LikeSendDelegate {

    func like()
}

protocol GetAttachProtocol {
    func getAttachProtocol(attachImageString:String)
    }


class SendDBModel {
    
    let db = Firestore.firestore()
    var profileSendDone:ProfileSendDone?
    var likeSendDelegate:LikeSendDelegate?
    var getAttachProtocol:GetAttachProtocol?
    
//    プロフィールをFirestoreへ送信
    func sendProfileData(userData:UserDataModel,profileImageData:Data){
        
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImageData, metadata: nil) { metaData, error in
            
            if error != nil{
                print("エラー")
                return
                
            }
            
            imageRef.downloadURL{ url, error in
                
                if error != nil{
                    print("エラーにnil入ってる")
                    return
                    
                }
                
                if url != nil{
                    
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                        
                        ["name":userData.name as Any,"age":userData.age as Any,"price":userData.price as Any,"need":userData.need as Any,"industry":userData.industry as Any,"position":userData.position as Any,"profile":userData.profile as Any,"profileImageString":url?.absoluteString as Any,"uid":Auth.auth().currentUser!.uid as Any,"quickWord":userData.quickWord as Any,"hobby":userData.hobby as Any,"onlineORNot":userData.onlineORNot as Any]
                    
                    )
                    
                    KeyChainConfig.setKeyData(value: ["name":userData.name as Any,"age":userData.age as Any,"price":userData.price as Any,"need":userData.need as Any,"industry":userData.industry as Any,"position":userData.position as Any,"profile":userData.profile as Any,"profileImageString":url?.absoluteString as Any,"uid":Auth.auth().currentUser!.uid as Any,"quickWord":userData.quickWord as Any,"hobby":userData.hobby as Any], key: "userData")
                    
                    
                    
                    self.profileSendDone?.profileSendDone()
                }
            }
        }
    }
    
    func sendToLike(likeFlag:Bool,thisUserID:String){
        
        //まだlikeをしていない状態、再びlikeをする前
        if likeFlag == false{
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            //消す
            deleteToLike(thisUserID: thisUserID)
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
          
            //自分がlikeした人たちのID一覧
            print(ownLikeListArray.debugDescription)
            
            
        }else if likeFlag == true{
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true,"position":userData["position"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"price":userData["price"] as Any,"profileImageString":userData["profileImageString"] as Any,"industry":userData["industry"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"need":userData["need"] as Any,"hobby":userData["hobby"] as Any])

            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like":true,"position":userData["position"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"price":userData["price"] as Any,"profileImageString":userData["profileImageString"] as Any,"industry":userData["industry"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"need":userData["need"] as Any,"hobby":userData["hobby"] as Any])

            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            //likeが終わったよ
            self.likeSendDelegate?.like()
            
        }
        
    }
    
    func deleteToLike(thisUserID:String){
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).delete()
    }
    
    //いいねをされたリストからのいいねをする場合のメソッド
    
    func sendToLikeFromLike(likeFlag:Bool,thisUserID:String,matchName:String,matchID:String){
        
        if likeFlag == false{
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            
            
            deleteToLike(thisUserID: thisUserID)
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            
        }else if likeFlag == true{
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true,"position":userData["position"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"price":userData["price"] as Any,"profileImageString":userData["profileImageString"] as Any,"industry":userData["industry"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"need":userData["need"] as Any,"hobby":userData["hobby"] as Any])
            
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like":true,"position":userData["position"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"price":userData["price"] as Any,"profileImageString":userData["profileImageString"] as Any,"industry":userData["industry"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"need":userData["need"] as Any,"hobby":userData["hobby"] as Any])
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            //マッチングが成立した通知
            Util.matchNotification(name: matchName, id: matchID)
            
            deleteToLike(thisUserID: Auth.auth().currentUser!.uid)
            deleteToLike(thisUserID: matchID)
            
            
            self.db.collection("Users").document(matchID).collection("matching").document(matchID).delete()
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
            
            self.likeSendDelegate?.like()
            
        }
        
    }
    
    func sendToMatchingList(thisUserID:String,need:String,name:String,age:String,price:String,industry:String,position:String,profile:String,profileImageString:String,uid:String,quickWord:String,hobby:String,userData:[String:Any]){
        
        if thisUserID == uid{
            
            self.db.collection("Users").document(thisUserID).collection("matching").document(Auth.auth().currentUser!.uid).setData(
                
                ["position":userData["position"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"price":userData["price"] as Any,"profileImageString":userData["profileImageString"] as Any,"industry":userData["industry"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"need":userData["need"] as Any,"hobby":userData["hobby"] as Any]
            
            )
            
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
                ["position":position as Any,"uid":uid as Any,"age":age as Any,"price":price as Any,"profileImageString":profileImageString as Any,"industry":industry as Any,"name":name as Any,"quickWord":quickWord as Any,"profile":profile as Any,"need":need as Any,"hobby":hobby as Any]
            
            )
            
            
        }else{
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
                ["position":position as Any,"uid":uid as Any,"age":age as Any,"price":price as Any,"profileImageString":profileImageString as Any,"industry":industry as Any,"name":name as Any,"quickWord":quickWord as Any,"profile":profile as Any,"need":need as Any,"hobby":hobby as Any]
                
            )
        }
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        
        
    }
    
    func sendAshiato(aitenoUserID:String){
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        self.db.collection("Users").document(aitenoUserID).collection("ashiato").document(Auth.auth().currentUser!.uid).setData(["position":userData["position"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"price":userData["price"] as Any,"profileImageString":userData["profileImageString"] as Any,"industry":userData["industry"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"need":userData["need"] as Any,"hobby":userData["hobby"] as Any,"date":Date().timeIntervalSince1970])
    }
    
    func sendImageData(image:UIImage,senderID:String,toID:String){
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        let imageRef = Storage.storage().reference().child("ChatImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) { metaData, error in
            
            if error != nil{
                print("エラー")
                return
                
            }
            
            imageRef.downloadURL{ url, error in
                
                if error != nil{
                    print("エラーにnil入ってる")
                    return
                    
                }
                
                if url != nil{
                    
                    self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(
                        
                        ["senderID":Auth.auth().currentUser!.uid,"displayName":userData["name"] as Any,"imageURLString":userData["profileImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]
                    
                    )
                    
                    self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(
                        
                        ["senderID":Auth.auth().currentUser!.uid,"displayName":userData["name"] as Any,"imageURLString":userData["profileImageString"] as Any,"date":Date().timeIntervalSince1970,"attachImageString":url?.absoluteString as Any]
                    
                    )
                    
                    self.getAttachProtocol?.getAttachProtocol(attachImageString: url!.absoluteString)
                    
                }
            }
        }
    }
    
    func sendMessage(senderID:String,toID:String,text:String,displayName:String,imageURLString:String){
        
        self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(["text":text as Any,"senderID":senderID as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date":Date().timeIntervalSince1970]
        
        
        )
        
        
        self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(["text":text as Any,"senderID":Auth.auth().currentUser!.uid as Any,"displayName":displayName as Any,"imageURLString":imageURLString as Any,"date":Date().timeIntervalSince1970]
        
        )
        
        
        
    }
    
}
