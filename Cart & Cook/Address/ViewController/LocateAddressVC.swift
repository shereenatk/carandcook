//
//  LocateAddressVC.swift
//  Cart & Cook
//
//  Created by Development  on 26/05/2021.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
class LocateAddressVC: UIViewController, MKMapViewDelegate {
    
  
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000

    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .followWithHeading
        configureLocationServices()
//        centerMapOnUserLocation()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLocationList() {
         var lat: Double = 0.0
         var log: Double = 0.0
          
         if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
             CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
             guard let currentLocation = locationManager.location else {
                 return
             }
              lat = currentLocation.coordinate.latitude
             log =  currentLocation.coordinate.longitude
        
            let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:
            0.01)
    //        print(location.coordinate.latitude, location.coordinate.longitude)
            let coordinate = CLLocationCoordinate2D.init(latitude:currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) // provide you lat and long
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
    }
    
    }
    
    func centerMapOnUserLocation() {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:
        0.01)
        let coordinate = CLLocationCoordinate2D.init(latitude: 25.2048, longitude: 55.2708) // provide you lat and long
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }

    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }

    @IBAction func confirmLocation(_ sender: Any) {
       
        

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            var areaVal = ""
            var emirateVal = ""
            if let area = placeMark.addressDictionary!["Name"] as? NSString {
                areaVal =  area as String
            }
            if let emirate = placeMark.addressDictionary!["State"] as? NSString {
                emirateVal = emirate as String
            }
            let lat = "\(self.mapView.centerCoordinate.latitude)"
            let long = "\(self.mapView.centerCoordinate.longitude)"
            let gps = lat + "," + long
            
            if let vc =  UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC {
                vc.area = areaVal
                vc.emirate = emirateVal
                vc.gps = gps
                self.navigationController?.pushViewController(vc, animated:   true)

            }
            
           

        })
    }
    

}
extension LocateAddressVC: CLLocationManagerDelegate {

//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:
        0.01)
//        print(location.coordinate.latitude, location.coordinate.longitude)
        let coordinate = CLLocationCoordinate2D.init(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude) // provide you lat and long
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

    }

    

    
}
