//
//  AddressVC.swift
//  Cart & Cook
//
//  Created by Development  on 25/05/2021.
//

import Foundation
import UIKit
import CountryPickerView
import CoreData
class AddressVC: UIViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {
    var editingAddressId = 0
    var isFromEdit = false
  var emirate = ""
    var area = ""
    var gps = ""
    var cName = ""
    var rName = ""
    var shop = ""
    var fromVc = ""
    let pickerView = ToolbarPickerView()
    let Menu = ["Dubai",
                    "Sharjah",
                    "Abu Dhabi",
                    "Ajman",
                    "RAK",
                    "Umm Al Quwain",
                    "Fujairah"
    ]
    @IBOutlet weak var mobileTf: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var shopTf: UITextField!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var gpsTF: UITextField!
    @IBOutlet weak var emirateTF: UITextField!
    @IBAction func openMapview(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        mobileTf.leftView = cpv
        mobileTf.leftViewMode = .always
        cpv.delegate = self
        cpv.dataSource = self
        setupDelegateForPickerView()
        setupDelegatesForTextFields()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    override func viewWillAppear(_ animated: Bool) {
        emirateTF.text = emirate
        areaTF.text = area
        gpsTF.text = gps
        shopTf.text = shop
        if let fname = UserDefaults.standard.value(forKey: FIRSTNAME) as? String {
          let lname = UserDefaults.standard.value(forKey: LASTNAME) as? String ?? ""
            cName = fname + " " + lname
            contactTF.text = cName
        }
        if let num = UserDefaults.standard.value(forKey: PHONENUMBER) as? String {
            mobileTf.text = num
        }
        
        if let rname = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String {
            self.rName = rname
            nameTF.text =  self.rName
        }
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func setupDelegatesForTextFields() {
        emirateTF.delegate = self
        emirateTF.inputView = pickerView
        emirateTF.inputAccessoryView = pickerView.toolbar
    }

        func setupDelegateForPickerView() {
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.toolbarDelegate = self
        }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print("code", country)
    }
    
    @IBAction func saveAddress(_ sender: Any) {
        
      
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        var fetchResults: [NSManagedObject]  = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "AddressList")
        do {
            var randomInt = 0
            if( isFromEdit == true ) {
                randomInt = self.editingAddressId
            } else {
                randomInt = Int.random(in: 1..<1000)
            }
            
                fetchRequest.predicate = NSPredicate(format: "id = %@", "\(randomInt)")
       
           
            fetchResults = try managedContext.fetch(fetchRequest)
           
             let emirate = emirateTF.text ?? ""
               let area = areaTF.text ?? ""
               let shop = shopTf.text  ?? ""
            let mobile = mobileTf.text ?? ""
            let cname = contactTF.text ?? ""
            let gps = gpsTF.text ?? ""
            let rName = nameTF.text ?? ""
            let address = shop + "," + area + "," + emirate
            if fetchResults.count == 0 {
                DispatchQueue.main.async  {
                    let entity =
                      NSEntityDescription.entity(forEntityName: "AddressList",
                                                 in: managedContext)!
                    let property = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
                    property.setValue(randomInt, forKey: "id")
                    
                    property.setValue(address, forKey: "address")
                    
                    property.setValue(mobile, forKey: "phone")
                    property.setValue(gps, forKey: "gps")
                    property.setValue(cname, forKey: "cname")
                    property.setValue(rName, forKey: "rname")
                    DispatchQueue.main.async {
                        do {
                          try managedContext.save()
                            if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "MyAddressVC") as? MyAddressVC {
                                self.navigationController?.pushViewController(vc, animated:   true)
                            }
                        } catch let error as NSError {
                          print("Could not save address. \(error), \(error.userInfo)")
                        }
                }
            }
            } else {
                fetchResults[0].setValue(randomInt, forKey: "id")
                
                fetchResults[0].setValue(address, forKey: "address")
                
                fetchResults[0].setValue(mobile, forKey: "phone")
                fetchResults[0].setValue(gps, forKey: "gps")
                fetchResults[0].setValue(cname, forKey: "cname")
                fetchResults[0].setValue(rName, forKey: "rname")
                do {
                  try managedContext.save()
                    if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "MyAddressVC") as? MyAddressVC {
                        vc.fromVc = self.fromVc
                        self.navigationController?.pushViewController(vc, animated:   true)
                    }
                } catch let error as NSError {
                  print("Could not save timeslot. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
      
        
    }
    
}
extension AddressVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.reloadAllComponents()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension AddressVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.Menu.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.Menu[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Check if the textfield isFirstResponder.
        if emirateTF.isFirstResponder {
            emirateTF.text = self.Menu[row]
        }
    }
    
}
extension AddressVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        self.view.endEditing(true)
    }

    func didTapCancel() {
       self.view.endEditing(true)
    }
}
