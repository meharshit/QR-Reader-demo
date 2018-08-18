//
//  ViewController.swift
//  QR Reader demo
//
//  Created by Harshit Satyaseel on 01/08/18.
//  Copyright © 2018 Harshit Satyaseel. All rights reserved.
//

import UIKit
// added the AV foundation library
import AVFoundation
// Add the delegates methods
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    // create a variable that contains the preview layer
    @IBOutlet weak var myQRCodeImageView: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        
        // define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        // add the capture device to our session
        do{
             let input = try AVCaptureDeviceInput(device: captureDevice!)
             session.addInput(input)
            
        }
        catch{
            print("ERROR")
            
        }
         // the whole is actually decating the qrcode till now no procession is done
        
        let  output = AVCaptureMetadataOutput()
        // add the session
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        // set the frame
        video.frame = view.layer.bounds // it will fill the whole screen
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: myQRCodeImageView)
        // now start running the session so
        session.startRunning()
        
}

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // checking if we have some data to process
        if metadataObjects.count > 0
        {
            // casting it to a machine readble code object
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                // cheching if type id of QR code or not
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    // displaying it as an alert
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert) // here message could be anything suppose a URL you are interested to go to
                    // giving user two options
                    //1. retake
                    //2. copy
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    // present the alert now
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    

}
