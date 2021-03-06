//
//  Maths.swift
//  MetalKitTest
//
//  Created by Harley-xk on 2019/3/29.
//  Copyright © 2019 Someone Co.,Ltd. All rights reserved.
//

import Foundation
import CoreGraphics
import simd

struct Vertex {
    var position: vector_float4
    var textCoord: vector_float2
    
    init(position: CGPoint, textCoord: CGPoint) {
        self.position = position.toFloat4()
        self.textCoord = textCoord.toFloat2()
    }
}

struct Point {
    var position: vector_float4
    var color: vector_float4
    var size: Float
    
    init(x: CGFloat, y: CGFloat, color: MLColor, size: CGFloat) {
        self.position = vector_float4(Float(x), Float(y), 0, 1)
        self.size = Float(size)
        self.color = color.toFloat4()
    }
}

struct Uniforms {
    var scaleMatrix: [Float]
//    var rotationMatrix: [Float]
//    var translationMatrix: [Float]
    
    init(scale: Float = 1, drawableSize: CGSize) {
//        translationMatrix = Matrix.identity
//            scaleMatrix = Matrix.identity.scaling(x:  2 / Float(drawableSize.width),  y: -2 / Float(drawableSize.height), z: 1).m
        scaleMatrix = Matrix.identity.scaling(x:  0.5,  y: 0.5, z: 1).m
//        rotationMatrix = Matrix.identity.rotation(x: 0, y: 0, z: 0).m
//        translationMatrix = Matrix.identity.translation(x: -1, y: 1, z: 0).m
    }
}

struct ColorBuffer {
    var color: float4
    
    init(r: Float, g: Float, b: Float, a: Float) {
        color = float4(r,g,b,a)
    }
}

class Matrix {
    
    private(set) var m: [Float]
    
    static var identity = Matrix()
    
    private init() {
        m = [1, 0, 0, 0,
             0, 1, 0, 0,
             0, 0, 1, 0,
             0, 0, 0, 1
        ]
    }
    
    @discardableResult
    func translation(x: Float, y: Float, z: Float) -> Matrix {
        m[12] = x
        m[13] = y
        m[14] = z
        return self
    }
    
    @discardableResult
    func scaling(x: Float, y: Float, z: Float)  -> Matrix  {
        m[0] = x
        m[5] = y
        m[10] = z
        return self
    }
    
    @discardableResult
    func rotation(x: Float, y: Float, z: Float)  -> Matrix {
        m[0] = cos(y) * cos(z)
        m[4] = cos(z) * sin(x) * sin(y) - cos(x) * sin(z)
        m[8] = cos(x) * cos(z) * sin(y) + sin(x) * sin(z)
        m[1] = cos(y) * sin(z)
        m[5] = cos(x) * cos(z) + sin(x) * sin(y) * sin(z)
        m[9] = -cos(z) * sin(x) + cos(x) * sin(y) * sin(z)
        m[2] = -sin(y)
        m[6] = cos(y) * sin(x)
        m[10] = cos(x) * cos(y)
        return self
    }
}
