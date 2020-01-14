//
//  MapKitView.swift
//  MapKit-test
//
//  Created by 本郷匠 on 2020/01/14.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation

@available(iOS 13.0, *)
struct MapKitView: View {
    let locationObserver = LocationObserver()
    
    var body: some View {
        VStack {
            MapView(coordinate: locationObserver.location.coordinate, title: "現在地")
            
            Spacer()
            
            Text("緯度：\(locationObserver.location.coordinate.latitude), 経度：\(locationObserver.location.coordinate.longitude)").bold()
            
            Spacer()
        }
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    var coordinate: CLLocationCoordinate2D
    var title: String
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        uiView.addAnnotation(annotation)
    }
}

@available(iOS 13.0, *)
class LocationObserver: NSObject, ObservableObject, CLLocationManagerDelegate {
    var location = CLLocation()
    let locationManager: CLLocationManager!
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.requestWhenInUseAuthorization()
        let sts = CLLocationManager.authorizationStatus()
        
        if sts == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        for location in locations {
            print("緯度：\(location.coordinate.latitude), 経度：\(location.coordinate.longitude)")
        }
    }
}

@available(iOS 13.0, *)
struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        MapKitView()
    }
}
