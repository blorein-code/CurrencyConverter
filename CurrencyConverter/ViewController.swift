//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Berke Topcu on 2.11.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func buttonClicked(_ sender: Any) {
        //API işlemlerini 3 aşamada inceleyeceğiz
        
        //1) Request yani istek atma bölümü
        //2) Responsa & Data yani sonuçların geldiği bölüm
        //3) Gelen verileri Json Serialize ya da Parsing işlemine sokarak formatını değiştirme
        
        
        //1. Adım burada başladı
        //istek atılacak adres
        //Burada https bir bağlantı kullandık bu yüzden işlemler korumalı ancak ; http bir bağlantı kullansaydık info bölümünden App Transport Security Settings ekleyip yan tarafında bulunan oku aşağı yöne çevirdikten sonra Allow Arbitrary Loads özelliğini seçip Yes yapmamız gerekiyor. Bunu yapmazsak http uzantılı bağlantılardan veri alamayacağız.
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/CurrencyData/main/currency.json")
        //Sürekli kullanacağımız obje
        let session = URLSession.shared
        //
        let task = session.dataTask(with: url!) { data, response, error in
            //Eğer hata varsa kullanıcıya bir alert göstermek için alert ve buton oluşturup bunları alert'a ekledik.
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                //2. Adım burada başladı
                //Veri alabildik mi kontrolü yapıyoruz.
                if data != nil {
                    
                    //mutableContainers Array ve Dictionary ile çalışabilmek için gerekli yapı.
                    
                    //JSONSerialization gelen verileri json result objesi yapmak için
                    do {
                       let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        //ASYNC
                        //Face Recognizer'da olduğu gibi Dispatchqueue içerisinde belirtmemiz gerekiyor ki main thread problemi ortadan kalksın
                        DispatchQueue.main.async {
                            //En son ulaştığımız veride her şey string gelmiyorsa artık verinin türüne göre if let işlemi yapmamız gerekiyor.
                            if let  rates = jsonResponse["rates"] as? [String : Any] {
                                //print(rates)
                                if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let chf = rates["CHF"] as? Double {
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let tL = rates["TRY"] as? Double {
                                    self.tryLabel.text = "TRY: \(tL)"
                                }
                            }
                        }
                        
                        
                    } catch {
                        print("error")
                    }
                    
                }
            }
        }
        task.resume()
    }
    
}

