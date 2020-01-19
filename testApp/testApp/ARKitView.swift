//
//  ARKitView.swift
//  testApp
//
//  Created by 本郷匠 on 2020/01/18.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import ARKit
import RealityKit

@available(iOS 13.0, *)
struct ARKitView: View {
    var body: some View {
        ArView()
    }
}

@available(iOS 13.0, *)
struct ArView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    func makeUIView(context: Context) -> ARView {
        ARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ARKitView_Previews: PreviewProvider {
    static var previews: some View {
        ARKitView()
    }
}
