//
//  BagScreen.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import UIKit
import Kingfisher

class BagScreen: UIViewController {
    
    var productList = [urunler_sepeti]()
    var viewModel = BagScreenViewModel()
    var brepo = BagRepository()
    
    @IBOutlet var labelTutar: UILabel!
    @IBOutlet weak var bagTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bagTableView.delegate = self
        bagTableView.dataSource = self
        reloadView()
        viewModel.getBag(kullaniciAdi: "oguzhan_yavuz")
        updateTotalPrice()


        
//func-------------------
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getBag(kullaniciAdi: "oguzhan_yavuz")
    }
    
    func deleteBag(sepetId:Int,kullaniciAdi: String){
        viewModel.deleteBag(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
        viewModel.getBag(kullaniciAdi: kullaniciAdi)
    }
    
    func reloadView() {
        _ = viewModel.productList.subscribe(onNext: { list in
            self.productList = list
            DispatchQueue.main.async {
                self.bagTableView.reloadData()
                self.updateTotalPrice()
            }
        })
    }
    
    func updateTotalPrice() {
        let totalPrice = productList.reduce(0) { $0 + ($1.fiyat! * $1.siparisAdeti!) }
        labelTutar.text = "\(totalPrice)TL"
    }
    
    @IBAction func siparisButton(_ sender: Any) {
        let alert = UIAlertController(title: "Siparişiniz Oluşturuldu", message: "Alışverişiniz için teşekkürler!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}

// exts-------------------------------------------------

extension BagScreen : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagTableView", for: indexPath) as! BagScreenTableViewCell
        let product = productList[indexPath.row]
        
        cell.labelAdBag.text = "Ad: \(product.ad!)"
        cell.labelFiyatBag.text = "Fiyat: \(product.fiyat! * product.siparisAdeti!) TL"
        cell.labelMarkaBag.text = "Marka: \(product.marka!)"
        cell.sepetId = product.sepetId
        cell.labelAdet.text = "Adet: \(product.siparisAdeti!)"
        
        if let imageName = product.resim, !imageName.isEmpty,
           let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            cell.imageViewBag.kf.setImage(with: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bagTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delAction = UIContextualAction(style: .destructive, title: "Sil"){ [self] contextualAction,view,bool in
            let products = self.productList[indexPath.row]
            
            let alert = UIAlertController(title: "Almak istediğiniz ürün silinsin mi?", message: "\(productList[indexPath.row].ad!) sepetten silinsin mi?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(deleteAction)
            
            let okAction = UIAlertAction(title: "Evet", style: .destructive){ action in
                self.deleteBag(sepetId: products.sepetId!, kullaniciAdi: "oguzhan_yavuz")
                DispatchQueue.main.async {
                    self.viewModel.getBag(kullaniciAdi: "oguzhan_yavuz")
                    self.reloadView()
                }
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }

        return UISwipeActionsConfiguration(actions: [delAction])
    }

}
    

