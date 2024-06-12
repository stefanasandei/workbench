//
//  EditorView.swift
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

import SwiftUI
import MetalKit
import Combine

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
                
                PropertiesView(renderer: $renderer)
            }.ignoresSafeArea(.all, edges: .top)
        }
        .background(BlurView(material: .sidebar, blendingMode: .withinWindow))
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
    @Binding public var renderer: AAPLRenderer?;
    
    @State private var settings = Tweaks();
    
    var body: some View {
        EditorPanelView {
            Section("Blue value: \(settings.blue)f") {
                Slider(
                    value: $settings.blue,
                    in: 0...1
                ).onChange(of: settings.blue, {
                    renderer?.setTweaks(settings);
                })
            }
            .font(.headline)
        }
    }
}
