//
//  FilterVC.swift
//  Cart & Cook
//
//  Created by Development  on 27/06/2021.
//

import Foundation
import UIKit
import CoreData
import RangeSeekSlider
class FilterVC: UIViewController {
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var packsizeView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var pckFilter: UITableView!
    @IBOutlet weak var sortByfilter: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.layer.cornerRadius = 15
            cancelBtn.layer.borderColor = AppColor.colorGreen.value.cgColor
            cancelBtn.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var endRange: UILabel!
    @IBOutlet weak var startRange: UILabel!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var packBtn: UIButton!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var SortBtn: UIButton!
    @IBAction func backgroundAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var countryfilterTV: UITableView!
    var mainIndexBtnIndex = 0
    var countryList : [String] = []
    var unitList : [String] = []
    var sortArray = ["Alphabetical", "Price : Low to High", "Price : high to Low"]
    var filterSort = ""
    var filterCounrty : [String] = []
    var filterUnit : [String] = []
    static var selectedMainIndex = 0
    var type = 0
    override func viewDidLoad() {
        getProductList()
        setMainBtnBackground()
        rangeSlider.delegate = self
        sortByfilter.reloadData()
        countryfilterTV.reloadData()
        pckFilter.reloadData()
    }
    
    private func setMainBtnBackground() {
        switch FilterVC.selectedMainIndex {
        case 0 :
            self.SortBtn.backgroundColor = UIColor.lightGray
            self.countryBtn.backgroundColor = .clear
            self.packBtn.backgroundColor = .clear
            self.priceBtn.backgroundColor = .clear
            
            sortView.isHidden = false
            countryView.isHidden = true
            priceView.isHidden = true
            packsizeView.isHidden = true
        case 1 :
            self.SortBtn.backgroundColor = .clear
            self.countryBtn.backgroundColor = UIColor.lightGray
            self.packBtn.backgroundColor = .clear
            self.priceBtn.backgroundColor = .clear
            sortView.isHidden = true
            countryView.isHidden = false
            priceView.isHidden = true
            packsizeView.isHidden = true
        case 2 :
            self.SortBtn.backgroundColor = .clear
            self.countryBtn.backgroundColor = .clear
            self.packBtn.backgroundColor = UIColor.lightGray
            self.priceBtn.backgroundColor = .clear
            sortView.isHidden = true
            countryView.isHidden = true
            priceView.isHidden = true
            packsizeView.isHidden = false
        default  :
            self.SortBtn.backgroundColor = .clear
            self.countryBtn.backgroundColor = .clear
            self.packBtn.backgroundColor = .clear
            self.priceBtn.backgroundColor =  UIColor.lightGray
            sortView.isHidden = true
            countryView.isHidden = true
            priceView.isHidden = false
            packsizeView.isHidden = true
            
        }
    }
    
    @IBAction func sortbtnAction(_ sender: Any) {
        FilterVC.selectedMainIndex = 0
        sortByfilter.reloadData()
        setMainBtnBackground()
    }
    
    @IBAction func clearFilter(_ sender: Any) {
         filterSort = ""
         filterCounrty  = []
         filterUnit = []
        self.startRange.text = "0"
        self.endRange.text = "0"
        guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
            return
        }
     if let pvc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
        let controllers = pvc.viewControllers
         pvc.selectedIndex = 1
         let vc = controllers![1] as! CategoriesVC
         vc.fromVC = "filter"
         vc.filterSort = self.filterSort
         vc.filterCounrty  = self.filterCounrty
         vc.filterUnit = self.filterUnit
         if let start = self.startRange.text {
             vc.startRange = Int(start) ?? 0
         }
         if let end = self.endRange.text {
             vc.endRange = Int(end) ?? 0
         }
            window.pushViewController(pvc, animated:   true)

     }
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        
           guard let window = UIApplication.shared.windows.first?.rootViewController as? AppLandingNC else {
               return
           }
        if let pvc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
           let controllers = pvc.viewControllers
            pvc.selectedIndex = 1
            let vc = controllers![1] as! CategoriesVC
            vc.fromVC = "filter"
            vc.filterSort = self.filterSort
            vc.filterCounrty  = self.filterCounrty
            vc.filterUnit = self.filterUnit
            if let start = self.startRange.text {
                vc.startRange = Int(start) ?? 0
            }
            if let end = self.endRange.text {
                vc.endRange = Int(end) ?? 0
            }
               window.pushViewController(pvc, animated:   true)

        }
