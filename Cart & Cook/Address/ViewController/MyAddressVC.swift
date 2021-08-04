//
//  MyAddressVC.swift
//  Cart & Cook
//
//  Created by Development  on 26/05/2021.
//

import Foundation
import UIKit
import CoreData
class MyAddressVC: UIViewController {
    var tableItems: [NSManagedObject] = []
    var selectedIndex = -1
    var selectedAddressId = 0
    var fromVc = ""
    @IBOutlet weak var myAddressCV: UICollectionView!
    @IBOutlet weak var confirmLocBtn: PrimaryroundButton!
    @IBOutlet weak var nolocationLabel: UILabel!
    
    @IBOutlet weak var addLocBtn: PrimaryroundButton!
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        if(fromVc == "from menu") {
            confirmLocBtn.isHidden = true
        } else
        {
            confirmLocBtn.isHidden = false
        }
        getAddressList()
        
    }
   
    private func getAddressList() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "AddressList")
        do {
            tableItems = try managedContext.fetch(fetchRequest)
            if(tableItems.count > 0) {
                myAddressCV.reloadData()
                addLocBtn.isHidden = true
                nolocationLabel.isHidden = true
                if let id = self.tableItems[0].value(forKey: "id") as? Int {
                    UserDefaults.standard.setValue(id, forKey: ADDRESSID)
                }
            } else {
                addLocBtn.isHidden = false
                nolocationLabel.isHidden = false
            }
           
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addAddress(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "LocateAddressVC") as? LocateAddressVC {
            self.navigationController?.pushViewController(vc, animated:   true)
        }
    }
    
    
    
    @IBAction func confirmLocAction(_ sender: Any) {
        
        if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CheckoutVC") as? CheckoutVC {
//            vc.addressId = selectedAddressId
//            print(selectedAddressId)
            self.navigationController?.pushViewController(vc, animated:   true)
        }

    }
    @IBAction func addLocationAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "LocateAddressVC") as? LocateAddressVC {
            self.navigationController?.pushViewController(vc, animated:   true)
        }
    }
    
}
extension  MyAddressVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         guard let cell =  myAddressCV.dequeueReusableCell(withReuseIdentifier: "MyAddressCC", for: indexPath) as? MyAddressCC else {
               return UICollectionViewCell()
          }
        if let id = self.tableItems[indexPath.row].value(forKey: "id") as? Int {
            cell.id = id
        }
        if let name = self.tableItems[indexPath.row].value(forKey: "cname") as? String {
            cell.nameLabel.text = name
        }
        if let address = self.tableItems[indexPath.row].value(forKey: "address") as? String {
            cell.addressLabel.text = address
        }
        if let phone = self.tableItems[indexPath.row].value(forKey: "phone") as? String {
            cell.phoneLabel.text = phone
        }
        if let gps = self.tableItems[indexPath.row].value(forKey: "gps") as? String {
            cell.coordinate = gps
        }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteAddress(_:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editAddress(_:)), for: .touchUpInside)
        if(selectedIndex == indexPath.row) {
            cell.outerView.layer.borderWidth = 3
            cell.outerView.layer.borderColor = AppColor.colorGreen.cgColor
        } else {
            cell.outerView.layer.borderWidth = 1
            cell.outerView.layer.borderColor = UIColor.lightGray.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        guard let cell = myAddressCV.cellForItem(at: indexPath) as? MyAddressCC else {
          return
       }
        self.selectedAddressId = cell.id
        UserDefaults.standard.setValue(cell.id, forKey: ADDRESSID)
        myAddressCV.reloadData()
    }




    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      

        let width = (collectionView.frame.width - 10)
        return CGSize(width: width, height: 120)
    }


    @objc func deleteAddress(_ sender:UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = myAddressCV.cellForItem(at: indexPath) as? MyAddressCC else {
           return
       }
        let id = cell.id
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext2 = appDelegate.persistentContainer.viewContext
        var fetchResults: [NSManagedObject]  = []
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "AddressList")
        do {
           fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
            fetchResults = try managedContext2.fetch(fetchRequest)
            if fetchResults.count != 0 {
             
                    managedContext2.delete(fetchResults[0])
                    try managedContext2.save()
                
                tableItems.remove(at: sender.tag)
                self.myAddressCV.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
            
    }
    @objc func editAddress(_ sender:UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = myAddressCV.cellForItem(at: indexPath) as? MyAddressCC else {
           return
       }
        let id = cell.id
        let gps = cell.coordinate
        if let fulladdress = cell.addressLabel.text {
            var fulladdressArr = fulladdress.components(separatedBy: ",")
            if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC {
                vc.area = fulladdressArr[1]
                vc.emirate = fulladdressArr[2]
                vc.gps = gps
                vc.editingAddressId = id
                vc.isFromEdit = true
                vc.fromVc = self.fromVc
                vc.shop = fulladdressArr[0]
                self.navigationController?.pushViewController(vc, animated:   true)

            }
        }
        
        
    }

}
