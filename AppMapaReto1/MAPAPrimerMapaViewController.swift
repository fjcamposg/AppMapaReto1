//
//  ViewController.swift
//  AppMapaReto1
//
//  Created by cice on 15/2/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



enum MapType : Int {
    case standard = 0
    case hibrido = 1
    case satelite = 2
}


class MAPAPrimerMapaViewController: UIViewController {
    // MARK: - Vables locales
    
    var locationManager = CLLocationManager()
    
    
    //MARK: - IBOutlet
    
    
    @IBOutlet weak var miMapa: MKMapView!
    
    @IBOutlet weak var miLabel: UILabel!
    
    
    @IBOutlet weak var miSeleccionTipoMapa: UISegmentedControl!
    
    
    
    
    
    @IBAction func miBoton(_ sender: AnyObject) {
    
        
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.371843, longitude: -3.532976), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        miMapa.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.371843, longitude: -3.532976)
        annotation.title = "Casa"
        annotation.subtitle = "Ubicando..."
        miMapa.addAnnotation(annotation)

    
    }
    
    
    @IBAction func miTipoMapaCambiado(_ sender: AnyObject) {
        
        let mapType = MapType(rawValue: miSeleccionTipoMapa.selectedSegmentIndex)
        switch mapType! {
        case .standard:
            miMapa.mapType = .standard
        case .hibrido:
            miMapa.mapType = .hybrid
        case .satelite:
            miMapa.mapType = .satellite
            break;
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fase de precision de GPS -> CoreLocation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        // gesto de reconocimiento para crear nueva chincheta
        
        let longPressGestureRecognizerCustom = UILongPressGestureRecognizer(target: self, action: #selector(self.actionGestureRecognizer(_:)))

        longPressGestureRecognizerCustom.minimumPressDuration = 2
        miMapa.addGestureRecognizer(longPressGestureRecognizerCustom)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Utils
    
    
    // Para crear una chincheta y solamente una vez
    
    
    func actionGestureRecognizer (_ gesture: UIGestureRecognizer ){
        if gesture.state == UIGestureRecognizerState.began {
        
        
        let puntoToquePantalla = gesture.location(in: miMapa)
        let nuevaCoordenada = miMapa.convert(puntoToquePantalla, toCoordinateFrom: miMapa)
        let annotation = MKPointAnnotation()
        annotation.coordinate = nuevaCoordenada
        annotation.title = "nuevo punto en el mapa"
        annotation.subtitle = "Seguimos ...."
        miMapa.addAnnotation(annotation)
        }
        
    }

}

extension MAPAPrimerMapaViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.first!
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        miMapa.setRegion(region, animated: true)
        miLabel.text = "\(userLocation)"
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "Titulo por defecto"
        annotation.subtitle = "Subtitulo por defecto"
        miMapa.addAnnotation(annotation)
        
        
        
    }
}




