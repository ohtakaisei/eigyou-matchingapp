//
//  LikeProfileCell.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/12.
//

import UIKit
import SDWebImage

class LikeProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var quickWordLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    var userData = [String:Any]()
    var uid = String()
    static let identifier = "LikeProfileCell"
    var profileImageViewString = String()
    
    @IBOutlet weak var likeButton: UIButton!
    
    static func nib()->UINib{
        
        return UINib(nibName: "LikeProfileCell", bundle: nil)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        //いいねを飛ばす
        let sendDBModel = SendDBModel()
        sendDBModel.sendToLikeFromLike(likeFlag: true, thisUserID: self.uid, matchName: nameLabel.text!, matchID: self.uid)
        
        //ここでいいねをしているということは、マッチング成立ということ
        print(self.uid)
        print(self.userData["uid"].debugDescription)
        
        //いいねした時マッチング成立
//        sendDBModel.sendToMatchingList(thisUserId: self.uid, need: self.userData["need"] as! String, name: self.userData["name"] as! String, age: self.userData["age"] as! String, price: self.userData["price"] as! String, industry: self.userData["industry"] as! String, position: self.userData["position"] as! String, profile: self.userData["profile"] as! String, profileImageString: self.userData["profileImageString"] as! String, uid: self.userData["uid"] as! String, quickWord: self.userData["quickWord"] as! String, hobby: self.userData["hobby"] as! String, userData: self.userData)
        
        sendDBModel.sendToMatchingList(thisUserID: self.uid, need: needLabel.text!, name: nameLabel.text!, age: ageLabel.text!, price: priceLabel.text!, industry: industryLabel.text!, position: positionLabel.text!, profile: "後で外部引数で追加", profileImageString: self.profileImageViewString, uid: self.uid, quickWord: quickWordLabel.text!, hobby: hobbyLabel.text!, userData: self.userData)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(nameLabelString:String,ageLabelString:String,industryLabelString:String,priceLabelString:String,positionLabelString:String,needLabelString:String,hobbyLabelString:String,quickWordLabelString:String,profileImageViewString:String,uid:String,userData:[String:Any]){
        
        
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        industryLabel.text = industryLabelString
        priceLabel.text = priceLabelString
        positionLabel.text = positionLabelString
        needLabel.text = needLabelString
        hobbyLabel.text = hobbyLabelString
        quickWordLabel.text = quickWordLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed:nil)
        self.uid = uid
        self.userData = userData
        self.profileImageViewString = profileImageViewString
        
        Util.rectButton(button: likeButton)
        
        
    }
    
    
}
