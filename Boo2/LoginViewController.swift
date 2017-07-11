//
//  LoginViewController.swift
//  Boo2
//
//  Created by pmkjkr on 2017. 7. 5..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class LoginViewController: UIViewController {

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var toEmptyButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func loginActionButton(_ sender: Any) {
//                print("\(idTextField.text!), \(pwTextField.text!)")
        
                getJSON(idTextField.text!, pwTextField.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if userDefaults.string(forKey: "stuId") != nil && (userDefaults.string(forKey:"stuPw") != nil){
            getJSON(userDefaults.string(forKey: "stuId")!, userDefaults.string(forKey: "stuPw")!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toastText(_ text:String){
        let toast = Toast(text: text, duration:Delay.short)
        toast.show()
    }
    

    func getJSON(_ id:String, _ pw:String){
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/login"
        let parameters = ["stuId":id, "stuPw":pw]
        let queue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
        var loginIsSuccess = ""
        Alamofire.request(todoEndpoint, method: .post, parameters:parameters, encoding:JSONEncoding(options:[])).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            //                        print(“Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)“)
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    loginIsSuccess = json["result_code"].stringValue
                                    print(json["result_body"])
                                    
                                    //이미 앱 내부에 저장된 ID, PW값 유무를 판별해서 없으면 앱 내부에 저장, 있으면 그냥 넘어감
                                    if self.userDefaults.string(forKey: "stuId") != nil {
                                        print("id:\(self.userDefaults.string(forKey:"stuId")!) 요건 값야 있는고야")

                                    }else{
                                        self.userDefaults.set(id, forKey:"stuId")
                                        self.userDefaults.set(pw, forKey:"stuPw")
                                        print("id:\(self.userDefaults.string(forKey:"stuId")!)")
                                    }

                                }

                            case .failure(let error):
                                print(error)
                                self.toastText("로그인 실패")
                            }
                            
                            DispatchQueue.main.async {
                                //                        print(“Main: \(Thread.current) is main thread: \(Thread.isMainThread)“)
                                
                                //UI 업데이트는 여기
//                                self.tableview.reloadData()
                                if loginIsSuccess == "1"{
                                    self.performSegue(withIdentifier: "toEmpty", sender: self)

                                }else{
                                    print("로그인 실패")
                                    self.toastText("로그인 실패")
                                }
                            
                            }
            }
        )
    }

}
