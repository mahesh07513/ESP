//
//  SettingsViewController.swift
//  DynaESP
//
//  Created by Apple on 16/04/18.
//  Copyright © 2018 Mahesh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    
    
    var addcheck: Bool?
    var roomname: String?
    var roomArray : [String] = [String()]
    var internalIpArry : [String] = [String()]
    var externalIpArray : [String] = [String()]
    
    var addcheck1: Bool?
    var roomname1: String?
    var roomArray1 : [String] = [String()]
    var internalIpArry1 : [String] = [String()]
    var externalIpArray1 : [String] = [String()]

    @IBOutlet weak var ssidText: UITextField!
    
    @IBOutlet weak var saveVar: UIButton!
    
    @IBOutlet weak var segVar2: UISegmentedControl!
    
    @IBOutlet weak var boardText: UITextField!
    
    @IBOutlet weak var IntIpText: UITextField!
    
    @IBOutlet weak var extIptext: UITextField!
    
    @IBOutlet weak var addVar: UIButton!
    
    @IBOutlet weak var dataSettings: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let attr = NSDictionary(object: UIFont(name: "Helvetica", size: 16.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        self.segVar2.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        dataSettings.delegate=self
        dataSettings.dataSource=self
        dataSettings.backgroundColor=UIColor.clear
        dataSettings.rowHeight=60
    
        dataSettings.reloadData()
        if (UserDefaults.standard.object(forKey: "ssid") != nil){
            
            let defaults12 = UserDefaults.standard
            let uname1 = defaults12.value(forKey: "ssid")
            ssidText.text=uname1 as? String
            
            
        }else{
            
            print("external ip nil")
        }
        
        ssidText.delegate=self
        boardText.delegate=self
        IntIpText.delegate=self
        extIptext.delegate=self
        
        addcheck=false
        addcheck1=false
        segVar2.selectedSegmentIndex=0
        boardText.placeholder="room name"
        getRoomsDataFromDB()
        
        
 
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func SaveAction(_ sender: Any) {
        if ssidText.text?.isEmpty==true{
            let alert = UIAlertController(title: "SSID", message: "Please fill the SSID", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let defaults44 = UserDefaults.standard
            defaults44.set(ssidText.text!, forKey: "ssid")
            let alert = UIAlertController(title: "SSID", message: "SSID Saved Successfully ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @IBAction func backAct(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "first") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func seg2Action(_ sender: Any) {
        
        if segVar2.selectedSegmentIndex==0{
            boardText.placeholder="room name"
            getRoomsDataFromDB()
            
        }
        if segVar2.selectedSegmentIndex==1{
            boardText.placeholder="group name"

            getgroupsfromDB()
        }

    }
    
    // Adding the Rooms/Boards
    @IBAction func AddAction(_ sender: Any) {
        //segment 0
        if segVar2.selectedSegmentIndex==0{
            
            if addcheck==false{
                if boardText.text?.isEmpty==true && IntIpText.text?.isEmpty==true && extIptext.text?.isEmpty==true {
                    print("empty string")
                    let alert = UIAlertController(title: "Add Room", message: "Please fill the Fileds", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    print("data string")
                    let myDB=FMDatabase(path:databasepathStr as String)
                    if(myDB?.open())!{
                        let querySQL="SELECT * FROM ROOMS WHERE ROOMNAME=\"\(boardText.text!)\""
                        print("this is your Query :: \(querySQL)")
                        let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
                        if (resultSet?.next() == true){
                            print("contians")
                            let alert = UIAlertController(title: "Room", message: "Alreay Room Exists. Please change your Room name", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else{
                            print("data not available")
                            let insertSql="INSERT INTO ROOMS (ROOMNAME,INTERNALIP,EXTERNALIP) VALUES (\"\(boardText.text!)\",\"\(IntIpText.text!)\",\"\(extIptext.text!)\")"
                            let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                            if (result == true){
                                print("inserted successfully ")
                                let alert = UIAlertController(title: "Room", message: " Added Successfully", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                getRoomsDataFromDB()
                            }
                            else{
                                print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                            }
                        }
                        myDB?.close()
                        boardText.text=""
                        IntIpText.text=""
                        extIptext.text=""
                        

                        
                    }
                   
                }
            }
            else{
                let myDB=FMDatabase(path:databasepathStr as String)
                if(myDB?.open())!{
                    let insertSql="UPDATE ROOMS SET INTERNALIP=\"\(IntIpText.text!)\", EXTERNALIP=\"\(extIptext.text!)\" WHERE ROOMNAME=\"\(roomname!)\""
                    let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                    if (result == true){
                        print("upadte successfully ")
                        let alert = UIAlertController(title: "Room", message: "Updated Successfully", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                    }
                    myDB?.close()
                }
                boardText.text=""
                IntIpText.text=""
                extIptext.text=""
                getRoomsDataFromDB()
            }
        }
    //segment 1
        if segVar2.selectedSegmentIndex==1{
            
            if addcheck1==false{
                if boardText.text?.isEmpty==true && IntIpText.text?.isEmpty==true && extIptext.text?.isEmpty==true {
                    print("empty string")
                    let alert = UIAlertController(title: "Add Group", message: "Please fill the Fileds", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    print("data string")
                    let myDB=FMDatabase(path:databasepathStr as String)
                    if(myDB?.open())!{
                        let querySQL="SELECT * FROM GROUPS WHERE GROUPNAME=\"\(boardText.text!)\""
                        print("this is your Query :: \(querySQL)")
                        let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
                        if (resultSet?.next() == true){
                            print("contians")
                            let alert = UIAlertController(title: "Group", message: "Alreay Group Exists. Please change your Group name", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else{
                            print("data not available")
                            let insertSql="INSERT INTO GROUPS (GROUPNAME,INTERNALIP,EXTERNALIP) VALUES (\"\(boardText.text!)\",\"\(IntIpText.text!)\",\"\(extIptext.text!)\")"
                            let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                            if (result == true){
                                print("inserted successfully ")
                                let alert = UIAlertController(title: "Group", message: " Added Successfully", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                getgroupsfromDB()
                            }
                            else{
                                print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                            }
                        }
                        myDB?.close()
                        boardText.text=""
                        IntIpText.text=""
                        extIptext.text=""
                    }
                    
                }
            }
            else{
                let myDB=FMDatabase(path:databasepathStr as String)
                if(myDB?.open())!{
                    let insertSql="UPDATE GROUPS SET INTERNALIP=\"\(IntIpText.text!)\", EXTERNALIP=\"\(extIptext.text!)\" WHERE GROUPNAME=\"\(roomname!)\""
                    let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                    if (result == true){
                        print("updated success fully ")
                        let alert = UIAlertController(title: "Group", message: "Updated Successfully", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                    }
                    myDB?.close()
                }
                boardText.text=""
                IntIpText.text=""
                extIptext.text=""
                getgroupsfromDB()
            }
        }
        self.boardText.isEnabled = true
    
        
        
}
    
    func getRoomsDataFromDB()
    {
        addcheck=false
        roomArray.removeAll()
        internalIpArry.removeAll()
        externalIpArray.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
            let querySQL="SELECT * FROM ROOMS"
            let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
            //print("results set : \(resultSet.s!)")
            var rname: String?
            var iname: String?
            var ename: String?
            if (resultSet != nil) {
                while (resultSet?.next())! {
                    rname = resultSet?.string(forColumn: "ROOMNAME")
                    iname = resultSet?.string(forColumn: "INTERNALIP")
                    ename = resultSet?.string(forColumn: "EXTERNALIP")
                   
                    if rname == nil{
                        print("no data in room")
                    }
                    else{
                        roomArray.append(rname!)
                    }
                    if iname == nil{
                        print("no data int ip")
                    }
                    else{
                        internalIpArry.append(iname!)
                    }
                    if ename == nil{
                        print("no data ex ip")
                    }else{
                        externalIpArray.append(ename!)
                    }
                }
            }
            
            
//            if (roomArray.count == 0){
//
//            }
//            else{
//                roomArray.remove(at: 0)
//            }
//            if (internalIpArry.count == 0){
//
//            }else{
//                internalIpArry.remove(at: 0)
//            }
//            if (externalIpArray.count == 0){
//
//            }
//            else{
//                externalIpArray.remove(at: 0)
//            }
            print("this is name room array :: \(roomArray)")
            print("this is name on int ip array :: \(internalIpArry)")
            print("this is name off ext array :: \(externalIpArray)")
            myDB?.close()
            
            
        }
        
        dataSettings.reloadData()
        
    }
    func getgroupsfromDB(){
        addcheck1=false
        roomArray1.removeAll()
        internalIpArry1.removeAll()
        externalIpArray1.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
            let querySQL="SELECT * FROM GROUPS"
            let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
            //print("results set : \(resultSet.s!)")
            var gname: String?
            var iname: String?
            var ename: String?
            if (resultSet != nil) {
                while (resultSet?.next())! {
                    gname = resultSet?.string(forColumn: "GROUPNAME")
                    iname = resultSet?.string(forColumn: "INTERNALIP")
                    ename = resultSet?.string(forColumn: "EXTERNALIP")
                    
                    if gname == nil{
                        print("no data in room")
                    }
                    else{
                        roomArray1.append(gname!)
                    }
                    if iname == nil{
                        print("no data int ip")
                    }
                    else{
                        internalIpArry1.append(iname!)
                    }
                    if ename == nil{
                        print("no data ex ip")
                    }else{
                        externalIpArray1.append(ename!)
                    }
                }
            }
            
          
            print("this is name room array :: \(roomArray1)")
            print("this is name on int ip array :: \(internalIpArry1)")
            print("this is name off ext array :: \(externalIpArray1)")
            myDB?.close()
            
            
        }
        
        dataSettings.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var data:Int = Int()
        if segVar2.selectedSegmentIndex==0{
            data=roomArray.count
        }
        if segVar2.selectedSegmentIndex==1{
            data=roomArray1.count
        }
        
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.backgroundColor=UIColor.init(white: 0.5, alpha: 0.5)
        cell.selectionStyle = .none
        cell.textLabel?.textColor=UIColor.init(white: 1.0, alpha: 1.0)
        cell.textLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds=true
        cell.textLabel?.textAlignment = .center
        
        if segVar2.selectedSegmentIndex==0{
        cell.textLabel?.text=roomArray[indexPath.row]+" : "+internalIpArry[indexPath.row]+" : "+externalIpArray[indexPath.row]
        }
        if segVar2.selectedSegmentIndex==1{
            cell.textLabel?.text=roomArray1[indexPath.row]+" : "+internalIpArry1[indexPath.row]+" : "+externalIpArray1[indexPath.row]
        }
        
        
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            //TODO: edit the row at indexPath here
            if self.segVar2.selectedSegmentIndex==0{
                
                let alertController = UIAlertController(title: "\(self.roomArray[indexPath.row])", message: "do you want to edit?", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.boardText.text=self.roomArray[indexPath.row]
                    self.boardText.isEnabled = false
                    self.IntIpText.text = self.internalIpArry[indexPath.row]
                    self.extIptext.text = self.externalIpArray[indexPath.row]
                    self.addcheck=true
                    self.roomname=self.roomArray[indexPath.row]
                 }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            if self.segVar2.selectedSegmentIndex==1{
                
                let alertController = UIAlertController(title: "\(self.roomArray1[indexPath.row])", message: "do you want to edit?", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.boardText.text=self.roomArray1[indexPath.row]
                    self.boardText.isEnabled = false
                    self.IntIpText.text = self.internalIpArry1[indexPath.row]
                    self.extIptext.text = self.externalIpArray1[indexPath.row]
                    self.addcheck1=true
                    self.roomname=self.roomArray1[indexPath.row]
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            if self.segVar2.selectedSegmentIndex==0{
                let alertController = UIAlertController(title: "\(self.roomArray[indexPath.row])", message: "do you want to delete?", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    let myDB=FMDatabase(path:databasepathStr as String)
                    if(myDB?.open())!{
                        let insertSql="DELETE from ROOMS WHERE ROOMNAME=\"\(self.roomArray[indexPath.row])\""
                        let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                        if (result == true){
                            print("delete success fully ")
                            
                        }else{
                            print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                        }
                        myDB?.close()
                    }
                    
                    self.getRoomsDataFromDB()
                    
                    
                    
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            if self.segVar2.selectedSegmentIndex==1{
                let alertController = UIAlertController(title: "\(self.roomArray1[indexPath.row])", message: "do you want to delete?", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    let myDB=FMDatabase(path:databasepathStr as String)
                    if(myDB?.open())!{
                        let insertSql="DELETE from GROUPS WHERE GROUPNAME=\"\(self.roomArray1[indexPath.row])\""
                        let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                        if (result == true){
                            print("delete success fully ")
                            
                        }else{
                            print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                        }
                        myDB?.close()
                    }
                    
                    self.getgroupsfromDB()
                    
                    
                    
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
