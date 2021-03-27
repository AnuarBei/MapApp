//
//  ViewController.swift
//  Map
//
//  Created by Ануар Беисов on 27.03.2021.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    
    var locations: [Point] = []

    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locations = loadLocationData()
            for l in locations{
                mapView.addAnnotation(Location(lon: Double(l.longitude), lat: Double(l.latitude), title: l.title!, subtitle: l.subtitle!))
            }
            
            mapView.delegate = self
            let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            mapView.addGestureRecognizer(longTapGesture)
        }

        @objc func longTap(sender: UIGestureRecognizer){
            print("long tap")
            if sender.state == .began {
                let locationInView = sender.location(in: mapView)
                let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
                addAnnotation(location: locationOnMap)
            }
        }
        func addAnnotation(location: CLLocationCoordinate2D){
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
            
            let alert = UIAlertController(title: "Name of ypur point", message: "Add name and description", preferredStyle: .alert)
            present(alert, animated: true)
            alert.addTextField()
            alert.addTextField()
            alert.textFields![0].placeholder = "Title"
            alert.textFields![1].placeholder = "Subtitle"
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action) in
                let title = alert.textFields![0].text
                let subtitle = alert.textFields![1].text
                annotation.title = title
                annotation.subtitle = subtitle
                let lon = annotation.coordinate.longitude.advanced(by: 6)
                let lat = annotation.coordinate.latitude.advanced(by: 6)
                self.saveLocationData(title: title!, subtitle: subtitle!, lon: lon, lat: lat)
            }))
                
                self.mapView.addAnnotation(annotation)
        }
        
        func loadLocationData() -> [Point] {
             if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<Point>(entityName: "Point")
                do{
                    try locations = context.fetch(fetchRequest)
                    }
                catch{
                    print("Hiya")
                }}
            return locations
                
                
            }
        func saveLocationData(title: String, subtitle: String, lon: Double, lat: Double){
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                let context = appDelegate.persistentContainer.viewContext
                if let entity = NSEntityDescription.entity(forEntityName: "Point", in: context){
                    let location = NSManagedObject(entity: entity, insertInto: context)
                    location.setValue(title, forKey: "title")
                    location.setValue(subtitle, forKey: "subtitle")
                    location.setValue(Float(lon), forKey: "longitude")
                    location.setValue(Float(lat), forKey: "latitude")
                    do{
                        try context.save()
                        locations.append(location as! Point)
                    }catch{
                        print("wow i caught the ball")
                    }
                }
            }
        }
}

extension ViewController: MKMapViewDelegate{

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
                pinView!.pinTintColor = UIColor.black
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("tapped on pin ")
            let alert = UIAlertController(title: "Delete", message: "You sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "yes", style: .default, handler: {(action) in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                 let context = appDelegate.persistentContainer.viewContext
                    for l in self.locations{
                        if l.title == view.annotation?.title{
                            context.delete(l)
                            mapView.removeAnnotation(view.annotation!)
                        }
                    }
                    
                }
            }))
            present(alert, animated: true)
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                if let doSomething = view.annotation?.title! {
                   print("do something")
                }
            }
          }


}
