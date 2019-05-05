//
//  CustomTableViewCell.swift
//  Assignment
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {
    
    // Variables
    var imageIconView: UIImageView?
    var descriptionLabel: UILabel?
    var deliveryModel: DeliveryItemModel? {
        didSet {
            descriptionLabel?.text = deliveryModel?.descriptionText
            if let _ = deliveryModel?.imageUrl {
                imageIconView?.sd_setImage(with: URL.init(string: deliveryModel?.imageUrl ?? ""), completed: nil)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Functions
    func setupUI() {
        // Image
        imageIconView = UIImageView()
        imageIconView?.contentMode = .scaleAspectFill
        imageIconView?.clipsToBounds = true
        self.addSubview(imageIconView!)
        
        // Label
        descriptionLabel = UILabel()
        descriptionLabel?.font = AppTheme.Font.deliveryListViewCellFont
        self.descriptionLabel?.numberOfLines = 0
        self.descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel?.text = nil
        self.descriptionLabel?.contentMode = .topLeft
        self.addSubview(descriptionLabel!)
        
        self.imageIconView?.addAnchorConstraint(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: CGFloat(Constants.ImageDimension.kCellImageWidth), height: CGFloat(Constants.ImageDimension.kCellImageHeight), enableInsets: false)
        self.descriptionLabel?.addAnchorConstraint(top: self.imageIconView?.topAnchor, left: self.imageIconView?.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
        self.descriptionLabel?.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(Constants.ImageDimension.kCellImageWidth)).isActive = true
        
        self.accessoryType = .disclosureIndicator
    }
}
