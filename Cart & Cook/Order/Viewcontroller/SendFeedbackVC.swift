//
//  SendFeedbackVC.swift
//  Cart & Cook
//
//  Created by Development  on 08/06/2021.
//

import Foundation
import UIKit
import Photos
import iRecordView
import AVFoundation
import Alamofire
class SendFeedbackVC: UIViewController, AVAudioRecorderDelegate {
    var orderId = ""
    var dateVal = ""
    var total = ""
    var feedbackVM = FeedbackVM()
    var photoDataSouce: [UIImage] = []
    var photoDataSouceUploadedPath: [String] = []
    var audioDatasource: [URL] = []
    var audioDuration: CGFloat = 0
    var photoPath: [String] = []
    let pickerController = UIImagePickerController()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    let now = Date()
    let formatter = DateFormatter()
    var audioUploadedPath = ""
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var photoCV: UICollectionView!
    let custometId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var actionview: SquareView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var orderDetailsView: UIView!{
        didSet{
            orderDetailsView.layer.borderColor = UIColor.black.cgColor
            orderDetailsView.layer.borderWidth = 1
        }
    }
    var myTimer : Timer?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumCvhight: NSLayoutConstraint!
    @IBAction func tapBackgroundAction(_ sender: Any) {
        backView.isHidden = true
        actionview.isHidden = true
        feedbackView.isHidden = true
    }
    @IBOutlet weak var commentsTf: UITextView!{
        didSet{
            commentsTf.layer.borderColor = UIColor.black.cgColor
            commentsTf.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var feedbackView: UIView!
    
    @IBOutlet weak var photosview: UIView!{
        didSet{
            photosview.layer.borderColor = UIColor.black.cgColor
            photosview.layer.borderWidth = 1
        }
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotoActiomn(_ sender: Any) {
        backView.isHidden = false
        actionview.isHidden = false
    }
    override func viewDidLoad() {
        self.dateLabel.text = "Date: " + self.dateVal
        self.totalLabel.text = "Total Amount : " + self.total
        self.orderNumLabel.text = "Order #" + self.orderId
        pickerController.delegate = self
        recordButton.recordView = recordView
        recordView.delegate = self
        playButton.isHidden = true
        slider.isHidden = true
    }
    
    @IBAction func playAudio(_ sender: Any) {
        myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        play()
       
    }
    
    @objc func timerAction(){
        slider.maximumValue = Float(audioDuration)
       let Range =  slider.maximumValue - slider.minimumValue;
       let Increment = Range/100;
       let newval = slider.value + Increment;
       if(Increment <= slider.maximumValue)
       {
           slider.setValue(newval, animated: true)
        if(newval == slider.maximumValue) {
            myTimer?.invalidate()
        }
       }
       else if (Increment >= slider.minimumValue)
       {
           slider.setValue(newval, animated: true)
       }
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        backView.isHidden = true
        actionview.isHidden = true
        pickerController.sourceType = .camera
        present(pickerController, animated: true)
    }
    
    @IBAction func galary(_ sender: Any) {
        backView.isHidden = true
        actionview.isHidden = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    @IBAction func closeFeedback(_ sender: Any) {
        self.feedbackView.isHidden = true
        self.backView.isHidden = true
        
    }
    @IBAction func updateFiles(_ sender: Any) {
        if photoPath.count > 0 {
            for path in self.photoPath {
                let formatter1 = DateFormatter()
                formatter1.timeZone = TimeZone.current
                formatter1.dateFormat = "ddMMyyyyHHmmssSSS"
                let dateString1 = formatter1.string(from: now)

                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss-SSS"
                let dateString = formatter.string(from: now)
                let userId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
                let uploadPath = dateString1 + "/" + "\(userId)" + "/" + orderId + "/" + "Feedback" + "/" + dateString + path
                let parameters: Parameters?
                self.photoDataSouceUploadedPath.append(uploadPath)
                parameters = [
                    "FileName": uploadPath
                ]
                let headers : HTTPHeaders?
                headers = [
                    "accept": "application/json",
                "Content-Type": "application/json"
            ]
                Alamofire.upload(multipartFormData: { (multipart: MultipartFormData) in
                    let fileURL = self.getDocumentsDirectory().appendingPathComponent(path)
                    multipart.append(fileURL, withName: "File" , fileName: uploadPath, mimeType: "image/.jpg")
                   
                    for (key, value) in parameters!{
                        
                        
                        
                        
                        multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)")
                    }
                },usingThreshold: UInt64.init(),
                   to: AppConstants.getBaseUrl() + "Common/PutObject",
                   method: .post,
                   headers: headers,
                   encodingCompletion: { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { [self] (progress) in
                            print("Uploading image")
                            
                        })
                        
                       
                    upload.responseJSON { response in
                       
                        if(self.audioDatasource.count > 0 ){
                            for index in 0...self.audioDatasource.count - 1  {
                                self.voiceUpload(url: "\(self.audioDatasource[index])", index: index)
                            }
                        } else {
                            self.sendFeedbackAction()
                            do {
                                 let fileManager = FileManager.default
                                let fileURL = self.getDocumentsDirectory().appendingPathComponent(path)
                                if fileManager.fileExists(atPath: fileURL.path) {
                                    try fileManager.removeItem(atPath: fileURL.path)
                                    print("File deleted")
                                } else {
                                    print("File does not exist")
                                }
                             
                            }
                            catch let error as NSError {
                                print("An error took place: \(error)")
                            }
                        }
                        
                        
                                 
                    }
                    case .failure(let encodingError):
                        print("err is \(encodingError)")
                            break
                        }
                    })
            }
            
        } else {
            if(self.audioDatasource.count > 0 ) {
                for index in 0...self.audioDatasource.count - 1  {
                    self.voiceUpload(url: "\(self.audioDatasource[index])", index: index)
                }
            } else {
                sendFeedbackAction()
            }
            
        }
        
    }
    fileprivate func  voiceUpload(url: String, index: Int) {
        
        let formatter1 = DateFormatter()
        formatter1.timeZone = TimeZone.current
        formatter1.dateFormat = "ddMMyyyyHHmmssSSS"
        let dateString1 = formatter1.string(from: now)
   
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss-SSS"
        let dateString = formatter.string(from: now)
        let userId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
        let uploadPath = dateString1 + "/" + "\(userId)" + "/" + orderId + "/" + "Feedback" + "/" + dateString + "recording_" + orderId + ".m4a"
        let parameters: Parameters?
        print(uploadPath)
            parameters = [
                "FileName": uploadPath
            ]
            let headers : HTTPHeaders?
            headers = [
                "accept": "application/json",
            "Content-Type": "application/json"
        ]
            Alamofire.upload(multipartFormData: { (multipart: MultipartFormData) in
                
                multipart.append( URL(string: url)!, withName: "File" , fileName: uploadPath, mimeType: "audio/mpeg")
                self.audioUploadedPath = uploadPath
                let pdfData = try! Data(contentsOf: url.asURL())
                                var data : Data = pdfData
                print(pdfData)
                   
                for (key, value) in parameters!{
                    multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)")
                }
            },usingThreshold: UInt64.init(),
               to: AppConstants.getBaseUrl() + "Common/PutObject",
               method: .post,
               headers: headers,
               encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                      print("Uploading pdf")
                    })
                    upload.responseJSON { response in
                        if(index == self.audioDatasource.count - 1) {
                            
                         
                                self.sendFeedbackAction()
                      
                        }
                            }
                case .failure(let encodingError):
                    print("err is \(encodingError)")
                        break
                    }
                })
        
    }
    
    private func sendFeedbackAction() {
        var audioPath: [[String: Any]] = [[String: Any]]()
        if(self.audioDatasource.count > 0 ) {
            for i in 0...0  {
                let item =   [
                    "AudioPath": audioUploadedPath
                ] as [String : Any]
                audioPath.append(item)
            }
           
        }
       
        
        var imagePath: [[String: Any]] = [[String: Any]]()
        if(photoDataSouce.count > 0 ) {
            for i in 0...self.photoDataSouce.count - 1  {
                let item =   [
                    "Path": photoDataSouceUploadedPath[i]
                ] as [String : Any]
            imagePath.append(item)
            }
        }
       
        let comments = commentsTf.text ?? ""
        let customerId = UserDefaults.standard.value(forKey: USERID) as? Int ?? 0
   
    let paramDict =  [
        "CustomerId": customerId,
        "OrderId": self.orderId ,
        "Comments": comments ,
        "AudioPaths":  audioPath ,
        "Paths": imagePath,

    ] as [String : Any]
 

    self.feedbackVM.sentFeedback(paramDict: paramDict){  isSuccess, errorMessage  in
print("aaa", paramDict)
        if let id = self.feedbackVM.responseStatus?.feedbackID {
          print(id)
            self.backView.isHidden = false
            self.feedbackView.isHidden = false
            
        }
    }
    }
}

