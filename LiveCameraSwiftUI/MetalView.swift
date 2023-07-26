import SwiftUI
import MetalKit


struct MetalView: UIViewRepresentable {
    let frameHandler: FrameHandler
    let metalDevice = MTLCreateSystemDefaultDevice()
    
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = metalDevice
        metalView.delegate = context.coordinator
        metalView.framebufferOnly = false
        return metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        // Pass
    }
    
    func makeCoordinator() -> MetalViewCoordinator {
        MetalViewCoordinator(frameHandler: frameHandler, device: metalDevice!)
    }
}
