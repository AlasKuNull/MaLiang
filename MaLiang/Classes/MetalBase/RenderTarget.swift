//
//  RenderTarget.swift
//  MaLiang
//
//  Created by Harley-xk on 2019/4/15.
//

import Foundation
import Metal

/// a target for any thing that can be render on
open class RenderTarget {
    
    /// texture to render on
    public private(set) var texture: MTLTexture?
    
    /// the scale level of view, all things scales
    open var scale: CGFloat = 1
    
    /// the zoom level of render target, only scale render target
    open var zoom: CGFloat = 1

    /// the offset of render target with zoomed size
    open var contentOffset: CGPoint = .zero
    
    /// create with texture an device
    public init(size: CGSize, device: MTLDevice?) {
        
        self.drawableSize = size
        self.device = device
        self.texture = makeEmptyTexture()
        self.commandQueue = device?.makeCommandQueue()

        renderPassDescriptor = MTLRenderPassDescriptor()
        let attachment = renderPassDescriptor?.colorAttachments[0]
        attachment?.texture = texture
        attachment?.loadAction = .load
        attachment?.storeAction = .store
        
        updateBuffer(with: size)
    }
    
    /// clear the contents of texture
    open func clear() {
        texture = makeEmptyTexture()
        renderPassDescriptor?.colorAttachments[0].texture = texture
    }
    
    internal var drawableSize: CGSize
    internal var uniform_buffer: MTLBuffer!
    internal var renderPassDescriptor: MTLRenderPassDescriptor?
    internal var commandBuffer: MTLCommandBuffer?
    internal var commandQueue: MTLCommandQueue?
    internal var device: MTLDevice?
    
    internal func updateBuffer(with size: CGSize) {
        self.drawableSize = size
        let metrix = Matrix.identity
        metrix.scaling(x: 2 / Float(size.width), y: -2 / Float(size.height), z: 1)
        metrix.translation(x: -1, y: 1, z: 0)
        uniform_buffer = device?.makeBuffer(bytes: metrix.m, length: MemoryLayout<Float>.size * 16, options: [])
    }
    
    internal func prepareForDraw() {
        if commandBuffer == nil {
            commandBuffer = commandQueue?.makeCommandBuffer()
        }
    }

    internal func makeCommandEncoder() -> MTLRenderCommandEncoder? {
        guard let commandBuffer = commandBuffer, let rpd = renderPassDescriptor else {
            return nil
        }
        return commandBuffer.makeRenderCommandEncoder(descriptor: rpd)
    }
    
    internal func commitCommands() {
        commandBuffer?.commit()
        commandBuffer = nil
    }
    
    // make empty testure
    internal func makeEmptyTexture() -> MTLTexture? {
        guard drawableSize.width * drawableSize.height > 0 else {
            return nil
        }
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                         width: Int(drawableSize.width),
                                                                         height: Int(drawableSize.height),
                                                                         mipmapped: false)
        textureDescriptor.usage = [.renderTarget, .shaderRead]
        return device?.makeTexture(descriptor: textureDescriptor)
    }
    
}
