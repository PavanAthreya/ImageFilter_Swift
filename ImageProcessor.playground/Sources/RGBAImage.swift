import UIKit

public struct Pixel {
    public var value: UInt32
    
    public var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        }
        set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }
    
    public var green: UInt8 {
        get {
            return UInt8((value >> 8) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }
    
    public var blue: UInt8 {
        get {
            return UInt8((value >> 16) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }
    
    public var alpha: UInt8 {
        get {
            return UInt8((value >> 24) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
}

public struct RGBAImage {
    public var pixels: [Pixel]
    
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitMapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitMapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        
        let bytesPerRow = width * 4
        
        let imageDataReference = UnsafeMutablePointer<Pixel>.allocate(capacity: width*height)
        
        guard let imageContext = CGContext.init(data: imageDataReference, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let bufferPointer = UnsafeMutableBufferPointer<Pixel>(start: imageDataReference, count: width * height)
        pixels = Array(bufferPointer)
        
        imageDataReference.deallocate()
    }
    
    public func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let bytesPerRow = width * 4
        
        let imageReferenceData = UnsafeMutablePointer<Pixel>.allocate(capacity: width*height)
        imageReferenceData.initialize(from: pixels, count: width*height)
        
        let imageContext = CGContext.init(data: imageReferenceData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        guard let cgImg = imageContext?.makeImage() else {return nil}

        let image = UIImage(cgImage: cgImg)
        
        defer {
            imageReferenceData.deallocate()
        }
        
        return image
    }
}