extension SendFeedbackVC : RecordViewDelegate {
    func onStart() {
        startRecording()
        slider.isHidden = true
        playButton.isHidden = true
    }
    
    func onCancel() {    }
    
    func onFinished(duration: CGFloat) {
        audioDuration = duration
        slider.isHidden = false
        playButton.isHidden = false
    }
    
    
    func startRecording() {
//        if(player.isPlaying) {
//            player.stop()
        audioDatasource = []
            myTimer?.invalidate()
            slider.value = 0
            slider.isHidden = true
//        }
        
        guard let newFileURL = self.createURLForNewRecord() else {
//                   throw RecordingServiceError.canNotCreatePath
            return
               }
               do {
                self.audioDatasource.append(newFileURL)
                   audioRecorder = try AVAudioRecorder(url: newFileURL,
                                                       settings: [AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
                                                                  AVSampleRateKey: 8000,
                                                                  AVNumberOfChannelsKey: 1,
                                                                  AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue])
                   audioRecorder.delegate = self
                   audioRecorder.prepareToRecord()
                   audioRecorder.record(forDuration: 20)
               } catch let error {
                   print("recording error", error)
               }
    }
    
    public func createURLForNewRecord() -> URL? {
        let formatter = DateFormatter()
         formatter.timeZone = TimeZone.current
         formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss-SSS"
         let fileNamePrefix = formatter.string(from: Date())
           
            let fullFileName = "Record_" + fileNamePrefix + ".m4a"
            let newRecordFileName = getDocumentsDirectory().appendingPathComponent(fullFileName)
            return newRecordFileName
    }

    
}


