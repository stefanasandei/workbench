//
//  EditorView.swift
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

import SwiftUI
import MetalKit

struct EditorView: View {
    @State private var metalView = MTKView()
    @State private var renderer: AAPLRenderer?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            HStack {
                PropertiesView()
                
                VStack {
                    MetalViewRepresentable(metalView: $metalView)
                    .onAppear {
                        renderer = AAPLRenderer(metalKitView: metalView)
                    }
                }
            }.ignoresSafeArea(.all, edges: .top)
        }
        .frame(minWidth: 720, minHeight: 480)
    }
}

struct PropertiesView: View {
    @State private var settings: Float = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
            
            Section("Graphics") {
                HStack {
                    Text("Some value")
                    Slider(
                        value: $settings,
                        in: 10...180
                    )
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: 250)
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .background(BlurView(material: .sidebar, blendingMode: .behindWindow))
    }
}
