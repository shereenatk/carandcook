//
//  CheckoutVC.swift
//  Cart & Cook
//
//  Created by Development  on 25/05/2021.
//

import Foundation
import UIKit
import CoreData
class CheckoutVC: UIViewController {
    var tableItems: [NSManagedObject] = []
    var isSelectedIndex = 0
    var addressId = 0
    var time = ""
    var fromVc = ""
    @IBOutlet weak var timeSlotVC: UICollectionView!
    @IBOutlet weak var addressAddBtn: UIButton!{
        didSet{
            addressAddBtn.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        
        getTimeSlotes()
        getAddressList()
    }
    
    private func getTimeSlotes() {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "TimeSlotValues")
        let sort = NSSortDescriptor(key:"slotID", ascending:true)
        fetchRequest.sortDescriptors = [sort]
        do {
            tableItems = try managedContext.fetch(fetchRequest)
            if let time = self.tableItems[0].value(forKey: "slotDuration") as? String {
                self.time = time
            }
            timeSlotVC.reloadData()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
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
            fetchRequest.predicate = NSPredicate(format: "id = %@", "\(addressId)")
            let items = try managedContext.fetch(fetchRequest)
            if(items.count > 0) {
                var address = items[0].value(forKey: "cname") as? String ?? ""
                if let fulladdress = items[0].value(forKey: "address") as? String{
                    var fulladdressArr = fulladdress.components(separatedBy: ",")
                        let area = fulladdressArr[1]
                    let  emirate = fulladdressArr[2]
                    let shop = fulladdressArr[0]
                    let street = shop + "," + area + "," + emirate
                    let phone = items[0].value(forKey: "phone") as? String ?? ""
                    address = address + "\n" + street + "\n" + phone
                    addressLabel.text = address
                }
                
                
               
                addressAddBtn.setTitle("SELECT", for: .normal)
            } else {
                addressLabel.text = "Please select an address"
                addressAddBtn.setTitle("ADD NEW ADDRESS", for: .normal)
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addNewAddressAction(_ sender: Any) {
        let title = self.addressAddBtn.titleLabel?.text
        if(title == "SELECT") {
            if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "MyAddressVC") as? MyAddressVC {
                self.navigationController?.pushViewController(vc, animated:   true)
            }
        } else {
            if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "LocateAddressVC") as? LocateAddressVC {
                self.navigationController?.pushViewController(vc, animated:   true)
            }
        }
    }
    
    @IBAction func openReviewPage(_ sender: Any) {
        let title = self.addressAddBtn.titleLabel?.text
        if(title == "SELECT") {
            if let vc =  UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as? ReviewVC {
                if let add =   addressLabel.text {
                    vc.address = add
                    vc.time = self.time
                    vc.addresId = addressId
                    vc.fromVc = self.fromVc
                self.navigationController?.pushViewController(vc, animated:   true)
                }
            }
        } else {
            self.showMessageAlert(message: "Please add address")
        }
        
    }
    
}
extension  CheckoutVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         guard let cell =  timeSlotVC.dequeueReusableCell(withReuseIdentifier: "TimeslotCC", for: indexPath) as? TimeslotCC else {
               return UICollectionViewCell()
          }
        if let time = self.tableItems[indexPath.row].value(forKey: "slotDuration") as? String {
            cell.timeBtn.setTitle("  " + time, for: .normal)
        }
        if(self.isSelectedIndex == indexPath.row) {
            cell.timeBtn.tintColor = AppColor.colorPrimary.value
            cell.timeBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        } else {
            cell.timeBtn.tintColor = .black
            cell.timeBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        if let id = self.tableItems[indexPath.row].value(forKey: "slotID") as? Int {
            cell.slotId = id
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isSelectedIndex = indexPath.row
        if let time = self.tableItems[indexPath.row].value(forKey: "slotDuration") as? String {
            self.time = time
        }
        
               timeSlotVC.reloadData()
    }




    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        let width = (collectionView.frame.width - 20) / 2.0
        return CGSize(width: width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }




}
