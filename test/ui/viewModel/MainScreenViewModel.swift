//
//  MainScreenViewModel.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import Foundation
import RxSwift

class MainScreenViewModel {
    
    var prepo = ProductsRepository()
    var productList = BehaviorSubject<[urunler]>(value: [urunler]())
    
    init() {
        getProducts()
        productList = prepo.productList
    }
    
    func getProducts() {
        prepo.getProducts()
    }
    
}
