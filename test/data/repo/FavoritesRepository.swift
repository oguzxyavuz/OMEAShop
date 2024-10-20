//
//  FavoritesRepository.swift
//  test
//
//  Created by Oğuzhan Yavuz on 18.10.2024.
//
import Foundation
import RxSwift

class FavoritesRepository {
    var favorites = BehaviorSubject<[urunler]>(value: [urunler]())
    let db: FMDatabase?

    init() {
        let targetWay = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbUrl = URL(fileURLWithPath: targetWay).appendingPathComponent("Favorites.db")
        db = FMDatabase(path: dbUrl.path)
        createTable()
    }

    private func createTable() {
        db!.open()
        do {
            try db?.executeUpdate("CREATE TABLE IF NOT EXISTS Favorites (id INTEGER PRIMARY KEY AUTOINCREMENT, ad TEXT, resim TEXT, kategori TEXT, fiyat INTEGER, marka TEXT)", values: nil)
        } catch {
            print("Table creation error: \(error.localizedDescription)")
        }
        db!.close()
    }

    func saveDb(ad: String, resim: String, kategori: String, fiyat: Int, marka: String) {
        db!.open()
        
        do {
            let result = try db!.executeQuery("SELECT * FROM Favorites WHERE ad = ?", values: [ad])
            if result.next() {
                print("Bu ürün zaten mevcut: \(ad)")
                db!.close()
                return
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }

        do {
            try db!.executeUpdate("INSERT INTO Favorites (ad, resim, kategori, fiyat, marka) VALUES (?,?,?,?,?)", values: [ad, resim, kategori, fiyat, marka])
            print("Kaydedildi")
        } catch {
            print("Eklenemedi: \(error.localizedDescription)")
        }
        
        db!.close()
    }


    func deleteDb(id: Int) {
        db!.open()
        do {
            try db!.executeUpdate("DELETE FROM Favorites WHERE id = ?", values: [id])
            print("Silindi")
        } catch {
            print("Silinemedi: \(error.localizedDescription)")
        }
        db!.close()
    }

    func getDb() {
        db!.open()
        do {
            var favorite = [urunler]()
            let result = try db!.executeQuery("SELECT * FROM Favorites", values: nil)
            while result.next() {
                let id = Int(result.int(forColumn: "id"))
                let ad = result.string(forColumn: "ad") ?? ""
                let resim = result.string(forColumn: "resim") ?? ""
                let kategori = result.string(forColumn: "kategori") ?? ""
                let fiyat = Int(result.int(forColumn: "fiyat"))
                let marka = result.string(forColumn: "marka") ?? ""

                let product = urunler(id: id, ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka)
                favorite.append(product)
            }
            favorites.onNext(favorite)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
        db!.close()
    }
    
    func isFavorite(ad: String) -> Bool {
        db!.open()
        defer { db!.close() }

        do {
            let result = try db!.executeQuery("SELECT * FROM Favorites WHERE ad = ?", values: [ad])
            return result.next()
        } catch {
            print("Error checking favorites: \(error.localizedDescription)")
            return false
        }
    }

}

