//
//  DCCameraCapture.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/12/5.
//
import UIKit
import AVFoundation

public class DCCameraCapture:UIView,AVCapturePhotoCaptureDelegate{
    
    public weak var delegate:DCCameraCaptureDelegate?
    
    private let captureQueue = DispatchQueue(label: "DCCameraCaptureQueue")
        
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var videoDeviceInput: AVCaptureDeviceInput?
    
    private var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .iFrame1280x720
        return session
    }()
    
    private var photoOutput: AVCapturePhotoOutput?
        
    public convenience init(devicePosition: AVCaptureDevice.Position) {
        self.init(frame: .zero)
        backgroundColor = .black
        guard let device = AVCaptureDevice.default(for: .video) else {
            self.performDelayedAction {
                self.delegate?.deviceError?()
            }
            return
        }
        let status = DCSystemPermissionHelper.shared.authorizationStatus(with: .camera)
        if status == .notDetermined{
            self.performDelayedAction {
                self.delegate?.requestCameraPermission?()
            }
            DCSystemPermissionHelper.shared.request(with: .camera) { granted in
                if granted{
                    self.performDelayedAction {
                        self.delegate?.cameraAuthorizationAuthorized?()
                    }
                    self.setupCaptureSession(for: device, position: devicePosition)
                }else{
                    self.performDelayedAction {
                        self.delegate?.cameraAuthorizationNotDetermined?()
                    }
                }
            }
        } else if status == .authorized{
            self.setupCaptureSession(for: device, position: devicePosition)
            self.performDelayedAction {
                self.delegate?.cameraAuthorizationAuthorized?()
            }
        } else{
            self.performDelayedAction {
                self.delegate?.cameraAuthorizationFailed?()
            }
        }
    }
        
    private func performDelayedAction(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
        
    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
    
    private func setupCaptureSession(for device: AVCaptureDevice, position: AVCaptureDevice.Position) {
        do {
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device) else {
                self.delegate?.deviceError?()
                return
            }
            
            photoOutput = AVCapturePhotoOutput()
            let imageSettings: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.jpeg]
            let imageSetting = AVCapturePhotoSettings(format: imageSettings)
            photoOutput?.photoSettingsForSceneMonitoring = imageSetting
            
            if captureSession.canAddInput(videoDeviceInput), captureSession.canAddOutput(photoOutput!) {
                captureSession.addInput(videoDeviceInput)
                captureSession.addOutput(photoOutput!)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = self.bounds
            self.layer.addSublayer(previewLayer!)
            
            for d in AVCaptureDevice.DiscoverySession(
                deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                mediaType: AVMediaType.video,
                position: position).devices {
                if d.position == position {
                    previewLayer?.session?.beginConfiguration()
                    guard let input = try? AVCaptureDeviceInput(device: d) else {
                        self.delegate?.deviceError?()
                        break
                    }
                    
                    for oldInput in (previewLayer?.session?.inputs)! {
                        previewLayer?.session?.removeInput(oldInput)
                    }
                    
                    previewLayer?.session?.addInput(input)
                    previewLayer?.session?.commitConfiguration()
                    break
                }
            }
            
            self.performDelayedAction {
                self.delegate?.cameraEnabled?()
            }
            
            beginCapture()
        }
    }

        
    public func beginCapture() {
        captureQueue.async { [weak self] in
            guard let this = self else { return }
            this.captureSession.startRunning()
        }
    }
        
    public func destroyCapture() {
        videoDeviceInput = nil
        photoOutput = nil
    }
        
    public func stopCapture() {
        captureSession.stopRunning()
    }
        
    public func takePicture() {
        photoOutput?.capturePhoto(with: AVCapturePhotoSettings.init(format: [
            AVVideoCodecKey : AVVideoCodecType.jpeg
        ]), delegate: self)
    }

    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        stopCapture()
        let data = photo.fileDataRepresentation()
        if data != nil {
            guard let image = UIImage.init(data: data!) else { return }
            self.delegate?.didCapturePhoto(image)
        }
    }
}

@objc public protocol DCCameraCaptureDelegate: NSObjectProtocol {
    
    @objc optional func deviceError()
    
    func didCapturePhoto(_ image: UIImage)
    
    @objc optional func cameraAuthorizationNotDetermined()
    
    @objc optional func cameraAuthorizationFailed()
    
    @objc optional func cameraAuthorizationAuthorized()
    
    @objc optional func cameraEnabled()
    
    @objc optional func requestCameraPermission()
    
}
