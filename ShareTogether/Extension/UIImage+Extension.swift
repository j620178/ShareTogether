//
//  UIImage+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/26.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static var user: UIImage {
        
        return UIImage(named: "user")!
    }
    
    // swiftlint:disable all
    func fixOrientation() -> UIImage {
        
        if self.imageOrientation == UIImage.Orientation.up {
            
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
            
        case .down, .downMirrored:
            
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            
        case .right, .rightMirrored:
            
            transform = transform.translatedBy(x: 0, y: self.size.height)
            
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            
        case .up, .upMirrored:
            
            break
            
        @unknown default:
            
            break
        }
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            
            transform = transform.translatedBy(x: self.size.height, y: 0)
            
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            
            break
            
        }
        
        let ctx = CGContext(data: nil,
                            width: Int(self.size.width),
                            height: Int(self.size.height),
                            bitsPerComponent: self.cgImage!.bitsPerComponent,
                            bytesPerRow: 0,
                            space: self.cgImage!.colorSpace!,
                            bitmapInfo: UInt32(self.cgImage!.bitmapInfo.rawValue))
        
        ctx!.concatenate(transform)
        
        switch self.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            
            ctx?.draw(self.cgImage!,
                      in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            
        default:
            
            ctx?.draw(self.cgImage!,
                      in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            
        }
        
        let cgimg = ctx!.makeImage()
        
        let img = UIImage(cgImage: cgimg!)
        
        return img
    }
    // swiftlint:enable all
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        
        if widthRatio > heightRatio {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        return newImage!
    }
}
