//
//  AddNoteViewController.swift
//  W13
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var textDate: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLocation: UITextField!
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textTime: UITextField!
    @IBOutlet var contentView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        contentView.becomeFirstResponder()
        return true
    }
    
    @IBAction func selectPicture (_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNote (_ sender: UIBarButtonItem) {
        let title = textTitle.text!
        let content = contentView.text!
        let date = textDate.text!
        let time = textTime.text!
        let location = textLocation.text!
        
        if (title == "" || content == "" || date == "" || time == "" || location == "") {
            let alert = UIAlertController(title: "내용을 입력하세요", message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return
        }
        
        guard let myImage = imageView.image else {
            let alert = UIAlertController(title: "이미지를 선택하세요", message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return
        }
        
        let myUrl = URL(string: "http://localhost:8888/note/upload.php");
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data;boundary=\(boundary)",forHTTPHeaderField: "Content-Type")
        guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return }
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        // imageData 위 아래로 boundary 정보 추가
        body.append(imageData)
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        var imageFileName: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return; }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { // 서버에 저장한 이미지 파일 이름
                imageFileName = utf8Data
                print(imageFileName)
                semaphore.signal()
            }
        }
        task.resume()
        // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        let urlString: String = "http://localhost:8888/note/insertNote.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID else { return }
        var restString: String = "id=" + userID + "&title=" + title
        restString += "&date=" + date + "&time=" + time + "&location=" + location
        restString += "&image=" + imageFileName
        restString += "&content=" + content
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    
}
