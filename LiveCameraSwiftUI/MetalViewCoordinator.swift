import SwiftUI
import MetalKit
import MetalPerformanceShaders


class MetalViewCoordinator: NSObject, MTKViewDelegate {
    let frameHandler: FrameHandler
    let commandQueue: MTLCommandQueue
    
    init(frameHandler: FrameHandler, device: MTLDevice) {
        self.frameHandler = frameHandler
        self.commandQueue = device.makeCommandQueue()!
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Pass
    }
    
    func draw(in view: MTKView) {
        guard let frame = frameHandler.frame else { return }
        
        // Convert into texture
        guard let sourceTexture = createMTKTexture(sourceImage: frame, view: view) else { return }

        // Draw the texture
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let drawable = view.currentDrawable else { return }
        
        // Shader
        let linearGrayColorTransform: [Float] = [0.2, 0.7, 0.1]
        let shader = MPSImageSobel(device: view.device!, linearGrayColorTransform: linearGrayColorTransform)
        shader.encode(commandBuffer: commandBuffer, sourceTexture: sourceTexture, destinationTexture: drawable.texture)
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func createMTKTexture(sourceImage: CGImage, view: MTKView) -> MTLTexture? {
        let device = view.device!

        // Set dimensions to fill screen
        let width: Int = Int(view.drawableSize.width)
        let height: Int = Int(view.drawableSize.height)
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                         width: Int(width),
                                                                         height: Int(height),
                                                                         mipmapped: false)
        let texture = device.makeTexture(descriptor: textureDescriptor)
        
        let bytesPerPixel = 4 // RGBA
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)

        context?.draw(sourceImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

        // Copy the pixel data to the texture
        let region = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: pixelData, bytesPerRow: bytesPerRow)
        
        return texture
    }
}