extension SendFeedbackVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.photoDataSouce.append(image)
        var  imageName = UUID().uuidString
        imageName = imageName + ".jpg"
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        self.photoPath.append(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.5) {
            try? jpegData.write(to: imagePath)
        }
       
        self.photoCV.reloadData()
        picker.dismiss(animated: true)
       
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    func getFileURL() -> URL {
//        let formatter = DateFormatter()
//         formatter.timeZone = TimeZone.current
//         formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss-SSS"
//         let dateString = formatter.string(from: Date())
//        let uploadPath =  dateString + self.orderId + "/" + "Feedback" + "/" + dateString  + ".m4a"
//       
//    let path = getDocumentsDirectory().appendingPathComponent("uploadPath")
//    return path as URL
//    }
    
}

extension SendFeedbackVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case photoCV:
            return self.photoDataSouce.count
        default:
            return self.audioDatasource.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case photoCV:
            let cell = photoCV.dequeueReusableCell(withReuseIdentifier: "PhotosCC", for: indexPath) as? PhotosCC
            cell?.phoImageView.image = self.photoDataSouce[indexPath.row]
            cell?.closeImage.tag = indexPath.row
            cell?.closeImage.addTarget(self, action: #selector(closeImageAction(_:)), for: .touchUpInside)
            return cell ?? UICollectionViewCell()
        default:
           
            return  UICollectionViewCell()
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case photoCV:
            return CGSize(width: 200, height: 200)
        default:
            return CGSize(width: collectionView.frame.width, height: 45)
        }
          
    }
   
    
    func play() {
        do {
            print(self.audioDatasource[0])
            self.player = try AVAudioPlayer(contentsOf: self.audioDatasource[0])
            player.prepareToPlay()
            player.volume = 10.0
            player.play()
        
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    @objc func closeImageAction(_ sender:UIButton)
    {
        self.photoDataSouce.remove(at: sender.tag)
        self.photoPath.remove(at: sender.tag)
        self.photoCV.reloadData()
    }

    
    
}
extension SendFeedbackVC: FileManagerDelegate {

    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool {

        print("should move \(srcURL) to \(dstURL)")
        return true
    }

}
