//
//  FavortieScreenViewModel.swift
//  test
//
//  Created by Oğuzhan Yavuz on 18.10.2024.
//

import Foundation
import RxSwift

class FavoriteScreenViewModel {
    
    var frepo = FavoritesRepository()
    var products = BehaviorSubject<[urunler]>(value: [urunler]())
    
    init() {
        copyDb()
        getDb()
        products = frepo.favorites
    }
    
    func getDb() {
        frepo.getDb()
    }
    
    func deleteDb(id:Int) {
        frepo.deleteDb(id: id)
        getDb()
    }
    
    func copyDb() {
        let bundleWay = Bundle.main.path(forResource: "Favorites", ofType: ".db")
        let targetWay = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let toCopy = URL(fileURLWithPath: targetWay).appendingPathComponent("Favorites.db")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: toCopy.path){
            print("Veritabanı zaten var")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleWay!, toPath: toCopy.path)
            }catch{}
        }
    }
}
