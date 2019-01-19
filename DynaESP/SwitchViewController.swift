//
//  SwitchViewController.swift
//  DynaESP
//
//  Created by Apple on 26/11/18.
//  Copyright © 2018 Mahesh. All rights reserved.
//

import Foundation
import UIKit

class SwitchViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    var roomname: String = String()
    
    var swaddArray : [String] = [String()]
    var switchnameArray : [String] = [String()]
    var swtypenameArray : [String] = [String()]
    var buttonArray : [String] = [String()]
    var swnoArray : [String] = [String()]
    
    var room1=""
    
    @IBOutlet weak var sw1Text: UITextField!
    
    @IBOutlet weak var sw2Text: UITextField!
    
    @IBOutlet weak var sw3Text: UITextField!
    
    @IBOutlet weak var sw4Text: UITextField!
    
    @IBOutlet weak var sw5Text: UITextField!
    
    @IBOutlet weak var sw6Text: UITextField!
    
    @IBOutlet weak var sw7Text: UITextField!
    
    @IBOutlet weak var sno1: UITextField!
    
    @IBOutlet weak var sno2: UITextField!
    
    @IBOutlet weak var sno3: UITextField!
    
    @IBOutlet weak var sno4: UITextField!
    
    @IBOutlet weak var sno5: UITextField!
    
    @IBOutlet weak var sno6: UITextField!
    
    @IBOutlet weak var sno7: UITextField!
    
    @IBOutlet weak var st1: UIButton!
    
    @IBOutlet weak var st2: UIButton!
    
    @IBOutlet weak var st3: UIButton!
    
    @IBOutlet weak var st4: UIButton!
    
    @IBOutlet weak var st5: UIButton!
    
    
    @IBOutlet weak var st6: UIButton!
    
    @IBOutlet weak var st7: UIButton!
    
    var check1 = false
    var check2 = false
    var check3 = false
    var check4 = false
    var check5 = false
    var check6 = false
    var check7 = false
    
    var pickerData = ["Switch" , "Button" , "Variable" , "Variable2" ,"Dimmer"]
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        room1=roomname
        
        print("this is room name 1 \(roomname)")
        print("this is room name 1 \(room1)")
        sw1Text.delegate=self
        sw2Text.delegate=self
        sw3Text.delegate=self
        sw4Text.delegate=self
        sw5Text.delegate=self
        sw6Text.delegate=self
        sw7Text.delegate=self
        sno1.delegate=self
        sno2.delegate=self
        sno3.delegate=self
        sno4.delegate=self
        sno5.delegate=self
        sno6.delegate=self
        sno7.delegate=self
        
        myPickerView.isHidden=true
        getRoomSwitches()
        
        
        
        
        
        
        
    }
    func getRoomSwitches()
    {
        
        swtypenameArray.removeAll()
        switchnameArray.removeAll()
        swnoArray.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
            print("this is room name \(roomname)")
            let querySQL="SELECT * FROM ROOMSWITCHES WHERE ROOMNAME = \"\(roomname)\" "
            let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
            //print("results set : \(resultSet.s!)")
            var sname: String?
            var stname: String?
            var stno: String?
            
            if (resultSet != nil) {
                while (resultSet?.next())! {
                    sname = resultSet?.string(forColumn: "SWITCHNAME")
                    stname = resultSet?.string(forColumn: "SWITCHTYPE")
                    stno = resultSet?.string(forColumn: "SWITCHNO")
                    
                    if sname == nil{
                        print("no data in room")
                    }
                    else
                    {
                        switchnameArray.append(sname!)
                    }
                    if stname == nil{
                        print("no data in room")
                    }
                    else
                    {
                        swtypenameArray.append(stname!)
                    }
                    if stno == nil{
                        print("no data in room")
                    }
                    else
                    {
                        swnoArray.append(stno!)
                    }
                    
                }
                
            }
            
            print("this is name room array :: \(switchnameArray)")
            print("this is name room array :: \(swtypenameArray)")
            print("this is no room array :: \(swnoArray)")
            myDB?.close()
            if switchnameArray.count>0 && swtypenameArray.count>0{
                
                setData()
            }
            
        }
        
        //setData()
        
    }
    func setData(){
        
        if swtypenameArray.count>0 && switchnameArray.count>0 {
            sw1Text.text=switchnameArray[0]
            sno1.text=swnoArray[0]
            st1.setTitle(swtypenameArray[0], for: .normal)
        }
        if swtypenameArray.count>1 && switchnameArray.count>1{
            sw2Text.text=switchnameArray[1]
            sno2.text=swnoArray[1]
            st2.setTitle(swtypenameArray[1], for: .normal)
        }
        if swtypenameArray.count>2 && switchnameArray.count>2{
            sw3Text.text=switchnameArray[2]
            sno3.text=swnoArray[2]
            st3.setTitle(swtypenameArray[2], for: .normal)
        }
        if swtypenameArray.count>3 && switchnameArray.count>3{
            sw4Text.text=switchnameArray[3]
            sno4.text=swnoArray[3]
            st4.setTitle(swtypenameArray[3], for: .normal)
        }
        if swtypenameArray.count>4 && swtypenameArray.count>4{
            sw5Text.text=swtypenameArray[4]
            sno5.text=swnoArray[4]
            st5.setTitle(swtypenameArray[4], for: .normal)
        }
        if swtypenameArray.count>5 && switchnameArray.count>5{
            sw6Text.text=switchnameArray[5]
            sno6.text=swnoArray[5]
            st6.setTitle(swtypenameArray[5], for: .normal)
        }
        if swtypenameArray.count>6 && switchnameArray.count>6{
            sw7Text.text=switchnameArray[6]
            sno7.text=swnoArray[6]
            st7.setTitle(swtypenameArray[6], for: .normal)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        myPickerView.isHidden=true
        sw1Text.resignFirstResponder()
        sw2Text.resignFirstResponder()
        sw3Text.resignFirstResponder()
        sw4Text.resignFirstResponder()
        sw5Text.resignFirstResponder()
        sw6Text.resignFirstResponder()
        sw7Text.resignFirstResponder()
        sno1.resignFirstResponder()
        sno2.resignFirstResponder()
        sno3.resignFirstResponder()
        sno4.resignFirstResponder()
        sno5.resignFirstResponder()
        sno6.resignFirstResponder()
        sno7.resignFirstResponder()
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "first") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func saveAct(_ sender: Any) {
        
        swaddArray.removeAll()
        buttonArray.removeAll()
        swnoArray.removeAll()
        
        if sw1Text.text?.isEmpty==false && sno1.text?.isEmpty==false{
            swaddArray.append(sw1Text.text!)
            buttonArray.append(st1.currentTitle!)
            swnoArray.append(sno1.text!)
            
        }
        if sw2Text.text?.isEmpty==false && sno2.text?.isEmpty==false{
            swaddArray.append(sw2Text.text!)
            buttonArray.append(st2.currentTitle!)
            swnoArray.append(sno2.text!)
            
        }
        if sw3Text.text?.isEmpty==false && sno3.text?.isEmpty==false{
            swaddArray.append(sw3Text.text!)
            buttonArray.append(st3.currentTitle!)
            swnoArray.append(sno3.text!)
            
        }
        if sw4Text.text?.isEmpty==false && sno4.text?.isEmpty==false{
            swaddArray.append(sw4Text.text!)
            buttonArray.append(st4.currentTitle!)
            swnoArray.append(sno4.text!)
            
        }
        if sw5Text.text?.isEmpty==false && sno5.text?.isEmpty==false{
            swaddArray.append(sw5Text.text!)
            buttonArray.append(st5.currentTitle!)
            swnoArray.append(sno5.text!)
            
        }
        if sw6Text.text?.isEmpty==false && sno6.text?.isEmpty==false{
            swaddArray.append(sw6Text.text!)
            buttonArray.append(st6.currentTitle!)
            swnoArray.append(sno6.text!)
            
        }
        if sw7Text.text?.isEmpty==false && sno7.text?.isEmpty==false{
            swaddArray.append(sw7Text.text!)
            buttonArray.append(st7.currentTitle!)
            swnoArray.append(sno7.text!)
            
        }
        
        print("data are \(swaddArray)")
        print("data are \(buttonArray)")
        print("data are \(swnoArray)")
        
        for i in 0..<swaddArray.count{
            let myDB=FMDatabase(path:databasepathStr as String)
            if(myDB?.open())!
            {
                let querySQL="SELECT * FROM ROOMSWITCHES WHERE ROOMNAME=\"\(roomname)\" AND SWITCHNAME = \"\(swaddArray[i])\" AND SWITCHTYPE = \"\(buttonArray[i])\" AND SWITCHNO = \"\(swnoArray[i])\""
                print("this is your Query :: \(querySQL)")
                let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
                if (resultSet?.next() == true){
                    print("contians")
                    //let myDB=FMDatabase(path:databasepathStr as String)
                    // if(myDB?.open())!{
                    //                    let insertSql="UPDATE ROOMSWITCHES SET SWITCHNAME=\"\((swaddArray[i]))\", SWITCHTYPE=\"\(buttonArray[i])\" WHERE ROOMNAME=\"\(roomname)\" AND SWITCHNAME = \"\(swaddArray[i])\" AND SWITCHTYPE = \"\(buttonArray[i])\""
                    //                        let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                    //                        if (result == true){
                    //                            print("upadte successfully ")
                    //
                    //                        }
                    //                        else{
                    //                            print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                    //                        }
                    //                        myDB?.close()
                    //}
                    
                    
                    
                }
                else{
                    print("data not available")
                    let insertSql="INSERT INTO ROOMSWITCHES (ROOMNAME,SWITCHNAME,SWITCHTYPE,SWITCHNO,OPERATION) VALUES (\"\(roomname)\",\"\((swaddArray[i]))\",\"\(buttonArray[i])\",\"\(swnoArray[i])\",\"OFF\")"
                    print("INSERT INTO ROOMSWITCHES (ROOMNAME,SWITCHNAME,SWITCHTYPE,SWITCHNO,OPERATION) VALUES (\"\(roomname)\",\"\((swaddArray[i]))\",\"\(buttonArray[i])\",\"\(swnoArray[i])\",\"OFF\")")
                    let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                    if (result == true){
                        print("inserted successfully ")
                        
                    }
                    else{
                        print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                    }
                }
                myDB?.close()
                
            }
        }
        let alert = UIAlertController(title: "Room Switches", message: "Added Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        myPickerView.isHidden = true
    }
    @IBAction func st1act(_ sender: Any) {
        check1 = true
        check2 = false
        check3 = false
        check4 = false
        check5 = false
        check6 = false
        check7 = false
        self.pickUp()
        myPickerView.isHidden=false
        sw1Text.resignFirstResponder()
        
        
    }
    @IBAction func st2act(_ sender: Any) {
        self.pickUp()
        check1 = false
        check2 = true
        check3 = false
        check4 = false
        check5 = false
        check6 = false
        check7 = false
        myPickerView.isHidden=false
        sw2Text.resignFirstResponder()
        
    }
    
    @IBAction func st3act(_ sender: Any) {
        self.pickUp()
        myPickerView.isHidden=false
        check1 = false
        check2 = false
        check3 = true
        check4 = false
        check5 = false
        check6 = false
        check7 = false
        sw3Text.resignFirstResponder()
        
    }
    @IBAction func st4act(_ sender: Any) {
        self.pickUp()
        myPickerView.isHidden=false
        check1 = false
        check2 = false
        check3 = false
        check4 = true
        check5 = false
        check6 = false
        check7 = false
        sw4Text.resignFirstResponder()
        
        
    }
    
    @IBAction func st5act(_ sender: Any) {
        self.pickUp()
        myPickerView.isHidden=false
        
        check1 = false
        check2 = false
        check3 = false
        check4 = false
        check5 = true
        check6 = false
        check7 = false
        sw5Text.resignFirstResponder()
        
    }
    @IBAction func st6act(_ sender: Any) {
        self.pickUp()
        myPickerView.isHidden=false
        check1 = false
        check2 = false
        check3 = false
        check4 = false
        check5 = false
        check6 = true
        check7 = false
        sw6Text.resignFirstResponder()
        
    }
    
    @IBAction func st7act(_ sender: Any) {
        self.pickUp()
        myPickerView.isHidden=false
        check1 = false
        check2 = false
        check3 = false
        check4 = false
        check5 = false
        check6 = false
        check7 = true
        sw7Text.resignFirstResponder()
        
        
    }
    
    func pickUp(){
        
        // UIPickerView
        //self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        // self.myPickerView.backgroundColor = UIColor.clear
        
        
        
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (check1==true){
            self.st1.setTitle(pickerData[row], for: .normal)
        }
        if (check2==true){
            self.st2.setTitle(pickerData[row], for: .normal)
        }
        if (check3==true){
            self.st3.setTitle(pickerData[row], for: .normal)
        }
        if (check4==true){
            self.st4.setTitle(pickerData[row], for: .normal)
        }
        if (check5==true){
            self.st5.setTitle(pickerData[row], for: .normal)
        }
        if (check6==true){
            self.st6.setTitle(pickerData[row], for: .normal)
        }
        if (check7==true){
            self.st7.setTitle(pickerData[row], for: .normal)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        myPickerView.isHidden=true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




