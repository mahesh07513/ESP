//
//  LoginViewController.swift
//  DynaESP
//
//  Created by Apple on 16/04/18.
//  Copyright © 2018 Mahesh. All rights reserved.
//



import UIKit
import Foundation

import SystemConfiguration.CaptiveNetwork

var ssidName: String?
var url: String?
var urlint: String?
var urlext: String?
var chechdataurlint: Bool?
var chechdataurlext: Bool?
class LoginViewController: UIViewController,UITextFieldDelegate,URLSessionDelegate {
    
    @IBOutlet var username: UITextField!
    
    
    @IBOutlet var password: UITextField!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        username.text="mahesh"
        //        password.text="mahesh12babu"
        password.isSecureTextEntry=true
        
        username.delegate=self
        password.delegate=self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
        
        
        
        
        reachNetwork()
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
    
    func httpGet(request: URLRequest) {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            if error == nil {
                let result = NSString(data: data!, encoding:
                    String.Encoding.ascii.rawValue)!
                NSLog("result %@", result)
            }
        }
        task.resume()
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        reachNetwork()
        
        
        if (UserDefaults.standard.object(forKey: "username") != nil) && (UserDefaults.standard.object(forKey: "password") != nil){
            
            
            
            let defaults12 = UserDefaults.standard
            let username1 = defaults12.value(forKey: "username")
            
            username.text=username1 as? String
            
            let defaults13 = UserDefaults.standard
            let password1 = defaults13.value(forKey: "password")
            
            password.text=password1 as? String
            
            
            
            
        }else{
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    //    func networkStatusChanged(_ notification: Notification) {
    //        let userInfo = (notification as NSNotification).userInfo
    //        print("kdslkkkkk :\(userInfo!)")
    //
    //         reachNetwork();
    //    }
    
    
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
            print("Connected via WWAN login")
            if (UserDefaults.standard.object(forKey: "externalip") != nil){
                print("came to external in login")
                
                // if (UserDefaults.standard.object(forKey: "externalip") != nil){
                
                let defaults12 = UserDefaults.standard
                let externalip = defaults12.value(forKey: "externalip")
                
                urlext=(externalip as! String)
                chechdataurlext=true
                chechdataurlint=false
                
               
                
                
            }else{
                
                let alert = UIAlertController(title: "Settings ", message: "Plese enter External IP in Register Page.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
        case .online(.wiFi):
            print("Connected via WiFi login ")
            
            getSSID()
            
        }
        
    }
    
    
    
    
    func getSSID()  {
        print("in ssid login")
        
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssidName = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    
                    print(ssidName!)
                    
                    
                    
                    
                    if (UserDefaults.standard.object(forKey: "internalip") != nil) && (UserDefaults.standard.object(forKey: "ssid") != nil){
                        
                        
                        
                        let defaults12 = UserDefaults.standard
                        let internalip = defaults12.value(forKey: "internalip")
                        
                        
                        let defaults13 = UserDefaults.standard
                        let ssidsettings = defaults13.value(forKey: "ssid") as! String?
                        
                        
                        if (ssidsettings == ssidName) {
                            
                            print("ssid is match")
                            
                            urlint=(internalip as! String)
                            
                            chechdataurlint=true
                            chechdataurlext=false
                            
                            //  url="http://\(urlint!)/service/validate_web"
                            
                            
                            
                            
                            
                        }
                        else{
                            
                            print("ssid not match")
                            
                            
                            if (UserDefaults.standard.object(forKey: "externalip") != nil){
                                
                                let defaults12 = UserDefaults.standard
                                let externalip = defaults12.value(forKey: "externalip")
                                
                                urlext=(externalip as! String)
                                chechdataurlint=false
                                chechdataurlext=true
                                //                                print("this is false  \(isStringAnInt(string: urlext!))")
                                //                                if isStringAnInt(string: urlext!) == false{
                                //
                                //                                    print("this is false")
                                //                                }
                                //                                else{
                                //                                    print("this is true:")
                                //                                }
                                
                                //url="https://\(urlext!)/service/validate_web"
                                //                                let vc = ViewController()
                                //                                vc.httpGet(request: URLRequest( url: URL(string: url!)!))
                                
                                
                            }else{
                                
                                // if (UserDefaults.standard.object(forKey: "internalip") != nil){
                                
                                chechdataurlint=true
                                chechdataurlext=false
                                let defaults12 = UserDefaults.standard
                                let internalip = defaults12.value(forKey: "internalip")
                                
                                urlint=(internalip as! String)
                                
                                //                                print("this is false  \(isStringAnInt(string: urlext!))")
                                //                                if isStringAnInt(string: urlext!) == false{
                                //
                                //                                    print("this is false")
                                //                                }
                                //                                else{
                                //                                    print("this is true:")
                                //                                }
                                
                                // url="http://\(urlext!)/service/validate_web"
                                //                                let vc = ViewController()
                                //                                vc.httpGet(request: URLRequest( url: URL(string: url!)!))
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                    }
                        
                    else{
                        
                        //                        chechdataurlint=false
                        //                        chechdataurlext=true
                        
                        if (UserDefaults.standard.object(forKey: "externalip") != nil){
                            
                            let defaults12 = UserDefaults.standard
                            let externalip = defaults12.value(forKey: "externalip")
                            
                            urlext=(externalip as! String)
                            //                            print("this is ...  ")
                            //
                            //                            let test1 = String(describing: urlext?.prefix(3))
                            //                            print(test1)
                            //
                            //                            if isStringAnInt(string: test1) == false{
                            //
                            //                                print("this is false")
                            //                            }
                            //                            else{
                            //                                print("this is true:")
                            //                            }
                            // url="https://\(urlext!)/service/validate_web"
                            //                            let vc = ViewController()
                            //                            vc.httpGet(request: URLRequest( url: URL(string: url!)!))
                            
                            chechdataurlint=false
                            chechdataurlext=true
                            
                        }else{
                            
                            
                            
                            let alert = UIAlertController(title: "Settings ", message: "Plese enter settings IP's.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    break
                }
            }
        }
        //  return ssid
    }
    
    func isStringAnInt(string: String) -> Bool
    {
        let number = Int(string)
        return number != nil
    }
    
    //    func isStringAnInt(string: String) -> Bool {
    //        return Int(string) != nil
    //    }
    
    @IBAction func Sttings(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        self.present(nextViewController, animated:true, completion:nil)
        
        
    }
    
    
    
    @IBAction func Login(_ sender: Any) {
        //        username.text="mahesh"
        //        password.text="mahesh12babu"
        
        
        
        
        
        
        if((username.text?.isEmpty)! && (password.text?.isEmpty)!){
            let alert = UIAlertController(title: "Login", message: "Please fill the all fileds", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            
            
            let defaults4 = UserDefaults.standard
            defaults4.set(username.text, forKey: "username")
            
            let defaults5 = UserDefaults.standard
            defaults5.set(password.text, forKey: "password")
            
            
            
            if chechdataurlint==true{
                
                url="http://\(urlint!)/service/validate_web"
                
            }
            
            if chechdataurlext==true{
                
                url="https://\(urlext!)/service/validate_web"
                
            }
            
            
            print("this is url \(url!)")
            
            
            
            
            var request = URLRequest(url: URL(string: url!)!)
            request.httpMethod = "POST"
            
            let postString="{\"username\": \"\(self.username.text!)\", \"password\": \"\(self.password.text!)\"}"
            
            print(postString)
            // let postString = "id=13&name=Jack"
            
            DispatchQueue.main.async(){
                let start:TimeInterval = NSDate.timeIntervalSinceReferenceDate
                request.httpBody = postString.data(using: .utf8)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        // check for fundamental networking error
                        let timeResponse:TimeInterval = NSDate.timeIntervalSinceReferenceDate - start
                        print("time difference is :: \(timeResponse)")
                        print("error=\(String(describing: error?.localizedDescription))")
                        let alert = UIAlertController(title: "NetWork Error", message: "Host Not Reachable Please Chack", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString!)")
                    
                    
                    
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                        
                        let name = json["error_code"] as? String
                        let comp = "0"
                        
                        
                        
                        
                        
                        print(" this sis error code \(name!)")
                        
                        
                        
                        if name == comp {
                            
                            print(name!)
                            
                            DispatchQueue.main.async{
                                //               self.performSegue(withIdentifier: "login", sender:self)
                                
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login_success") as! ViewController
                                self.present(nextViewController, animated:true, completion:nil)
                                
                            }
                        }
                        else{
                            
                            print(name!)
                            
                            // create the alert
                            let alert = UIAlertController(title: "Login", message: "Unable To Login .", preferredStyle: UIAlertControllerStyle.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                    
                }
                
                
                task.resume()
                
                
            }
            
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


