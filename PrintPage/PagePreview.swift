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
        
        // Get printable area
        let bounds = printInfo.imageablePageBounds
        let marginWidth = printInfo.leftMargin + printInfo.rightMargin
        let marginHeight = printInfo.topMargin + printInfo.bottomMargin
        
        // Get image and resize to printable area
        let url = URL(string: self.link)
        let image = NSImage(contentsOf: url!)
        let scaledImage = image!.scaled(to: CGSize(width:bounds.width - marginWidth, height: bounds.height - marginHeight))

        let printContainerView = NSImageView()
        printContainerView.setFrameSize(NSSize(width: scaledImage.size.width, height: scaledImage.size.height))
        printContainerView.image = scaledImage
        
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
