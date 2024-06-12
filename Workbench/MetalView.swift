//
//  MetalView.swift
//  Workbench
//
//  Created by Asandei Stefan on 12.06.2024.
//

import SwiftUI
import MetalKit

struct MetalViewRepresentable: NSViewRepresentable {

    @Binding var metalView: MTKView

    func makeNSView(context: Context) -> some NSView {
        metalView
    }

    func updateNSView(_ uiView: NSViewType, context: Context) { }
}
