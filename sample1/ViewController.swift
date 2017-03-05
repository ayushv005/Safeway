//
//  ViewController.swift
//  sample1
//
//  Created by Ayush Verma on 08/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton2: UIButton!
    @IBOutlet weak var reg1: UIButton!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    var phonenumber : String!
    var password : String!
    
    let  managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func loginButton(sender: AnyObject) {
        
        //fetch phone-pass
        let entityDescription = NSEntityDescription.entityForName("Register", inManagedObjectContext: managedObjectContext)
        
        let Request = NSFetchRequest()
        Request.entity = entityDescription
        
        let pred = NSPredicate(format: "phone=%@", phone.text!)
        Request.predicate=pred
        
        do
        {
            var objects = try managedObjectContext.executeFetchRequest(Request)
            
            if objects.count>0
            {
                let match = objects[0] as! NSManagedObject
             

                
                if phone.text == match.valueForKey("phone") as? String && pass.text == match.valueForKey("password") as? String
                {
                    let firstname  = match.valueForKey("fname") as? String
                    NSUserDefaults.standardUserDefaults().setValue(firstname, forKey: "firstname")
                    NSUserDefaults.standardUserDefaults().setValue(phone.text, forKey: "phoneno")
                    NSUserDefaults.standardUserDefaults().setValue("1", forKey: "bool")
                    print("login success")
                    self.performSegueWithIdentifier("loginSuccess", sender: self)
                }
                else
                {
                    print("login fail")
                    
                    let alert = UIAlertController(title: "Error", message: "Wrong Credentials or account does not exist", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }

            }
            else
            {
                print("login fail")
                
                let alert = UIAlertController(title: "Error", message: "Wrong Credentials or account does not exist", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        catch
        {
            print("Error Fetching")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton2.layer.cornerRadius = 7
        reg1.titleLabel!.textAlignment = .Center
        
        let disablekeyboard : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController2.processKeyboardDisable(_:)))
        disablekeyboard.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(disablekeyboard)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == phone{
            pass.becomeFirstResponder()
        }
        if textField == pass{
            loginButton(self)
        }
        return true
    }

    
    func processKeyboardDisable (sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbLoginAction(sender: AnyObject) {
        
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
//        if (error == nil){
//        
//        
//        let fbloginresult : FBSDKLoginManagerLoginResult = result
//        if(fbloginresult.grantedPermissions.contains("email"))
//        {
//        self.getFBUserData()
//        
//        fbLoginManager.logOut()
//        
//        if let fbBool = NSUserDefaults.standardUserDefaults().valueForKey("fbBool")
//        {
//        if(fbBool as! String == "1")
//        {
//        self.performSegueWithIdentifier("loginwithfb1", sender: self)
//        self.checkfbloginBool = true
//        
//        NSUserDefaults.standardUserDefaults().setValue("1", forKey: "bool")
//        }
//        
//        else
//        {
//        self.animView.startCanvasAnimation()
//        self.performSegueWithIdentifier("loginwithfb", sender: self)
//        self.checkfbloginBool = false
//        }
//        }
//        
//        else
//        {
//        self.animView.startCanvasAnimation()
//        self.performSegueWithIdentifier("loginwithfb", sender: self)
//        self.checkfbloginBool = false
//        
//        }
//        
//        }
//        else{
//        }
//        }
//        })
//    }
//    
//    func getFBUserData(){
//        
//        let reg = NSEntityDescription.insertNewObjectForEntityForName("Register", inManagedObjectContext: self.managedObjectContext) as! Register
//        
//        if((FBSDKAccessToken.currentAccessToken()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender , picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
//                if (error == nil){
//                    print(result)
//                    
//                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
//                    
//                    let img = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
//                    
//                    let imgdata : NSData = UIImageJPEGRepresentation(img!, 0.8)!
//                    
//                    
//                    reg.fname = result.objectForKey("first_name") as? String
//                    reg.lname = result.objectForKey("last_name") as? String
//                    reg.userimg = imgdata
//                    reg.email = result.objectForKey("email") as? String
//                    reg.gender = result.objectForKey("gender") as? String
//                    
//                    NSUserDefaults.standardUserDefaults().setValue(reg.gender, forKey: "gender")
//                    
//                    if(self.checkfbloginBool)
//                    {
//                        reg.phone = NSUserDefaults.standardUserDefaults().valueForKey("phone") as? String
//                    }
//                    
//                    
//                    NSUserDefaults.standardUserDefaults().setValue(result.objectForKey("first_name") as? String, forKey: "firstname")
//                    
//                    NSUserDefaults.standardUserDefaults().setValue(result.objectForKey("email") as? String, forKey: "emailUserDef")
//                    
//                    NSUserDefaults.standardUserDefaults().setValue(strPictureURL, forKey: "imageUserDef")
//                    
//                    
//                }
//            })
//        }
//
//        
//        
    }


}

