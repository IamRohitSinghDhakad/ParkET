//
//  EnhancedFineViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class EnhancedFineViewController: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var tfFineamount: UITextField!
    @IBOutlet weak var tfDueDate: UITextField!
    
    let datePicker = UIDatePicker()
    var obj : BookingModel?
    
    var isSelected = ""
    var strVideoUrl : URL?

      override func viewDidLoad() {
          super.viewDidLoad()
          setupDatePicker()
      }
      
      func setupDatePicker() {
          // Configure DatePicker
          datePicker.datePickerMode = .date
          datePicker.preferredDatePickerStyle = .wheels // Old-style wheel picker
          datePicker.minimumDate = Date() // Restrict past dates

          // Assign DatePicker to TextField
          tfDueDate.inputView = datePicker
          
          // Add toolbar with Done button
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
          
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
          let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          toolbar.setItems([space, doneButton], animated: false)
          
          tfDueDate.inputAccessoryView = toolbar
      }
      
      @objc func doneDatePicker() {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          tfDueDate.text = formatter.string(from: datePicker.date)
          tfDueDate.resignFirstResponder() // Dismiss picker
      }
    
    @IBAction func btnOnback(_ sender: Any) {
        self.onBackPressed()
    }
    
  
    @IBAction func btnOnSubmit(_ sender: Any) {
        if self.isSelected == "image"{
            self.callWebserviceForAddFineViaImage()
        }else if self.isSelected == "video"{
            self.callWebserviceForAddVideo(videoURL: strVideoUrl ?? URL(fileURLWithPath: ""))
        }else{
            objAlert.showAlert(message: "Please pick image/video", controller: self)
        }
        
    }
    
    @IBAction func btnAddImage(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Select Media", message: "Choose an option", preferredStyle: .actionSheet)
                
                // Option to pick an image
                actionSheet.addAction(UIAlertAction(title: "Pick Image", style: .default, handler: { _ in
                    MediaPicker.shared.pickMedia(from: self) { imag, dict in
                        print(imag as Any)
                        print(dict as Any)
                        self.isSelected = "image"
                        self.imgVw.image = imag
                    }
                }))
                
                // Option to pick a video
                actionSheet.addAction(UIAlertAction(title: "Pick Video", style: .default, handler: { _ in
                    MediaPicker.shared.pickVideo(from: self) { strUrl, imag, dict in
                        print(strUrl as Any)
                        print(imag as Any)
                        print(dict as Any)
                        self.isSelected = "video"
                        self.strVideoUrl = strUrl
                        self.imgVw.image = imag
                        
                    }
                }))
                
                // Cancel button
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                // For iPad support
                if let popoverController = actionSheet.popoverPresentationController {
                    popoverController.sourceView = sender as? UIView
                    popoverController.sourceRect = (sender as AnyObject).bounds
                }
                
                present(actionSheet, animated: true, completion: nil)
    }
    
}

extension EnhancedFineViewController{
    
    
//    func callWebserviceForOtherFine(){
//        
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//        objWebServiceManager.showIndicator()
//        self.view.endEditing(true)
//        
//        var imageData = [Data]()
//        var imgData : Data?
//        if self.pickedImage != nil{
//            imgData = (self.pickedImage?.jpegData(compressionQuality: 0.5))!
//        }
//        else {
//            imgData = (self.imgvw.image?.jpegData(compressionQuality: 0.5))!
//        }
//        imageData.append(imgData!)
//        
//        let imageParam = ["image"]
//        
//        let params: [String: Any] = [
//            "booking_id": obj?.id ?? "",
//            "attender_id": objAppShareData.UserDetail.strUser_id,
//            "fine_type":"Other",
//            "ticket_number":"",
//            "fine_amount":self.tfFineamount.text!,
//            "description":"",
//            "due_date":self.tfDueDate.text!
//        ]
//        
//        print(params)
//        
//        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddFine, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "image", mimeType: "image/jpeg") { (response) in
//            objWebServiceManager.hideIndicator()
//            print(response)
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//            
//            if status == MessageConstant.k_StatusCode{
//                
//                guard let user_details  = response["result"] as? [String:Any] else{
//                    return
//                }
//                
//                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: "Message submitted successfully".localized(), controller: self) {
//                    self.onBackPressed()
//                }
//                
//                
//            }else{
//                objWebServiceManager.hideIndicator()
//                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
//            }
//        } failure: { (Error) in
//            print(Error)
//        }
//    }
    
    
    func callWebserviceForAddFineViaImage(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageDataArray = [Data]()
        var imageParam = [String]()

              
        if let imgData = self.imgVw.image?.jpegData(compressionQuality: 0.5) {
            imageDataArray.append(imgData)
            imageParam.append("image")
        }
        
        print(imageDataArray)
        print(imageParam)
       
        
        let params: [String: Any] = [
                    "booking_id": obj?.id ?? "",
                    "attender_id": objAppShareData.UserDetail.strUser_id,
                    "fine_type":"Other",
                    "ticket_number":"",
                    "fine_amount":self.tfFineamount.text!,
                    "description":"",
                    "due_date":self.tfDueDate.text!
                ]
        
        
        print(params)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddFine, params: params, showIndicator: true, customValidation: "", imageData: nil, imageToUpload: imageDataArray, imagesParam: imageParam, fileName: "image", mimeType: "images/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                self.onBackPressed()
                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
    func callWebserviceForAddVideo(videoURL: URL) {
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)

        // Convert video URL to Data
        guard let videoData = try? Data(contentsOf: videoURL) else {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Failed to process video file.", title: "Error", controller: self)
            return
        }
        
        print(videoData)

        // Prepare the parameters
        let params: [String: Any] = [
                    "booking_id": obj?.id ?? "",
                    "attender_id": objAppShareData.UserDetail.strUser_id,
                    "fine_type":"Other",
                    "ticket_number":"",
                    "fine_amount":self.tfFineamount.text!,
                    "description":"",
                    "due_date":self.tfDueDate.text!
                ]

        print(params)

        // Use existing upload function
        objWebServiceManager.uploadMultipartWithImagesData(
            strURL: WsUrl.url_AddFine,
            params: params,
            showIndicator: true,
            customValidation: "",
            imageData: videoData,                  // Pass video data as imageData
            imageToUpload: [videoData],            // Pass video data array
            imagesParam: ["video"],                // Pass "Video" as the key
            fileName: "video",                 // Set video filename
            mimeType: "video/mp4"                  // Set video MIME type
        ) { response in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)

            if status == MessageConstant.k_StatusCode {
                self.onBackPressed()
            } else {
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { error in
            print(error)
        }
    }
}
