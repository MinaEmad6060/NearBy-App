//
//  TableViewCell.swift
//  NearByApp
//
//  Created by Mina Emad on 25/05/2024.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBOutlet weak var placeName: UILabel!
    
    
    @IBOutlet weak var placeCategory: UILabel!
    
    
    @IBOutlet weak var placeAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
