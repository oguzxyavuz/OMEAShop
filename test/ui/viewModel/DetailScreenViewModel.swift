//
//  DetailScreenViewModel.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import Foundation
import RxSwift

class DetailScreenViewModel {
    
    var prepo = ProductsRepository()
    var frepo = FavoritesRepository()
    
    func addBag(ad:String,resim:String,kategori:String,fiyat:Int,marka:String,siparisAdeti:Int,kullaniciAdi:String) {
        prepo.addBag(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
    func saveDb(ad:String,resim:String,kategori:String,fiyat:Int,marka:String) {
        frepo.saveDb(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka)
    }
    
}
