//
//  DropCell.swift
//  Yelp
//
//  Created by Pj Nguyen on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol DropCellDelegate {
    @objc optional func dropCell(dropCell: DropCell, didClick imageClicked: UIImage)
}

class DropCell: UITableViewCell {

    @IBOutlet weak var dropLable: UILabel!
    @IBOutlet weak var dropImage: UIImageView!
    var delegate: DropCellDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if delegate != nil {
            //print("clicked image \(dropImage.image!) = = \(selected)")
            delegate.dropCell!(dropCell: self, didClick: dropImage.image!)
        }
    }

}
