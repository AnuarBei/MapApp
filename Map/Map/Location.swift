//
//  Location.swift
//  Map
//
//  Created by Ануар Беисов on 27.03.2021.
//

import Foundation
import MapKit
class Location: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(lon: Double, lat: Double, title: String, subtitle: String) {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lon)!)
        self.title = title
        self.subtitle = subtitle
    }
}
