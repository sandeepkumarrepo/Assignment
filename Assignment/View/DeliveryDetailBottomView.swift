//
//  DeliveryDetailBottomView.swift
//  Assignment
//
//  Created by Sandeep Kumar on 18/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit

class DeliveryDetailBottomView: UIView {
    
    var imageView: UIImageView?
    var descriptionLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeViews()
    }
    
    func initializeViews() {
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        descriptionLabel = UILabel()
        
        guard let imageView = imageView, let descriptionLabel = descriptionLabel else { return }
        
        addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(Constants.ImageDimension.kCellImageHeight)).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(Constants.ImageDimension.kCellImageWidth)).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = AppTheme.Font.deliveryListViewCellFont
        
        setAutoresizingMaskIntoConstraintsForAllSubviews()
    }
    
}
