//
//  ViewController.swift
//  SampleMLKit
//
//  Created by Heru Prasetia on 8/7/19.
//  Copyright © 2019 NETS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    var processor: ScaledElementProcessor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        if let img = imageView.image {
            imageView.image = img.fixedOrientation()
            if let img2 = imageView.image {
                imageView.image = img2.scaledImage(1000) ?? img2
            }
        }
    }
    
    @IBAction func processImage(_ sender: Any) {
        showLoading()
        print("ImageView.image = \(self.imageView.image)")
        print("ImageView.image.cgImage = \(self.imageView.image?.cgImage)")
        guard let image = self.imageView.image else { return }
        DispatchQueue.global().async() {
            if self.processor == nil {
                self.processor = ScaledElementProcessor()
            }
            if self.processor != nil {
                self.processor?.process(in: image) { text in
                    DispatchQueue.main.async{
                        self.dismiss(animated: true, completion: {
                            self.showAlert(message: text)
                        })
                    }
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            //                self.storeDataToDB(keyValue: "0", keyName: self.IS_REGISTERED)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}

