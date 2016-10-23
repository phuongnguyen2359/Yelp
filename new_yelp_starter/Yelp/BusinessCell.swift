//
//  BusinessCell.swift
//  Yelp
//
//  Created by Pj Nguyen on 10/19/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewCountLable: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var categoryLable: UILabel!
    
    var business: Business!{
        didSet{
            nameLable.text = business.name
            restaurantImage.setImageWith(business.imageURL!)
            distanceLable.text = business.distance
            reviewImage.setImageWith(business.ratingImageURL!)
            addressLable.text = business.address
            categoryLable.text = business.categories
        }
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
