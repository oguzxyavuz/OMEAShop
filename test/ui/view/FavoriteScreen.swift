//
//  FavoriteScreen.swift
//  test
//
//  Created by Oğuzhan Yavuz on 18.10.2024.
//

import UIKit
import Kingfisher

class FavoriteScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionViewFavorites: UICollectionView!
    var products = [urunler]()
    var viewModel = FavoriteScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFavorites.delegate = self
        collectionViewFavorites.dataSource = self
        reloadView()
        
    }
    
//funcs--------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getDb()
        reloadView()
    }
    
    func reloadView() {
        _ = viewModel.products.subscribe(onNext: { list in
            self.products = list
            DispatchQueue.main.async {
                self.collectionViewFavorites.reloadData()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteScreenCollectionViewCell
                
        let product = products[indexPath.row]
        if let imageName = product.resim, !imageName.isEmpty,
           let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            cell.favoriteImageView.kf.setImage(with: url)
        } else {
            print("Geçersiz resim ismi: \(product.resim ?? "nil")")
        }
        cell.labelAdFavorite.text = product.ad
        cell.productId = product.id
        
        cell.layer.borderColor = UIColor.systemCyan.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        cell.removeButton.addTarget(self, action: #selector (removeFavorites(_:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row
        
        return cell
        
    }
    
    @objc func removeFavorites(_ sender: UIButton) {
        let index = sender.tag
        let product = products[index]
        viewModel.deleteDb(id: product.id!)
        viewModel.getDb()
    }

}
