//
//  ContentView.swift
//  testApp
//
//  Created by 本郷匠 on 2020/01/18.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct ContentView: View {
    let lists = [
        AppLists(id: 1, name: "MapKit", view: AnyView(MapKitView())),
        AppLists(id: 2, name: "HealthKit", view: AnyView(HealthKitView())),
        AppLists(id: 3, name: "WebKit", view: AnyView(WebKitView())),
        AppLists(id: 4, name: "PassKit", view: AnyView(PassKitView())),
        AppLists(id: 5, name: "PushKit", view: AnyView(PushKitView()))
    ]
    
    var body: some View {
        NavigationView {
            List(lists) { list in
                NavigationLink(destination: list.view, label: {
                    Text(String(list.id) + "." + list.name)
                        .font(.callout)
                })
                    .animation(.spring())
            }
            .navigationBarTitle("SampleAppLists")
        }
    }
}

@available(iOS 13.0, *)
struct AppLists: Identifiable {
    var id: Int
    var name: String
    var view: AnyView
}

#if DEBUG
@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
