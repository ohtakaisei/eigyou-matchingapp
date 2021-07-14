//
//  CreateNewUserViewController.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/07.
//

import UIKit
import Firebase
import AVFoundation

class CreateNewUserViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ProfileSendDone {
    
    
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var quickWordTextField: UITextField!
    
    @IBOutlet weak var toProfileButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var player = AVPlayer()
    
    
    var agePicker = UIPickerView()
    var pricePicker = UIPickerView()
    var needPicker = UIPickerView()
    var industryPicker = UIPickerView()
    
//    文字列
    var dataStringArray = [String]()
//    数字
    var dataIntArray = [Int]()
    
    var position = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVideo()
        
        textField2.inputView = agePicker
        textField3.inputView = pricePicker
        textField4.inputView = needPicker
        textField5.inputView = industryPicker
        
        agePicker.delegate = self
        agePicker.dataSource = self
        pricePicker.delegate = self
        pricePicker.dataSource = self
        needPicker.delegate = self
        needPicker.dataSource = self
        industryPicker.delegate = self
        industryPicker.dataSource = self
        
        agePicker.tag = 1
        pricePicker.tag = 2
        needPicker.tag = 3
        industryPicker.tag = 4
        
        position = "ユーザー"
        
        Util.rectButton(button: toProfileButton)
        Util.rectButton(button: doneButton)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//    行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            dataIntArray = ([Int])(18...80)
            return dataIntArray.count
        case 2:
            dataIntArray = Util.price()
            return dataIntArray.count
        case 3:
            dataStringArray = ["生活系","エンタメ系","システム系","集客系","コンサル系","その他"]
            return dataStringArray.count
        case 4:
            dataStringArray = Util.industry()
            return dataStringArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            textField2.text = String(dataIntArray[row]) + "歳"
            textField2.resignFirstResponder()
            break
        case 2:
            textField3.text = String(dataIntArray[row]) + "円"
            textField3.resignFirstResponder()
            break
        case 3:
            textField4.text = dataStringArray[row]
            textField4.resignFirstResponder()
            break
        case 4:
            textField5.text = dataStringArray[row]
            textField5.resignFirstResponder()
            break
        default:
            break
        }
    }
    
//    行に記載する文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return String(dataIntArray[row]) + "歳"
        case 2:
            return String(dataIntArray[row]) + "円"
        case 3:
            return dataStringArray[row]
        case 4:
            return dataStringArray[row]
        default:
            return ""
        }
    }

    @IBAction func positionSwitch(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            position = "ユーザー"
        }else {
            position = "事業者"
        }
    }
    
    @IBAction func done(_ sender: Any) {
        
//        firebaseに値を送信
        let manager = Manager.shared.profile
        
//        送信
        Auth.auth().signInAnonymously{ result, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let range1 = self.textField2.text?.range(of: "歳"){
                self.textField2.text?.replaceSubrange(range1, with: "")
              
            }
            
            if let range2 = self.textField3.text?.range(of: "円"){
                self.textField3.text?.replaceSubrange(range2, with: "")
                
            }
            
            let userdata = UserDataModel(name: self.textField1.text, age: self.textField2.text, price: self.textField3.text, need: self.textField4.text, industry: self.textField5.text, position: self.position, profile: manager, profileImageString: "", uid: Auth.auth().currentUser?.uid, quickWord: self.quickWordTextField.text, hobby: self.textField6.text, date: Date().timeIntervalSince1970, onlineORNot: true)
            
                          
            let sendDBModel = SendDBModel()
            sendDBModel.profileSendDone = self
            sendDBModel.sendProfileData(userData: userdata, profileImageData:(self.imageView.image?.jpegData(compressionQuality: 0.4))!)
        }
        
        
    }

//    タイミング
    func profileSendDone() {
        
        dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func tap(_ sender: Any) {
        
//        カメラorアルバムを起動
        openCamera()
        
        
    }
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
//            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true, completion: nil)
            
        }else{
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            imageView.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
         }
 
    }
 
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setUpVideo(){
            //ファイルパス
            player = AVPlayer(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/matchapp1-2bb07.appspot.com/o/Office%20-%207269.mp4?alt=media&token=f7a42140-77fa-40a8-a114-8e11fbb1893f")!)
        

        //AVPlayer用のレイヤーを生成
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.repeatCount = 0 //無限ループ(終わったらまた再生のイベント後述)
        playerLayer.zPosition = -1
        view.layer.insertSublayer(playerLayer, at: 0)
        
        //終わったらまた再生
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime, //終わったr前に戻す
            object: player.currentItem,
            queue: .main) { (_) in
            
            self.player.seek(to: .zero)//開始時間に戻す
            self.player.play()
            
            
        }

        self.player.play()

        }
        
    
}
