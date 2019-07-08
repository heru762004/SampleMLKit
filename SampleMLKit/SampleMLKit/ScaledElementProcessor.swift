//
//  ScaledElementProcessor.swift
//  SampleMLKit
//
//  Created by Heru Prasetia on 8/7/19.
//  Copyright © 2019 NETS. All rights reserved.
//

import Foundation
import Firebase

class ScaledElementProcessor {
    let vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    
    init() {
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    func process(in imageView: UIImageView,
                 callback: @escaping (_ text: String) -> Void) {
        // 1
        var image: UIImage = UIImage()
        DispatchQueue.main.async{
            guard let img = imageView.image else { return }
            image = img
        }
        // 2
        let visionImage = VisionImage(image: image)
        // 3
        textRecognizer.process(visionImage) { result, error in
            // 4
            guard
                error == nil,
                let result = result,
                !result.text.isEmpty
                else {
                    callback("")
                    return
            }
            // 5
            callback(result.text)
        }
    }
}
