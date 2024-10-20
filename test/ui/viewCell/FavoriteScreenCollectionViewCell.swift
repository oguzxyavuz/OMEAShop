//
//  FavoriteScreenCollectionViewCell.swift
//  test
//
//  Created by Oğuzhan Yavuz on 18.10.2024.
//

import UIKit

class FavoriteScreenCollectionViewCell: UICollectionViewCell {
    
    var productId: Int?
    
    @IBOutlet var labelAdFavorite: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
        
    
}
