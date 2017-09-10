//
//  PixelBufferFactory.swift
//
//  Created by Omer Karisman on 2017/08/29.
//
#if arch(i386) || arch(x86_64)
import UIKit
struct PixelBufferFactory {
}
//Metal does not work in simulator :(
#else
import UIKit

struct PixelBufferFactory {

    static let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)

    static func make(with currentDrawable: CAMetalDrawable, usingBuffer pool: CVPixelBufferPool) -> CVPixelBuffer? {

        let destinationTexture = currentDrawable.texture
        var pixelBuffer: CVPixelBuffer?

        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)

        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
            let tempBuffer = CVPixelBufferGetBaseAddress(pixelBuffer)
            let w = Int(currentDrawable.layer.drawableSize.width)
            let h = Int(currentDrawable.layer.drawableSize.height)

            destinationTexture.getBytes(
                tempBuffer!, bytesPerRow: Int(bytesPerRow),
                from: MTLRegionMake2D(0, 0, w, h), mipmapLevel: 0
            )

            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            return pixelBuffer
        }
        return nil
    }

    static func imageFromCVPixelBuffer(buffer: CVPixelBuffer) -> UIImage {

        let ciimage = CIImage(cvPixelBuffer: buffer)
        let w = CVPixelBufferGetWidth(buffer)
        let h = CVPixelBufferGetHeight(buffer)
        let bounds = CGRect(x: 0, y: 0, width: w, height: h)
        let cgimgage = context.createCGImage(ciimage, from: bounds)
        let uiimage = UIImage(cgImage: cgimgage!)

        return uiimage
    }

}
#endif

