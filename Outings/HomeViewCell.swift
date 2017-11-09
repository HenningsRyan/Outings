//
//  HomeViewCell.swift
//  Outings
//
//  Created by Ryan Hennings on 11/9/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {

    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var outingInfoLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
//    let mapCell0 = mapCell(mapImage: #imageLiteral(resourceName: "backImage"), username: "Ryan", date: "01/21/18", info: "Custom cell asdl dafl adlldaf adklf dk dkf akdf df dfk")
    
//    var cellData: mapCell? {
//        didSet { updateUI() }
//    }
    
    func updateUI(outing: Outing) {
        mapImageView?.image = #imageLiteral(resourceName: "backImage")
        mapImageView.layer.cornerRadius = 10.0
        mapImageView.clipsToBounds = true
        usernameLabel?.text = outing.username
        userIcon.image = #imageLiteral(resourceName: "user")
        dateLabel.text = outing.date
        outingInfoLabel.text = outing.info
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
