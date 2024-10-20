//
//  DetailScreen.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import UIKit
import Kingfisher

class DetailScreen: UIViewController {
    
    var product:urunler?
    var products:urunler_sepeti?
    var viewModel = DetailScreenViewModel()
    var frepo = FavoritesRepository()

    @IBOutlet var labelStepper: UILabel!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet weak var labelKategoriDetail: UILabel!
    @IBOutlet weak var labelMarkaDetail: UILabel!
    @IBOutlet weak var labelFiyatDetail: UILabel!
    @IBOutlet weak var ImageViewDetail: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//navigation left ok button
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.left.fill"), style: .plain, target: self, action: #selector(goMain))
        leftButton.tintColor = UIColor(named: "button")
        self.navigationItem.leftBarButtonItem = leftButton
        self.title = "\(product!.ad!)"
        

        if let p = product {
            labelFiyatDetail.text = "\(p.fiyat!) TL"
            labelMarkaDetail.text = p.marka
            labelKategoriDetail.text = p.kategori
            
            if let imageName = p.resim, !imageName.isEmpty,
               let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
                self.ImageViewDetail.kf.setImage(with: url)
            } else {
                print("Geçersiz resim ismi: \(p.resim ?? "nil")")
            }
        }
        
        labelStepper.text = String(Int(stepper.value))
        
//funcs----------------------------------------------
        
    }
    @IBAction func stepperValue(_ sender: UIStepper) {
        labelStepper.text = String(Int(sender.value))
    }
    
    @objc func goMain() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        
        if let count = Int(labelStepper.text!){ // Optional binding ile resim kontrolü
               
        viewModel.addBag(ad: (product?.ad)!, resim: (product?.resim)!, kategori: (product?.kategori)!, fiyat:(product?.fiyat)!, marka:(product?.marka)!, siparisAdeti:count, kullaniciAdi: "oguzhan_yavuz")
        
            let alert = UIAlertController(title: "Sepete Eklendi", message: "\(labelStepper!.text!) Adet \(product!.ad!) Sepete eklendi", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
               
        } else {
            print("Eksik veya geçersiz bilgiler.")
        }
    }
    
    @IBAction func addFavorites(_ sender: Any) {
        guard let product = product else { return }
        
        if frepo.isFavorite(ad: product.ad!) {
            let alert = UIAlertController(title: "Uyarı", message: "\(product.ad!) zaten favorilerinizde", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            frepo.saveDb(ad: product.ad!, resim: product.resim!, kategori: product.kategori!, fiyat: product.fiyat!, marka: product.marka!)
            
            let alert = UIAlertController(title: "Eklendi", message: "\(product.ad!) Favorilere eklendi", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
