//
//  MAPADatosAlfanumericosViewController.swift
//  AppMapaReto1
//
//  Created by cice on 15/2/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import CoreLocation


class MAPADatosAlfanumericosViewController: UIViewController {

    var locationManager = CLLocationManager()
    
    
    
    
    //MARK: - IBoutlets
    
    
    @IBOutlet weak var miLatitudLbl: UILabel!
    
    @IBOutlet weak var miLongitudLbl: UILabel!
    
    
    @IBOutlet weak var miRumboLbl: UILabel!
    
    @IBOutlet weak var miVelocidadLbl: UILabel!
    
    
    
    
    @IBOutlet weak var miAltitudLbl: UILabel!
    
    
    @IBOutlet weak var miDireccionLbl: UILabel!
    
    
    @IBOutlet weak var miDatosLbl: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MAPADatosAlfanumericosViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            miLatitudLbl.text = "\(userLocation.coordinate.latitude)"
            miLongitudLbl.text = "\(userLocation.coordinate.longitude)"
            miRumboLbl.text = "\(userLocation.course)"
            miVelocidadLbl.text = "\(userLocation.speed)"
            miAltitudLbl.text = "\(userLocation.altitude)"
     
            // grupo de geolocalizacin inversa
            
            
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    if let placemarkData = placemarks?[0]{
                        var direccion = ""
                        direccion += self.addInfoIfExists(placemarkData.thoroughfare)
                        direccion += self.addInfoIfExists(placemarkData.subThoroughfare)
                        direccion += self.addInfoIfExists(placemarkData.subLocality)
                        direccion += self.addInfoIfExists(placemarkData.subThoroughfare)
                        direccion += self.addInfoIfExists(placemarkData.postalCode)
                        direccion += self.addInfoIfExists(placemarkData.country)
                        direccion += self.addInfoIfExists(placemarkData.locality)
                        
                        self.miDatosLbl.text = direccion
                    }
                    
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
        }
    }
    

// Creamos funcion para gestion de datos
func addInfoIfExists(_ info : String?)-> String{
    if info != nil {
        return "\(info!) \n"
    } else {
        return ""
    }
    
    }
}

