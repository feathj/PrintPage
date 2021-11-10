//
//  PagePreview.swift
//  PrintPage
//
//  Created by Jonathan Featherstone on 11/4/21.
//

import SwiftUI

struct PagePreview: View {
    var link = ""
    var title = ""
    var imageView: RemoteImage

    init(link: String, title: String){
        self.link = link
        self.title = title
        self.imageView = RemoteImage(url: self.link, scaledTo:CGSize(width: 150, height: 150))
    }
    var body: some View {
        VStack{
            self.imageView
            Button("Print", action: print)
        }
    }
    func print(){
        let printInfo = NSPrintInfo()
        printInfo.isVerticallyCentered = false
        printInfo.isHorizontallyCentered = false
        
        // Get printable area from printer
        let bounds = printInfo.imageablePageBounds
        let marginWidth = printInfo.leftMargin + printInfo.rightMargin
        let marginHeight = printInfo.topMargin + printInfo.bottomMargin
        
        // Get image and find orientation (landscape or portrait)
        var image: NSImage?
        let data = loadFromCache(cacheKey: self.link)
        if data != nil {
            image = NSImage(data: data!)
        } else {
            let url = URL(string: self.link)
            image = NSImage(contentsOf: url!)
        }
        let isLandscape = image!.size.width > image!.size.height
       
        // Scale image to printable area based on orientation
        var scaledImage: NSImage
        if isLandscape {
            scaledImage = image!.scaled(to: CGSize(width:bounds.height - marginHeight, height: bounds.width - marginWidth))
        } else {
            scaledImage = image!.scaled(to: CGSize(width:bounds.width - marginWidth, height: bounds.height - marginHeight))
        }

        // Send orientation to printer
        if isLandscape {
            printInfo.orientation = .landscape
        } else {
            printInfo.orientation = .portrait
        }

        // Create new view for print operation
        let printContainerView = NSImageView()
        printContainerView.setFrameSize(NSSize(width: scaledImage.size.width, height: scaledImage.size.height))
        printContainerView.image = scaledImage
        
        // Create a run print operation
        let printOperation = NSPrintOperation(view: printContainerView, printInfo: printInfo)
        printOperation.canSpawnSeparateThread = true
        printOperation.run()
    }
}

struct PagePreview_Previews: PreviewProvider {
    static var previews: some View {
        PagePreview(link: "", title: "")
    }
}
