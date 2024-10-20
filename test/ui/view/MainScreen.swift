//
//  ViewController.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import UIKit
import Kingfisher

class MainScreen: UIViewController {
    
    var productList = [urunler]()
    var viewModel = MainScreenViewModel()
    var prepo = ProductsRepository()

    @IBOutlet var collectionViewMain: UICollectionView!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//collectionView ayarları
        let cv = UICollectionViewFlowLayout()
        cv.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cv.minimumInteritemSpacing = 10
        cv.minimumLineSpacing = 10
        let size = UIScreen.main.bounds.width
        let width = (size - 30) / 2
        cv.itemSize = CGSize(width: width, height: width * 1.7)
        collectionViewMain.collectionViewLayout = cv
        
//sıralama
    let menuClosure = {(action: UIAction) in
        self.titles(number: action.title)
        }
        sortButton.menu = UIMenu(children: [
            UIAction(title: "Fiyata Göre Artan",handler:menuClosure),
            UIAction(title: "Fiyata Göre Azalan", handler: menuClosure),
            UIAction(title: "A'dan Z'ye Sırala", handler: menuClosure),
            UIAction(title: "Z'den A'ya Sırala", handler: menuClosure),
        ])
        
        collectionViewMain.delegate = self
        collectionViewMain.dataSource = self
        reloadView()
        viewModel.getProducts()
     
//funcs--------------------------------------------
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let product = sender as? urunler {
                let targetVC = segue.destination as! DetailScreen
                targetVC.product = product
            }
        }
    }
//ürünleri gösterme
    func reloadView() {
        _ = viewModel.productList.subscribe(onNext: { list in
            self.productList = list
            DispatchQueue.main.async {
                self.collectionViewMain.reloadData()
            }
        })
    }
    
    
    func titles(number: String) {
        if number == "Fiyata Göre Artan" {
            productList.sort(by: { $0.fiyat! < $1.fiyat! })
            collectionViewMain.reloadData()
        }
        if number == "Fiyata Göre Azalan" {
            productList.sort(by: { $0.fiyat! > $1.fiyat! })
            collectionViewMain.reloadData()
        }
        if number == "A'dan Z'ye Sırala" {
            productList.sort(by: { $0.ad! < $1.ad! })
            collectionViewMain.reloadData()
        }
        if number == "Z'den A'ya Sırala" {
            productList.sort(by: { $0.ad! > $1.ad! })
            collectionViewMain.reloadData()
        }
    }

}

//exts-----------------------------------------

extension MainScreen: UISearchBarDelegate {
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Ara..."
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.getProducts()
        } else {
            do {
                productList = try viewModel.productList.value().filter { product in
                    product.ad!.lowercased().contains(searchText.lowercased())
                }
                collectionViewMain.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        viewModel.getProducts()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}

extension MainScreen : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionMain", for: indexPath) as! MainScreenCollectionViewCell
        
        let product = productList[indexPath.row]
        cell.labelAd.text = product.ad
        cell.labelFiyat.text = "\(product.fiyat!) TL"
        
        if let imageName = product.resim, !imageName.isEmpty,
           let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)") {
            cell.imageMain.kf.setImage(with: url)
        } else {
            print("Geçersiz resim ismi: \(product.resim ?? "nil")")
        }
        
        cell.layer.borderColor = UIColor(named: "button")?.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productList[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: product)
    }
    
}
    

