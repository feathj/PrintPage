//
//  Util.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/5/21.
//

import Foundation
import SwiftUI
import CryptoKit

extension NSImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: ScalingMode = .aspectFill) -> NSImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        let scaledImage = NSImage(size: newSize)
        scaledImage.lockFocus()
        draw(in: scaledImageRect)
        scaledImage.unlockFocus()
        
        return scaledImage
    }
}

func saveToCache(cacheKey: String, data: Data) {
    let cachePath = cachePathFromKey(cacheKey: cacheKey)
    try? data.write(to: cachePath)
}
func loadFromCache(cacheKey: String) -> Data? {
    let cachePath = cachePathFromKey(cacheKey: cacheKey)
    do{
        let data = try Data(contentsOf: cachePath)
        return data
    } catch {
        return nil
    }
}
func cachePathFromKey(cacheKey: String) -> URL {
    let urlHash = SHA256.hash(data: Data(cacheKey.utf8)).description
    let cacheHash = urlHash.dropFirst("SHA256 digest: ".count) // Hash description has this prefix, remove
    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

    return cachesDirectory.appendingPathComponent("print-page-cache-" + cacheHash)
}
func clearCache() {
    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    do {
        let fileUrls = try FileManager.default.contentsOfDirectory(at: cachesDirectory,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
        for fileUrl in fileUrls {
            if fileUrl.path.contains("/print-page-cache-"){
                //print(fileUrl.path)
                try FileManager.default.removeItem(at: fileUrl)
            }
        }
        
    } catch { print(error) }
}
