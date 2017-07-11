//
//  MasterViewController.swift
//  Boo2
//
//  Created by pmkjkr on 2017. 7. 5..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class MasterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var topPickerView: UIPickerView!
    @IBOutlet var selectButton: UIButton!
    
    let dayList = ["월", "화", "수", "목", "금"]
    let fromTimeList = ["3(09:00~09:30)", "4(09:30~10:00)", "5(10:00~10:30)", "6(10:30~11:00)", "7(11:00~11:30)", "8(11:30~12:00)", "9(12:00~12:30)", "10(12:30~13:00)", "11(13:00~13:30)", "12(13:30~14:00)", "13(14:00~14:30)", "14(14:30~15:00)", "15(15:00~15:30)", "16(15:30~16:00)", "17(16:00~16:30)", "18(16:30~17:00)", "19(17:00~17:30)", "20(17:30~18:00)"]
    var toTimeList = ["3(09:00~09:30)", "4(09:30~10:00)", "5(10:00~10:30)", "6(10:30~11:00)", "7(11:00~11:30)", "8(11:30~12:00)", "9(12:00~12:30)", "10(12:30~13:00)", "11(13:00~13:30)", "12(13:30~14:00)", "13(14:00~14:30)", "14(14:30~15:00)", "15(15:00~15:30)", "16(15:30~16:00)", "17(16:00~16:30)", "18(16:30~17:00)", "19(17:00~17:30)", "20(17:30~18:00)"]
    
    var selectedDay = "월"
    var selectedFromTime = "3(09:00~09:30)"
    var selectedToTime = "3(09:00~09:30)"
    
    var numberOfList:JSON = [:]
    
    @IBOutlet var tableview: UITableView!

    //switch
    @IBAction func switchAction(_ sender: AnyObject) {
        if sender.isOn == true{
            topPickerView.isHidden = false
            selectButton.isHidden = false
        }else{
            topPickerView.isHidden = true
            selectButton.isHidden = true
        }
        
    }
    
    func toastText(_ text:String){
        let toast = Toast(text: text, duration:Delay.short)
        toast.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //select button
    @IBAction func showEmptyRoom(_ sender: AnyObject) {
        if selectedDay == "월"{
            selectedDay = "1"
        }else if selectedDay == "화"{
            selectedDay = "2"
        }else if selectedDay == "수"{
            selectedDay = "3"
        }else if selectedDay == "목"{
            selectedDay = "4"
        }else if selectedDay == "금"{
            selectedDay = "5"
        }
        print("day:\(selectedDay), from:\(selectedFromTime), to:\(selectedToTime)")
        getJSON(selectDay: selectedDay, toTime: selectedToTime, fromTime: selectedFromTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return dayList.count
        }else if component == 1{
            return fromTimeList.count
        }else{
            return toTimeList.count
        }
    }
    
    //PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return dayList[row]
        }else if component == 1{
            return fromTimeList[row]
        }else{
            return toTimeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            selectedDay = dayList[row]
        }else if component == 1 {
            toTimeList = []
            for i in row..<fromTimeList.count{
                toTimeList.append(fromTimeList[i])
            }
            selectedFromTime = fromTimeList[row]
            pickerView.selectRow(0, inComponent: 2, animated: true)
            selectedToTime = toTimeList[0]
        }else if component == 2{
            selectedToTime = toTimeList[row]
        }
        pickerView.reloadAllComponents()
    }


    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! EmptyRoomCustomCell
        cell.backgroundColor = UIColor.clear
        cell.emptyRoomLabel.text! = numberOfList[indexPath.row]["room_no"].stringValue
        return cell
    }

    
    func getJSON(selectDay day:String, toTime to:String, fromTime from:String){
        let todoEndpoint: String = "https://www.dongaboomin.xyz:20433/donga/empty/room?day=\(day)&from=\(from)&to=\(to)"
        let queue = DispatchQueue(label: "com.Boo", qos: .utility, attributes: [.concurrent])
        Alamofire.request(todoEndpoint, method: .get).validate()
            .responseJSON(queue: queue,
                          completionHandler : { response in
                            switch response.result{
                            case .success(let value):
                                let json = JSON(value)
                                if json["result_code"] == 1{
                                    self.numberOfList = json["result_body"]
                                }else{
                                    self.toastText("불러오기 실패")
                                }
                            case .failure(let error):
                                print(error)
                                self.toastText("불러오기 실패")
                            }
                            
                            DispatchQueue.main.async {
                                //UI 업데이트는 여기
                                self.tableview.reloadData()
                            }
            }
        )
    }

}
