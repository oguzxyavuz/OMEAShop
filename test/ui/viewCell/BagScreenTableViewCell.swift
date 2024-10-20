//
//  BagScreenTableViewCell.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import UIKit

class BagScreenTableViewCell: UITableViewCell {
    
    var sepetId : Int?
    var siparisAdeti: Int?
    
    var product = ProductsRepository()
    var productList = BagRepository()
    var viewModel = BagScreenViewModel()
    var view = BagScreen()
    var ds = DetailScreen()
    
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var labelMarkaBag: UILabel!
    @IBOutlet weak var labelFiyatBag: UILabel!
    @IBOutlet weak var labelAdBag: UILabel!
    @IBOutlet weak var imageViewBag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewBag.isHidden = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
        
    
    

