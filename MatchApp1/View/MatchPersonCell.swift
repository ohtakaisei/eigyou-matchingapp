//
//  MatchPersonCell.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/13.
//

import UIKit

class MatchPersonCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    
    static let identifier = "MatchPersonCell"
    
    static func nib()->UINib{
        
        return UINib(nibName: "MatchPersonCell", bundle: nil)
    }
    
    func configure(nameLabelString:String,ageLabelString:String,industryLabelString:String,profileImageViewString:String){
        
        
        userNameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        industryLabel.text = industryLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed:nil)
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
