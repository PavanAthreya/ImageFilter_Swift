import UIKit

public class ImageFilter{
    var originalImage: UIImage!
    private var imagePixels:RGBAImage!
    let avgRed = 0
    let avgGreen = 0
    let avgBlue = 0
    let avgAlpha = 0
    
    public init(image:UIImage) {
        originalImage = image
        imagePixels = RGBAImage.init(image: originalImage)!
    }
    
    public var averagePixel:Pixel{
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        var totalAlpha = 0
        
        //Adding a red filter
        for y in 0..<imagePixels.height{
            for x in 0..<imagePixels.width{
                let index = (y * imagePixels.width) + x
                var pixel = imagePixels.pixels[index]
                totalRed += (Int)(pixel.red)
                totalBlue += (Int)(pixel.blue)
                totalGreen += (Int)(pixel.green)
                totalAlpha += (Int)(pixel.alpha)
            }
        }
        
        let avgRed = totalRed/(imagePixels.width*imagePixels.height)
        let avgGreen = totalGreen/(imagePixels.width*imagePixels.height)
        let avgBlue = totalBlue/(imagePixels.width*imagePixels.height)
        let avgAlpha = totalAlpha/(imagePixels.width*imagePixels.height)
        
        var avgPixel = Pixel(value:UInt32(0))
        avgPixel.red = UInt8(avgRed)
        avgPixel.green = UInt8(avgGreen)
        avgPixel.blue = UInt8(avgBlue)
        avgPixel.alpha = UInt8(avgAlpha)
        
        return avgPixel
    }
    
    public func ApplyRedFilter() -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<newImgPixels.width{
                let index = (y * newImgPixels.width) + x
                var pixel = newImgPixels.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                if redDiff > 0{
                    pixel.red = UInt8(max(0,min(255, avgRed+redDiff*5)))
                }
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
    
    public func ApplyGreenFilter() -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<newImgPixels.width{
                let index = (y * newImgPixels.width) + x
                var pixel = newImgPixels.pixels[index]
                let greenDiff = Int(pixel.green) - avgGreen
                if greenDiff > 0{
                    pixel.green = UInt8(max(0,min(255, avgGreen+greenDiff*5)))
                }
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
    
    public func ApplyBlueFilter() -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<imagePixels.width{
                let index = (y * newImgPixels.width) + x
                var pixel = newImgPixels.pixels[index]
                let blueDiff = Int(pixel.blue) - avgBlue
                if blueDiff > 0{
                    pixel.blue = UInt8(max(0,min(255, avgBlue+blueDiff*5)))
                }
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
    
    public func ImageToAdvancedGrayScale() -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<newImgPixels.width{
                let index = (y * newImgPixels.width) + x
                var pixel = newImgPixels.pixels[index]
                let grayValue = max(0,min(255, floor(Float(0.3*Float(pixel.red))+Float(0.59*Float(pixel.green))+Float(0.11*Float(pixel.blue)))))
                pixel.red = UInt8(grayValue)
                pixel.green = UInt8(grayValue)
                pixel.blue = UInt8(grayValue)
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
    
    public func ImageToNormalGrayScale() -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<newImgPixels.width{
                let index = (y * imagePixels.width) + x
                var pixel = newImgPixels.pixels[index]
                let grayValue = max(0,min(255, floor((Float(Float(pixel.red))+Float(Float(pixel.green))+Float(Float(pixel.blue)))/3)))
                pixel.red = UInt8(grayValue)
                pixel.green = UInt8(grayValue)
                pixel.blue = UInt8(grayValue)
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
    
    public func InvertImage() -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<newImgPixels.width{
                let index = (y * newImgPixels.width) + x
                var pixel = newImgPixels.pixels[index]
                pixel.red = UInt8(255 - Int(pixel.red))
                pixel.green = UInt8(255 - Int(pixel.green))
                pixel.blue = UInt8(255 - Int(pixel.blue))
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
    
    public func ReduceBrightness(byPercentage value:Float) -> UIImage? {
        var newImgPixels = imagePixels!
        for y in 0..<newImgPixels.height{
            for x in 0..<newImgPixels.width{
                let index = (y * newImgPixels.width) + x
                var pixel = newImgPixels.pixels[index]
                pixel.alpha = UInt8(max(0, min(255, floor((Float(pixel.alpha)*(value/100))))))
                newImgPixels.pixels[index] = pixel
            }
        }
        return newImgPixels.toUIImage()
    }
}
