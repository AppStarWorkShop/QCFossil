//
//  CameraViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 1/4/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var myView: UIView!
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var prevLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prevLayer?.frame.size = myView.frame.size
    }
    
    func createSession() {
        guard let aDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) else { return }
        let aSession = AVCaptureSession()
        session = aSession
        device = aDevice
        
        do {
            try input = AVCaptureDeviceInput(device: aDevice)
            if let inputValue = input {
                aSession.addInput(inputValue)
                if let aPrevLayer = AVCaptureVideoPreviewLayer(session: aSession) as? AVCaptureVideoPreviewLayer {
                    aPrevLayer.frame.size = myView.frame.size
                    aPrevLayer.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill))
                    
                    aPrevLayer.connection?.videoOrientation = transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
                    
                    myView.layer.addSublayer(aPrevLayer)
                    aSession.startRunning()
                    
                    prevLayer = aPrevLayer
                }
            }
        } catch let error as NSError {
            print("camera input error: \(error)")
        }
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        for device in devices {
            if (device as AnyObject).position == position {
                return device as AVCaptureDevice
            }
        }
        return nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.prevLayer?.connection?.videoOrientation = self.transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.prevLayer?.frame.size = self.myView.frame.size
            }, completion: { (context) -> Void in
                
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func transformOrientation(_ orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    @IBAction func switchCameraSide(_ sender: AnyObject) {
        if let sess = session {
            let currentCameraInput: AVCaptureInput = sess.inputs[0] 
            sess.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                newCamera = self.cameraWithPosition(.front)!
            } else {
                newCamera = self.cameraWithPosition(.back)!
            }
            
            do {
                let newVideoInput:AVCaptureInput
                try newVideoInput = AVCaptureDeviceInput(device: newCamera)
                session?.addInput(newVideoInput)
            } catch let error as NSError {
                print(error)
            }
            
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
	return input.rawValue
}
