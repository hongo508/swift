//
//  MapKitView.swift
//  testApp
//
//  Created by 本郷匠 on 2020/01/18.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import MapKit

@available(iOS 13.0, *)
let locationObserver = LocationObserver()

@available(iOS 13.0, *)
struct MapKitView: View {
    @State var text = ""
    @State var point: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            TextField("検索", text: $text, onEditingChanged: { begin in
                if begin {
                    // TextFieldにカーソルが合った時
                }
            }, onCommit: {
                CLGeocoder().geocodeAddressString(self.text, completionHandler: {
                    (place, error) in
                    if let placeMarks = place {
                        if let firstPlaceMark = placeMarks.first {
                            if let location = firstPlaceMark.location {
                                self.point = location.coordinate
                            }
                        }
                    }
                })
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Spacer()
            
            MapView(coordinate: locationObserver.location.coordinate, aCoordinate: point, title: self.text)
            
            Spacer()
            
            Text("緯度：\(locationObserver.location.coordinate.latitude), 経度：\(locationObserver.location.coordinate.longitude)")
                .bold()
            
            Spacer()
        }
    }
}

@available(iOS 9.0, *)
struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    var coordinate: CLLocationCoordinate2D
    var aCoordinate: CLLocationCoordinate2D?
    var title: String
    
    func makeUIView(context: Context) -> MKMapView {
        let uiView = MKMapView(frame: .zero)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.mapType = .hybridFlyover
        uiView.setRegion(region, animated: true)
        uiView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        return uiView
    }
    
    @available(iOS 13.0, *)
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.mapType = .hybridFlyover
        uiView.setRegion(region, animated: true)
        uiView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        if aCoordinate != nil {
            let annotation = MKPointAnnotation()
            annotation.coordinate = aCoordinate!
            annotation.title = title
            uiView.addAnnotation(annotation)
            let center = CLLocationCoordinate2D(latitude: (locationObserver.location.coordinate.latitude + aCoordinate!.latitude) / 2,
                                                longitude: (locationObserver.location.coordinate.longitude + aCoordinate!.longitude) / 2)
            let span = MKCoordinateSpan(latitudeDelta: fabs(locationObserver.location.coordinate.latitude - aCoordinate!.latitude) + 0.1,
                                        longitudeDelta: fabs(locationObserver.location.coordinate.longitude - aCoordinate!.longitude) + 0.1)
            uiView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
        }
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

#if DEBUG
@available(iOS 13.0, *)
struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        MapKitView()
    }
}
#endif
