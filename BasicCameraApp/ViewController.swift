//
//  ViewController.swift
//  BasicCameraApp
//
//  Created by Aritro Paul on 25/12/17.
//  Copyright © 2017 NotACoder. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabelBackground: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            previewView.bringSubview(toFront: messageLabel)
            previewView.bringSubview(toFront: messageLabelBackground)
            messageLabel.text = "No QR Code Detected"
            
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView{
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                previewView.addSubview(qrCodeFrameView)
                previewView.bringSubview(toFront: qrCodeFrameView)
            }
            
            func metadataOutput(_output: AVCaptureMetadataOutput, didOutput metadataObjects :[ AVMetadataObject], from connection: AVCaptureConnection){
                if (metadataObjects.count == 0) {
                    self.qrCodeFrameView?.frame = CGRect.zero
                    self.messageLabel.text = "No QR Code Detected"
                    return
                }
                let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
                if metadataObj.type == AVMetadataObject.ObjectType.qr{
                    let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                    qrCodeFrameView?.frame = barCodeObject!.bounds
                    
                    if metadataObj.stringValue != nil {
                        messageLabel.text = metadataObj.stringValue
                    }
                }
            }
            
        }catch{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