//
//           if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CategoriesVC") as? CategoriesVC {
//            vc.fromVC = "filter"
//            vc.filterSort = self.filterSort
//            vc.filterCounrty  = self.filterCounrty
//            vc.filterUnit = self.filterUnit
//            if let start = self.startRange.text {
//                vc.startRange = Int(start) ?? 0
//            }
//            if let end = self.endRange.text {
//                vc.endRange = Int(end) ?? 0
//            }
//               window.pushViewController(vc, animated:   true)
//           }
    }
    
    @IBAction func coutryAction(_ sender: Any) {
        FilterVC.selectedMainIndex = 1
        setMainBtnBackground()
        countryfilterTV.reloadData()
    }
    
    @IBAction func packAction(_ sender: Any) {
        FilterVC.selectedMainIndex = 2
        setMainBtnBackground()
        pckFilter.reloadData()
    }
    
    @IBAction func priceAction(_ sender: Any) {
        FilterVC.selectedMainIndex = 3
        setMainBtnBackground()
    }
    private func getProductList() {
       
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "ProductList")
        do {
            let sort = NSSortDescriptor(key:"item", ascending:true)
            fetchRequest.sortDescriptors = [sort]
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                let country = item.value(forKey: "country") as? String ?? ""
                let unit =  item.value(forKey: "unit") as? String ?? "0"
                if(self.unitList.count == 0) {
                    self.unitList.append(unit)
                    
                } else {
                    if(!self.unitList.contains(unit)){
                        self.unitList.append(unit)
                    }
                }
                
                if(self.countryList.count == 0) {
                    self.countryList.append(unit)
                    
                } else {
                    if(!self.countryList.contains(country)){
                        self.countryList.append(country)
                    }
                }
            
                
            }
            countryfilterTV.reloadData()
            pckFilter.reloadData()
            sortByfilter.reloadData()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
extension FilterVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
       
        case sortByfilter:
            return 3
        case countryfilterTV:
           
            return countryList.count
        case pckFilter:
           
           return unitList.count
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        
      
        case sortByfilter:
            guard let cell = sortByfilter.dequeueReusableCell(withIdentifier: "sortByFilterTC", for: indexPath) as? sortByFilterTC else {
                return UITableViewCell()
            }
            let text = sortArray[indexPath.row]
            cell.filterFieldLabel.text = text
            if filterSort == text {
                cell.checkBox.image = UIImage(named:"checkboxclicked")
                cell.checkBox.tintColor =  UIColor(red: 1.00, green: 0.37, blue: 0.08, alpha: 1.00)
            }
            else {
                cell.checkBox.image = UIImage(named:"checkbox")
                cell.checkBox.tintColor = .black
            }
            return cell
        case countryfilterTV:
            guard let cell = countryfilterTV.dequeueReusableCell(withIdentifier: "CountryFilterTC", for: indexPath) as? CountryFilterTC else {
                return UITableViewCell()
            }
            let text = countryList[indexPath.row]
            cell.filterFieldLabel.text = text
            if filterCounrty.contains(text) {
                cell.checkBox.image = UIImage(named:"checkboxclicked")
                cell.checkBox.tintColor =  UIColor(red: 1.00, green: 0.37, blue: 0.08, alpha: 1.00)
            }
            else {
                cell.checkBox.image = UIImage(named:"checkbox")
                cell.checkBox.tintColor = .black
            }
            return cell
            
        case pckFilter:
            guard let cell = pckFilter.dequeueReusableCell(withIdentifier: "PckgFilterTC", for: indexPath) as? PckgFilterTC else {
                return UITableViewCell()
            }
            let text = unitList[indexPath.row]
            cell.filterFieldLabel.text = text
            if filterUnit.contains(text) {
                cell.checkBox.image = UIImage(named:"checkboxclicked")
                cell.checkBox.tintColor =  UIColor(red: 1.00, green: 0.37, blue: 0.08, alpha: 1.00)
            }
            else {
                cell.checkBox.image = UIImage(named:"checkbox")
                cell.checkBox.tintColor = .black
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        default:
            return 40.0
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if(tableView == sortByfilter)  {
        filterSort =  sortArray[indexPath.row]
         sortByfilter.reloadData()
        }
        if(tableView == countryfilterTV)  {
            filterCounrty.append(countryList[indexPath.row])
            countryfilterTV.reloadData()
          }
        if(tableView == pckFilter)  {
            filterUnit.append(unitList[indexPath.row])
            pckFilter.reloadData()
        }
           
    }
 
}
extension FilterVC: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        let min = Int(minValue)
        let max = Int(maxValue)
        self.startRange.text = "\(min)"
        self.endRange.text = "\(max)"
//            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
       
    }

    func didStartTouches(in slider: RangeSeekSlider) {
//        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
//        print("did end touches")
    }
}
