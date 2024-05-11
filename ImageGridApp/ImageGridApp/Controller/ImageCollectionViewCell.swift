//
//  ImageCollectionViewCell.swift
//  ImageGridApp
//
//  Created by NFC User on 10/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageGrid: UIImageView!
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 5.0
        outerView.layer.masksToBounds = true
        layer.masksToBounds = false
    }
    
}
