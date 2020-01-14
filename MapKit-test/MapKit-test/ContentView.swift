//
//  ContentView.swift
//  MapKit-test
//
//  Created by 本郷匠 on 2020/01/14.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct ContentView: View {
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

@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
