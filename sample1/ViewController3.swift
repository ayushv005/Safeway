//
//  ViewController3.swift
//  sample1
//
//  Created by Ayush Verma on 10/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController3: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let  managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var checkBool:Bool!  //check variable for register
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilebarbtn: UIBarButtonItem!
    
    @IBOutlet weak var imgDp: UIImageView!
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var changePass: UITextField!
    
    @IBOutlet weak var savechanges: UIButton!
    
    var genderDataSource = ["Male", "Female"]
    var phonenumber : String!
    
    //image picker
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logo
        let imageView = UIImageView(frame: CGRect(x: -20, y: 0, width: 150, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "safeway2")
        imageView.image = image
        navigationItem.titleView = imageView

        
       profilebarbtn.target = self.revealViewController()
        profilebarbtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        imgDp.layer.cornerRadius = 40
        imgDp.layer.borderWidth = 2.0
        imgDp.layer.borderColor = UIColor.init(white: 1, alpha: 0.5).CGColor

        imagePicker.delegate = self
        let doubletapgesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController3.processDoubleTap(_:)))
        doubletapgesture.numberOfTapsRequired = 1
        imgDp.addGestureRecognizer(doubletapgesture)
        
        savechanges.layer.cornerRadius = 7

        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        self.gender.inputView = genderPicker
        
        self.addDoneButtonOnDOB()
        self.addDoneButtonOnGender()
        
        let disablekeyboard : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController2.processKeyboardDisable(_:)))
        disablekeyboard.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(disablekeyboard)
        
        
        //fetch
        phonenumber = NSUserDefaults.standardUserDefaults().objectForKey("phoneno") as! String
        
        
        let fetchDetail = NSEntityDescription.entityForName("Register", inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        
        request.entity = fetchDetail
        
        let predicate = NSPredicate(format: "phone = %@", phonenumber)
        
        request.predicate = predicate
        
        do{
            var temp = try self.managedObjectContext.executeFetchRequest(request)
            if temp.count > 0
            {
                let match = temp[0] as! NSManagedObject
                
                fname.text = match.valueForKey("fname") as? String
                lname.text = match.valueForKey("lname") as? String
                dob.text = match.valueForKey("dob") as? String
                gender.text = match.valueForKey("gender") as? String
                address.text = match.valueForKey("address") as? String
                phone.text = match.valueForKey("phone") as? String
                email.text = match.valueForKey("email") as? String
                
                let img = match.valueForKey("userimg")as! NSData
                imgDp.image = UIImage(data: img)
                
                
            }
        }
        catch
        {
            print("Error")
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == fname{
            lname.becomeFirstResponder()
        }
        if textField == lname{
            dob.becomeFirstResponder()
        }
        if textField == dob{
            gender.becomeFirstResponder()
        }
        if textField == gender{
            address.becomeFirstResponder()
        }
        if textField == address{
            phone.becomeFirstResponder()
        }
        if textField == phone{
            email.becomeFirstResponder()
        }
        if textField == email{
            email.resignFirstResponder()
        }
        return true
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderDataSource[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = genderDataSource[row]
    }
    
    @IBAction func editBeginDob(sender: AnyObject) {

            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            dob.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(ViewController3.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        if dob.text == ""{
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dob.text = dateFormatter.stringFromDate(currentDate)
        }

    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dob.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func addDoneButtonOnDOB()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        doneToolbar.barTintColor = UIColor.init(colorLiteralRed: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ViewController2.doneButtonActionDOB))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        
        doneToolbar.sizeToFit()
        
        self.dob.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonActionDOB()
    {
        self.gender.becomeFirstResponder()
        
    }
    
    func addDoneButtonOnGender()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        doneToolbar.barTintColor = UIColor.init(colorLiteralRed: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ViewController2.doneButtonActionGender))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        
        doneToolbar.sizeToFit()
        
        self.gender.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonActionGender()
    {
        self.address.becomeFirstResponder()
        
    }
    
    
    func processKeyboardDisable (sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processDoubleTap (sender: UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgDp.image = pickedImage
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func validation(){
        
        if(fname.text == ""){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid first name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        else if(lname.text == ""){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid last name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        else if(dob.text == ""){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid date of birth", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        else if(gender.text == ""){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid gender", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        else if(address.text == ""){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        else if(isValidEmail(email.text!) == false || email.text==""){
            
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        else if(changePass.text?.characters.count<6){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Length of password must be of atleast 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

        else{
            checkBool = true
        }
        
    }
    
    @IBAction func saveChangesAction(sender: AnyObject) {
        
            phonenumber = NSUserDefaults.standardUserDefaults().objectForKey("phoneno") as! String
            self.validation() //to check for proper data entry
        
        
            if (checkBool == true){
            let entityDescription = NSEntityDescription.entityForName("Register", inManagedObjectContext: managedObjectContext)
            
            let Request = NSFetchRequest()
            Request.entity = entityDescription
            
            let pred = NSPredicate(format: "phone=%@", phonenumber)
            Request.predicate=pred
            
            do
            {
                var objects = try managedObjectContext.executeFetchRequest(Request)
                
                if objects.count>0
                {
                    let img = imgDp.image
                    let imgData: NSData = UIImageJPEGRepresentation(img!, 1.0)!
                    
                    let match = objects[0] as! NSManagedObject
                    match.setValue(fname.text, forKey: "fname")
                    match.setValue(lname.text, forKey: "lname")
                    match.setValue(dob.text, forKey: "dob")
                    match.setValue(gender.text, forKey: "gender")
                    match.setValue(address.text, forKey: "address")
                    match.setValue(email.text, forKey: "email")
                    match.setValue(changePass.text, forKey: "password")
                    match.setValue(changePass.text, forKey: "repass")
                    match.setValue(imgData, forKey: "userimg")
                    
                    
                    
                    do
                    {
                        try match.managedObjectContext?.save()
                        changePass.text!=""
                        
                       // alert
                        let alertController = UIAlertController(title: "", message: "Record successfully changed", preferredStyle: .Alert)
                                    self.presentViewController(alertController, animated: true, completion: nil)
                        let delay = 1.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                            alertController.dismissViewControllerAnimated(true, completion: nil)
                                    })

                        
                    }
                    catch
                    {
                        print("error")
                    }
                }
            }
            catch
            {
                print("Error Fetching")
            }
        }
        
    }

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
