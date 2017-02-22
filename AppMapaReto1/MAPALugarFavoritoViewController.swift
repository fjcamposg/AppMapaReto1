//
//  MAPALugarFavoritoViewController.swift
//  AppMapaReto1
//
//  Created by cice on 20/2/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MAPALugarFavoritoViewController: UIViewController {

    
    
    // MARK: - Vbles
    var locationManager = CLLocationManager()
    
    //MARK: - IBoutlet
    
    @IBOutlet weak var miMapa: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.actionCreaChincheta(_:)))
        longPressGR.minimumPressDuration = 2
        miMapa.addGestureRecognizer(longPressGR)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Utils
    
    func actionCreaChincheta (_ gesture : UIGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.began{
        let puntoTocado = gesture.location(in: miMapa)
        let nuevaCoordenada = miMapa.convert(puntoTocado, toCoordinateFrom: miMapa)
        let customLocation = CLLocation(latitude: nuevaCoordenada.latitude, longitude: nuevaCoordenada.longitude)
        
        
        CLGeocoder().reverseGeocodeLocation(customLocation) { (placemarks, error) in
            var calle = ""
            var numero = ""
            var customTitulo = ""
            
            if let customPlacemarks = placemarks?[0]{
                if customPlacemarks.thoroughfare != nil {
                    calle = customPlacemarks.thoroughfare!
                }
                if customPlacemarks.subThoroughfare != nil {
                    numero = customPlacemarks.subThoroughfare!
                }
                customTitulo = "\(calle) \(numero)"
            }
            if customTitulo == "" {
                customTitulo = "Punto añadido el \(Date())"
                
            }
            
            // Creamos la anotacion
            let annotation = MKPointAnnotation()
            annotation.coordinate = nuevaCoordenada
            annotation.title = customTitulo
            self.miMapa.addAnnotation(annotation)
            
            
            customLugares.append(["name" : customTitulo, "lat": "\(nuevaCoordenada.latitude)", "long" : "\(nuevaCoordenada.longitude)"])
            
            
            }
            
        }
    }

}


extension MAPALugarFavoritoViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let latitud = userLocation.coordinate.latitude
        let longitud = userLocation.coordinate.longitude
        
        let locationData = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let region = MKCoordinateRegion(center: locationData, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        miMapa.setRegion(region, animated: true)
        
    }
    
}
