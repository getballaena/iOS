//
//  QRcodeReaderVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import AVFoundation
import UIKit
import RxSwift
import RxCocoa

class QRCodeReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var flag = BehaviorRelay<String>(value: "")
    var stampViewModel: StampViewModel!
    var gameViewModel: GameViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            bindViewModel(code: stringValue)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension QRCodeReaderVC{
    func bindViewModel(code: String) {
        switch flag.value {
        case "stamp":
            stampViewModel = StampViewModel()
            
            stampViewModel.qrBoothName.accept(code)
            
            stampViewModel.qrDidDone
                .drive(onNext: { isSuccess in
                    self.navigationController?.popViewController(animated: true)
                    
                    if isSuccess {
                        self.showToast(msg: "성공적으로 인식 되었습니다.")
                    } else {
                        self.showToast(msg: "이미 방문한 구역입니다.")
                    }
                })
                .disposed(by: disposeBag)
        case "game":
            gameViewModel.qrBoothName.accept(code.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))
            
            gameViewModel.qrDidDone
                .drive(onNext: { [weak self]  status, data in
                    guard let `self` = self else { return }
                    switch status {
                    case 200:
                        let game = UIStoryboard(name: "Game", bundle: nil)
                        let solve = game.instantiateViewController(withIdentifier: "SolveProblem") as! SolveProblemVC
                        solve.viewModel = self.gameViewModel
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.pushViewController(solve, animated: true)
                    case 409:
                        guard let response = try? JSONDecoder().decode(DelayModel.self, from: data) else { return }
                        self.gameViewModel.qrdelayTime.accept(response.delayTime)
                        self.navigationController?.popViewController(animated: true)
                    case 205:
                        self.gameViewModel.qrdelayTime.accept("team")
                        self.navigationController?.popViewController(animated: true)
                    default:
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                .disposed(by: disposeBag)
            
        default:
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
