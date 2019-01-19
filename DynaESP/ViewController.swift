//
//  ViewController.swift
//  DynaESP
//
//  Created by Apple on 08/03/18.
//  Copyright © 2018 Mahesh. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

var ssidName1: String?
var url1: String?
var urlint1: String?
var urlext1: String?
var chechdataurlint1: Bool?
var chechdataurlext1: Bool?

var databasepathStr = NSString()
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var MainroomArray : [String] = [String()]
    var MaingroupArray : [String] = [String()]
    
    var gintArray : [String] = [String()]
    var gextArray : [String] = [String()]

    @IBOutlet weak var segVar1: UISegmentedControl!
    @IBOutlet weak var tableData1: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let attr = NSDictionary(object: UIFont(name: "Helvetica", size: 16.0)!, forKey: NSAttributedStringKey.font as NSCopying)
        self.segVar1.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        reachNetwork()
        
        
        tableData1.delegate=self
        tableData1.dataSource=self
        tableData1.backgroundColor=UIColor.clear
        tableData1.rowHeight=60
        tableData1.reloadData()
        
        
        dbCreation()
        segVar1.selectedSegmentIndex=0
        getRooms()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appeer")
    }
    
    
    @objc func didBecomeActive() {
        print("did become active login")
        reachNetwork();
        
    }
    
    @objc func willEnterForeground() {
        print("will enter foreground login")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Reach().monitorReachabilityChanges()
        //reachNetwork()
        
    }
    func reachNetwork(){
        print("in reach login")
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected login")
            let alert = UIAlertController(title: "Network ", message: "Plese Switch ON your Mobile Data(or)WiFi.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        case .online(.wwan):
            print("Connected via WWAN view")
            print("came to external in view")
            chechdataurlext=true
            chechdataurlint=false
        case .online(.wiFi):
            print("Connected via WiFi view ")
            getSSID()
            
        }
        
    }
    
    func getSSID()  {
        print("in ssid view")
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssidName1 = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    print(ssidName1!)
                    if (UserDefaults.standard.object(forKey: "ssid") != nil){
                        let defaults13 = UserDefaults.standard
                        let ssidsettings = defaults13.value(forKey: "ssid") as! String?
                        if (ssidsettings == ssidName1) {
                            print("ssid is match")
                            chechdataurlint1=true
                            chechdataurlext1=false
                        }
                        else{
                            print("ssid not match")
                            chechdataurlint1=false
                            chechdataurlext1=true
                        }
                    }
                        
                    else{
                        print("ssid not match")
                        chechdataurlint1=false
                        chechdataurlext1=true
                        
                    }
                    break
                }
            }
        }
        //  return ssid
    }
    
    func dbCreation(){
        let fileMgnr = FileManager.default
        let filepath = fileMgnr.urls(for: .documentDirectory, in: .userDomainMask)
        
        print("this is filepath path sting \(filepath)")
        databasepathStr=filepath[0].appendingPathComponent("StandaloneDB").path as NSString
        
        print("this is database path sting \(databasepathStr)")
        
        
        if !(fileMgnr.fileExists(atPath: (databasepathStr as NSString) as String)){
            let myDatabase=FMDatabase(path: databasepathStr as String)
            
            if myDatabase==nil{
                
                print("database :: \(String(describing: myDatabase?.lastErrorMessage()!))")
            }
            else{
                print("database Created")
            }
            
            
            
            if (myDatabase?.open())!{
                
                let roomTable = "CREATE TABLE IF NOT EXISTS ROOMS(ROOMNAME TEXT PRIMARYKEY,INTERNALIP TEXT,EXTERNALIP TEXT)"
                let groupTable = "CREATE TABLE IF NOT EXISTS GROUPS(GROUPNAME TEXT PRIMARYKEY ,INTERNALIP TEXT,EXTERNALIP TEXT)"
                let roomSwitchTable = "CREATE TABLE IF NOT EXISTS ROOMSWITCHES(ROOMNAME TEXT,SWITCHNAME TEXT,SWITCHTYPE TEXT,SWITCHNO TEXT,OPERATION TEXT,FOREIGN KEY (ROOMNAME) REFERENCES ROOMS (ROOMNAME))"
                if !((myDatabase?.executeStatements(roomTable))!){
                    print("Table ::\(String(describing: myDatabase?.lastErrorMessage()!))")
                }
                else{
                    print("roomTable created  ")
                }
                if !((myDatabase?.executeStatements(groupTable))!){
                    print("Table ::\(String(describing: myDatabase?.lastErrorMessage()!))")
                }
                else{
                    print("groupTable created  ")
                }
                if !((myDatabase?.executeStatements(roomSwitchTable))!){
                    
                    print("Table ::\(String(describing: myDatabase?.lastErrorMessage()!))")
                }
                else{
                    print("roomSwitchTable created  ")
                }
                myDatabase?.close()
                
            }
            else{
                print("Table ::\(String(describing: myDatabase?.lastErrorMessage()!))")
            }
        }
        else{
            print("Database alrady exits")
        }
        
    }
    
    func getGroups()
    {
        
        MaingroupArray.removeAll()
        gintArray.removeAll()
        gextArray.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
            let querySQL="SELECT * FROM GROUPS"
            let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
            //print("results set : \(resultSet.s!)")
            var rname: String?
            var iname: String?
            var ename: String?

            if (resultSet != nil) {
                while (resultSet?.next())! {
                    rname = resultSet?.string(forColumn: "GROUPNAME")
                    iname = resultSet?.string(forColumn: "INTERNALIP")
                    ename = resultSet?.string(forColumn: "EXTERNALIP")

                    if rname == nil{
                        print("no data in room")
                    }
                    else
                    {
                        MaingroupArray.append(rname!)
                    }
                    if iname == nil{
                        print("no data in room")
                    }
                    else
                    {
                        gintArray.append(iname!)
                    }
                    if ename == nil{
                        print("no data in room")
                    }
                    else
                    {
                        gextArray.append(ename!)
                    }
                    
                }
            }
            print("this is name room array :: \(MaingroupArray)")
            print("this is name int array :: \(gintArray)")
            print("this is name exe array :: \(gextArray)")
            myDB?.close()
            
        }
        tableData1.reloadData()
        
    }
    
    func getRooms(){
       
        MainroomArray.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
        let querySQL="SELECT * FROM ROOMS"
        let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
        //print("results set : \(resultSet.s!)")
        var rname: String?
        if (resultSet != nil) {
            while (resultSet?.next())! {
                rname = resultSet?.string(forColumn: "ROOMNAME")
                if rname == nil{
                    print("no data in room")
                }
                else
                {
                    MainroomArray.append(rname!)
                }
            
            }
        }
        print("this is name room array :: \(MainroomArray)")
        myDB?.close()
        }
        tableData1.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var data:Int = Int()
        if segVar1.selectedSegmentIndex==0{
            data=MainroomArray.count
        }
        if segVar1.selectedSegmentIndex==1{
            data=MaingroupArray.count
        }
        
        return data
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.backgroundColor=UIColor.init(white: 0.5, alpha: 0.5)
        cell.selectionStyle = .none
        cell.textLabel?.textColor=UIColor.init(white: 1.0, alpha: 1.0)
        cell.textLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds=true
        if segVar1.selectedSegmentIndex==0{
            cell.textLabel?.text=MainroomArray[indexPath.row]
            let longGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longTap))
            cell.addGestureRecognizer(longGesture1)
            cell.accessoryType = .disclosureIndicator
        }
        if segVar1.selectedSegmentIndex==1{
            cell.textLabel?.text=MaingroupArray[indexPath.row]
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segVar1.selectedSegmentIndex==0{
            DispatchQueue.main.async{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "room") as! RoomViewController
                nextViewController.roomname1=self.MainroomArray[indexPath.row]
                nextViewController.roomindex1=String(indexPath.row)
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        if segVar1.selectedSegmentIndex==1{
            var ip:String = String()
            if chechdataurlint1==true{
                ip=gintArray[indexPath.row]
            }
            else{
                ip=gextArray[indexPath.row]
            }
            
            print("switch on")
            let url = URL(string: "http://\(ip)")!
            print("button on : http://\(ip)")
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if (error != nil) {
                    print("error")
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                        // For count
                        print(json as NSDictionary)
                        
                    } catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
            
            
        }
        
    }
    
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer)
    {
        if self.segVar1.selectedSegmentIndex==0{
            let longPress = gestureReconizer as UILongPressGestureRecognizer
            let locationInView = longPress.location(in: tableData1)
            let indexPath = tableData1.indexPathForRow(at: locationInView)
            let alertController = UIAlertController(title: "Settings", message: "set the switches to Room", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {  UIAlertAction in
                NSLog("OK Pressed :\(self.MainroomArray[(indexPath?.row)!])")
                DispatchQueue.main.async{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "swtype") as! SwitchViewController
                    nextViewController.roomname=self.MainroomArray[(indexPath?.row)!]
                    self.present(nextViewController, animated:true, completion:nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { UIAlertAction in
                NSLog("Cancel Pressed")
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func segAction(_ sender: Any) {
        if segVar1.selectedSegmentIndex==0{
            getRooms()
        }
        if segVar1.selectedSegmentIndex==1{
            getGroups()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

