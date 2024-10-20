//
//  BagRepository.swift
//  test
//
//  Created by Oğuzhan Yavuz on 8.10.2024.
//

import Foundation
import RxSwift
import Alamofire

class BagRepository {
    
    var productList = BehaviorSubject<[urunler_sepeti]>(value: [urunler_sepeti]())
    
    func getBag(kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        let params: Parameters = ["kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: params).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    print("No data received")
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("API Response: \(jsonString)")
                }
                
                do {
                    let call = try JSONDecoder().decode(BagCall.self, from: data)
                    if let success = call.success, success == 1 {
                        let list = call.urunler_sepeti ?? []
                        self.productList.onNext(list)
                    } else {
                        print(call.message ?? "No message")
                        self.productList.onNext([]) // Boş bir dizi gönderin
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    // Boş bir dizi ile güncelle
                    self.productList.onNext([])
                }
                
            case .failure(let error):
                print("Request failed: \(error.localizedDescription)")
                // Hata durumunda da boş bir dizi ile güncelle
                self.productList.onNext([])
            }
        }
    }

    func deleteBag(sepetId: Int, kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        let params: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let call = try JSONDecoder().decode(BagCall.self, from: data)
                    print("success: \(call.success!)")
                    print("message: \(call.message!)")
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
    }
}

    /*
     switch response.result {
     case .success:
     guard let data = response.data else {
     print("No data received")
     return
     }
     
     if let jsonString = String(data: data, encoding: .utf8) {
     print("API Response: \(jsonString)")
     }
     
     do {
     let call = try JSONDecoder().decode(BagCall.self, from: data)
     if let success = call.success, success == 1 {
     let list = call.urunler_sepeti ?? []
     self.productList.onNext(list)
     } else {
     print(call.message ?? "No message")
     self.productList.onNext([]) // Boş bir dizi gönderin
     }
     } catch {
     print("Decoding error: \(error.localizedDescription)")
     }
     
     case .failure(let error):
     print("Request failed: \(error.localizedDescription)")
     }
     */
    

