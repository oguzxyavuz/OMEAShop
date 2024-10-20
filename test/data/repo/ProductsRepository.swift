//
//  ProductsRepository.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import Foundation
import RxSwift
import Alamofire

class ProductsRepository {
    
    var productList = BehaviorSubject<[urunler]>(value: [urunler]())
    var productListe = BehaviorSubject<[urunler_sepeti]>(value: [urunler_sepeti]())
    
    func addBag(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        
        let params: Parameters = [
            "ad": ad,
            "resim": resim,
            "kategori": kategori,
            "fiyat": fiyat,
            "marka": marka,
            "siparisAdeti": siparisAdeti,
            "kullaniciAdi": kullaniciAdi
        ]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let error = response.error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let data = response.data else {
                print("Veri yok")
                return
            }
            
            do {
                let call = try JSONDecoder().decode(CRUDCall.self, from: data)
                if let list = call.urunler_sepeti {
                    self.productListe.onNext(list)
                }
                
                if let success = call.success, let message = call.message {
                    print("success: \(success)")
                    print("message: \(message)")
                } else {
                    print("success veya message yok")
                }
            } catch {
                print("Sepete eklenemedi: \(error.localizedDescription)")
            }
        }
    }
    
    func getProducts(){
        
        let url = URL(string: "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php")!
        AF.request(url,method: .get).response { response in
            if let data = response.data {
                do{
                    let call = try JSONDecoder().decode(ProductsCall.self, from: data)
                    if let list = call.urunler {
                        self.productList.onNext(list)
                    }
                    
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

        
        

