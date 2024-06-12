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
            HSplitView {
                MetalViewRepresentable(metalView: $metalView)
                .onAppear {
                    renderer = AAPLRenderer(metalKitView: metalView)
                }
                
                PropertiesView()
            }.ignoresSafeArea(.all, edges: .top)
        }
        .background(BlurView(material: .sidebar, blendingMode: .behindWindow))
        .frame(minWidth: 720, minHeight: 480)
    }
}

struct EditorPanelView<Content: View>: View {
    public var content: Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            content
            
            Spacer()
        }
        .frame(maxWidth: 250)
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
}


struct PropertiesView: View {
    @State private var settings: Float = 0.0
    
    var body: some View {
        EditorPanelView {
            Section("Some value") {
                Slider(
                    value: $settings,
                    in: 10...180
                )
            }
            .font(.headline)
        }
    }
}
