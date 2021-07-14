//
//  ProfileDetailCell.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/10.
//

import UIKit

class ProfileDetailCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var needLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    
    
    
    
    static let identifire = "ProfileDetailCell"
    
    static func nib()->UINib{
        
        return UINib(nibName: "ProfileDetailCell", bundle: nil)
    }
    
    func configure(nameLabelString:String,ageLabelString:String,industryLabelString:String,priceLabelString:String,positionLabelString:String,needLabelString:String,hobbyLabelString:String){
        
        
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        industryLabel.text = industryLabelString
        priceLabel.text = priceLabelString
        positionLabel.text = positionLabelString
        needLabel.text = needLabelString
        hobbyLabel.text = hobbyLabelString
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
