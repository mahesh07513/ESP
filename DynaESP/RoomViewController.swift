//
//  RoomViewController.swift
//  DynaESP
//
//  Created by Apple on 16/04/18.
//  Copyright © 2018 Mahesh. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var roomname1: String = String()
    var roomindex1: String = String()
    var value1 = Int()
    var value2 = Int()
    var value3 = Int()

    @IBOutlet weak var tableRoom: UITableView!
    var MainswicthArray : [String] = [String()]
    var MaintypeArray : [String] = [String()]
    var MainswnoArray : [String] = [String()]
    var intIpArray : [String] = [String()]
    var exIpArray : [String] = [String()]
    var operationArray : [String] = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        value1=0
        // Do any additional setup after loading the view.
        tableRoom.delegate=self
        tableRoom.dataSource=self
        tableRoom.backgroundColor = UIColor.clear
        tableRoom.rowHeight=60
        print("swithch index \(Int(roomindex1))!")
        getRoomSwitches()
        getRoomIP()
        
    }
    
    @IBAction func roombackAct(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "first") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func getRoomIP()
    {
        intIpArray.removeAll()
        exIpArray.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
            print("this is room name \(roomname1)")
            let querySQL="SELECT * FROM ROOMS WHERE ROOMNAME = \"\(roomname1)\" "
            let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
            //print("results set : \(resultSet.s!)")
            var iip: String?
            var exip: String?
            
            if (resultSet != nil) {
                while (resultSet?.next())! {
                    iip = resultSet?.string(forColumn: "INTERNALIP")
                    exip = resultSet?.string(forColumn: "EXTERNALIP")
                    
                    if iip == nil{
                        print("no data in room")
                    }
                    else
                    {
                        intIpArray.append(iip!)
                    }
                    if exip == nil{
                        print("no data in room")
                    }
                    else
                    {
                        exIpArray.append(exip!)
                    }
                    
                }
                
            }
            
            print("this is name exip array :: \(exIpArray)")
            print("this is name intip array :: \(intIpArray)")
            myDB?.close()
           
        }
        
    }
    
    func getRoomSwitches()
    {
        MainswicthArray.removeAll()
        MaintypeArray.removeAll()
        MainswnoArray.removeAll()
        operationArray.removeAll()
        let myDB=FMDatabase(path: databasepathStr as String)
        if (myDB?.open())!{
            print("this is room name \(roomname1)")
            let querySQL="SELECT * FROM ROOMSWITCHES WHERE ROOMNAME = \"\(roomname1)\" "
            let resultSet:FMResultSet?=(myDB?.executeQuery(querySQL, withArgumentsIn: nil))!
            //print("results set : \(resultSet.s!)")
            var sname: String?
            var stname: String?
            var stno: String?
            var operation: String?
            if (resultSet != nil) {
                while (resultSet?.next())! {
                    sname = resultSet?.string(forColumn: "SWITCHNAME")
                    stname = resultSet?.string(forColumn: "SWITCHTYPE")
                    stno = resultSet?.string(forColumn: "SWITCHNO")
                    operation = resultSet?.string(forColumn: "OPERATION")
                    if sname == nil{
                        print("no data in room")
                    }
                    else
                    {
                        MainswicthArray.append(sname!)
                    }
                    if stname == nil{
                        print("no data in room")
                    }
                    else
                    {
                        MaintypeArray.append(stname!)
                    }
                    if stno == nil{
                        print("no data in room")
                    }
                    else
                    {
                        MainswnoArray.append(stno!)
                    }
                    if operation == nil{
                        print("no data in room")
                    }
                    else
                    {
                        operationArray.append(operation!)
                    }
                }
            }
            print("this is name room array :: \(MaintypeArray)")
            print("this is name room array :: \(MainswicthArray)")
            print("this is name swno array :: \(MainswnoArray)")
            print("this is name room array :: \(operationArray)")
            myDB?.close()
           // if MaintypeArray.count>0 && MainswicthArray.count>0{
                tableRoom.reloadData()
            //}
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainswicthArray.count
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
        //cell.textLabel?.textAlignment = .center
        cell.textLabel?.text=MainswicthArray[indexPath.row]
        if MaintypeArray[indexPath.row]=="Switch"{
            let switchDemo:UISwitch=UISwitch(frame:CGRect(x: 0, y: 0, width: 20, height: 20));
            if (operationArray[indexPath.row]) == "OFF"{
                switchDemo.isOn=false
            }
            else{
                switchDemo.isOn=true
            }
            switchDemo.tag=indexPath.row
            switchDemo.restorationIdentifier = "\(indexPath.row)"
            switchDemo.addTarget(self, action: #selector(RoomViewController.switchOperation(_:)), for: .valueChanged);
            cell.accessoryView=switchDemo
        }
        if MaintypeArray[indexPath.row]=="Button"{
            let button:UIButton=UIButton(frame:CGRect(x: 0, y: 0, width: 80, height: 40));
            button.tag=indexPath.row
            button.restorationIdentifier = "\(indexPath.row)"
            button.backgroundColor=UIColor.gray
            button.setTitle("Button", for: .normal)
            button.addTarget(self, action: #selector(RoomViewController.buttonOperation(_:)), for: .touchUpInside);
            cell.accessoryView=button
        }
        if MaintypeArray[indexPath.row]=="Variable"{
            let slider:UISlider=UISlider(frame:CGRect(x: 0, y: 0, width: 200, height: 30));
            slider.tag=indexPath.row
            slider.restorationIdentifier = "\(indexPath.row)"
            slider.minimumValue=0
            slider.maximumValue=100
            slider.value=Float(value1)
            slider.addTarget(self, action: #selector(RoomViewController.sliderOperation(sender:event:)), for: .valueChanged);
            cell.accessoryView=slider
        }
        if MaintypeArray[indexPath.row]=="Variable2"{
            let slider:UISlider=UISlider(frame:CGRect(x: 0, y: 0, width: 200, height: 80));
            slider.tag=indexPath.row
            slider.restorationIdentifier = "\(indexPath.row)"
            slider.minimumValue=0
            slider.maximumValue=100
            slider.value=Float(value2)
            slider.addTarget(self, action: #selector(RoomViewController.slider2Operation(sender:event:)), for: .valueChanged);
            cell.accessoryView=slider
        }
        if MaintypeArray[indexPath.row]=="Dimmer"{
            let slider:UISlider=UISlider(frame:CGRect(x: 0, y: 0, width: 200, height: 20));
            slider.tag=indexPath.row
            slider.restorationIdentifier = "\(indexPath.row)"
            slider.minimumValue=0
            slider.maximumValue=100
            slider.value=Float(value3)
            slider.addTarget(self, action: #selector(RoomViewController.dimmerOperation(sender:event:)), for: .valueChanged);
            cell.accessoryView=slider
        }
        
        return cell
    }
    
    
    
    @IBAction func buttonOperation(_ sender: UIButton){
        
        var ip:String = String()
        if chechdataurlint1==true{
            ip=intIpArray[0]
        }
        else{
            ip=exIpArray[0]
        }
        
            print("switch on")
            let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/ON")!
        print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/ON ")
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
    @IBAction func sliderOperation(sender: UISlider,event: UIEvent){
        var ip:String = String()
        var value = Int()
        
        if chechdataurlint1==true{
            ip = intIpArray[0]
        }
        else{
            ip = exIpArray[0]
        }
        
        if let touchEvent = event.allTouches?.first {
            value=Int(sender.value)
            switch touchEvent.phase {
                case .began:
                // handle drag began
                print("began \(Int(sender.value))")
                
                case .moved:
                // handle drag moved
                print("moved \(Int(sender.value))")
                case .ended:
                // handle drag ended
                print("ended \(Int(sender.value))")
                if Int(value)<=10 && Int(value)<=0{
                    print("slider val 10 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/OFF")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/OFF ")
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
                if Int(value)>=10 && Int(value)<=40{
                    print("slider val 40 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/L1")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/L1 ")
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
                if Int(value)>=40 && Int(value)<=70{
                    print("slider val 70 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/L2")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/L2 ")
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
                if Int(value)>=70 && Int(value)<=100{
                    print("slider val 100 : \(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/ON")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/ON ")
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
                value1=Int(sender.value)
                default:
                    print("dedfault \(Int(sender.value))")
                    break
            }
        }
    
    }
    @IBAction func slider2Operation(sender: UISlider,event: UIEvent){
        var ip:String = String()
        var value = Int()
        
        if chechdataurlint1==true{
            ip = intIpArray[0]
        }
        else{
            ip = exIpArray[0]
        }
        
        if let touchEvent = event.allTouches?.first {
            value=Int(sender.value)
            switch touchEvent.phase {
            case .began:
                // handle drag began
                print("began \(Int(sender.value))")
                
            case .moved:
                // handle drag moved
                print("moved \(Int(sender.value))")
            case .ended:
                // handle drag ended
                print("ended \(Int(sender.value))")
                if Int(value)<=10 && Int(value)<=0{
                    print("slider val 10 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/OFF")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/OFF ")
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
                if Int(value)>=10 && Int(value)<=40{
                    print("slider val 40 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/L1")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/L1 ")
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
                if Int(value)>=40 && Int(value)<=70{
                    print("slider val 70 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/L2")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/L2 ")
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
                if Int(value)>=70 && Int(value)<=100{
                    print("slider val 100 : \(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/ON")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/ON ")
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
                
                value2=Int(sender.value)
                default:
                    print("dedfault \(Int(sender.value))")
                    break
            }
        }
        
        
    }
    @IBAction func dimmerOperation(sender: UISlider,event: UIEvent){
        
        var ip:String = String()
        var value = Int()
        
        if chechdataurlint1==true{
            ip = intIpArray[0]
        }
        else{
            ip = exIpArray[0]
        }
        
        if let touchEvent = event.allTouches?.first {
            value=Int(sender.value)
            switch touchEvent.phase {
            case .began:
                // handle drag began
                print("began \(Int(sender.value))")
                
            case .moved:
                // handle drag moved
                print("moved \(Int(sender.value))")
            case .ended:
                // handle drag ended
                print("ended \(Int(sender.value))")
                
                    print("slider val 10 :\(value)")
                    let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/PWM\(Int(value))")!
                    print("button on : http://\(ip)/sw\(MainswnoArray[sender.tag])/PWM\(Int(value))) ")
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
                    
                    
                
           value3=Int(sender.value)
            default:
                print("dedfault \(Int(sender.value))")
                break
            }
        }
        
 
    }
    
    
    
    @IBAction func switchOperation(_ sender: UISwitch){
        var ip:String = String()
        if chechdataurlint1==true{
            ip=intIpArray[0]
        }
        else{
            ip=exIpArray[0]
        }
        
        if sender.isOn{
            print("switch on")
            let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/ON")!
            print("http://\(ip)/sw\(MainswnoArray[sender.tag])/ON")
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
            let myDB=FMDatabase(path:databasepathStr as String)
            if(myDB?.open())!{
                let insertSql="UPDATE ROOMSWITCHES SET OPERATION=\"ON\" WHERE ROOMNAME=\"\(roomname1)\" AND SWITCHNAME = \"\(MainswicthArray[sender.tag])\""
                let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                if (result == true){
                    print("upadte successfully ")
                    operationArray[sender.tag]="ON"
                }
                else{
                    print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                }
                myDB?.close()
            }
        }
        else{
            print("swicthoff")
            let url = URL(string: "http://\(ip)/sw\(MainswnoArray[sender.tag])/OFF")!
            print("http://\(ip)/sw\(MainswnoArray[sender.tag])/OFF")
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
            let myDB=FMDatabase(path:databasepathStr as String)
            if(myDB?.open())!{
                let insertSql="UPDATE ROOMSWITCHES SET OPERATION=\"OFF\" WHERE ROOMNAME=\"\(roomname1)\" AND SWITCHNAME = \"\(MainswicthArray[sender.tag])\""
                let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                if (result == true){
                    print("upadte successfully ")
                    operationArray[sender.tag]="OFF"
                    
                }
                else{
                    print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                }
                myDB?.close()
            }
        }
       // getRoomSwitches()
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            let alertController = UIAlertController(title: "\(self.MainswicthArray[indexPath.row])", message: "do you want to delete?", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    let myDB=FMDatabase(path:databasepathStr as String)
                    if(myDB?.open())!{
                        let insertSql="DELETE from ROOMSWITCHES WHERE ROOMNAME=\"\(self.roomname1)\" AND SWITCHNAME = \"\(self.MainswicthArray[indexPath.row])\""
                        let result = myDB?.executeUpdate(insertSql, withArgumentsIn: nil)
                        if (result == true){
                            print("delete success fully ")
                            
                        }else{
                            print("MyTable \(String(describing: myDB?.lastErrorMessage()))")
                        }
                        myDB?.close()
                    }
                    
                    
                    self.getRoomSwitches()
                    
                    
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
        
    
    
        deleteAction.backgroundColor = .red
        return [deleteAction]
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
