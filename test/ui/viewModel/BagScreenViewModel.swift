//
//  BagScreenViewModel.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import Foundation
import RxSwift


class BagScreenViewModel {
    
    var sepetId: Int?
    
    var brepo = BagRepository()
    var productList = BehaviorSubject<[urunler_sepeti]>(value: [urunler_sepeti]())

    init() {
        getBag(kullaniciAdi: "oguzhan_yavuz")
        productList = brepo.productList
    }

    func getBag(kullaniciAdi: String) {
        brepo.getBag(kullaniciAdi: kullaniciAdi)

    }
    
    func deleteBag(sepetId: Int, kullaniciAdi: String) {
        brepo.deleteBag(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
            getBag(kullaniciAdi: kullaniciAdi)
    }
}









