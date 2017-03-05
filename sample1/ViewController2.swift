//
//  ViewController2.swift
//  sample1
//
//  Created by Ayush Verma on 08/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let  managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var checkBool:Bool!  //check variable for register
    
    //db object
//    let reg = NSEntityDescription.insertNewObjectForEntityForName("Register", inManagedObjectContext: managedObjectContext)as!Register

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var RegOrig: UIButton!
    @IBOutlet weak var accntExist: UIButton!
    
    var genderDataSource = ["Male", "Female"]
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var renterPass: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var imgdp: UIImageView!
    
    @IBAction func accnt1(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)  //how to pop (Mystery solved)
    }
    //image picker
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        RegOrig.layer.cornerRadius = 7
       accntExist.titleLabel!.textAlignment = .Center
        
        //picker
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        self.gender.inputView = genderPicker
        
        self.addDoneButtonOnDOB()
        self.addDoneButtonOnGender()

        //image picker
        imgdp.layer.cornerRadius = 40
        imgdp.layer.borderWidth = 2.0
        imgdp.layer.borderColor = UIColor.init(white: 1, alpha: 0.5).CGColor
        imagePicker.delegate = self
        let doubletapgesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController2.processDoubleTap(_:)))
        doubletapgesture.numberOfTapsRequired = 1
        imgdp.addGestureRecognizer(doubletapgesture)
        
        //disable keyboard
        let disablekeyboard : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController2.processKeyboardDisable(_:)))
        disablekeyboard.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(disablekeyboard)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            pass.becomeFirstResponder()
        }
        if textField == pass{
            renterPass.becomeFirstResponder()
        }
        if textField == renterPass{
            renterPass.resignFirstResponder()
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
   
    @IBAction func editBeginDOB(sender: AnyObject) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        dob.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController2.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
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
    
    func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
    }
    
    func isValidPhone(testStr:String) -> Bool {
        let phoneRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluateWithObject(testStr)
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
        
      else  if(isValidPhone(phone.text!) == false || phone.text==""){
            
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid phone number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
       else if(isValidEmail(email.text!) == false || email.text==""){
            
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

       else if(pass.text?.characters.count<6){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Length of password must be of atleast 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        }
        
        else if(pass.text! != renterPass.text!){
            checkBool = false
            
            let alert = UIAlertController(title: "Invalid", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
            
        else{
            checkBool = true
        }
        
    }

    @IBAction func regAction(sender: AnyObject) {
        
          //check function
        self.validation()
        //fetch query for password check
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
                if phone.text == match.valueForKey("phone") as? String
                {
                    print("phone no registered")
                    checkBool = false
                    
                    let alert = UIAlertController(title: "Error", message: "Phone no. already registered.\nPlease try another phone no.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    checkBool = true
                }
            }
        }
        catch
        {
            print("Error Fetching")
        }
        
        
        if (checkBool == true){
    
       let reg = NSEntityDescription.insertNewObjectForEntityForName("Register", inManagedObjectContext: self.managedObjectContext)as!Register
            
            if(phone.text == reg.phone){
                print("same number")
            }
            
        
        let img = imgdp.image
        let imgData: NSData = UIImageJPEGRepresentation(img!, 1.0)!
        
        reg.fname=fname.text
        reg.lname=lname.text
        reg.dob=dob.text
        reg.gender=gender.text
        reg.address=address.text
        reg.phone=phone.text
        reg.email=email.text
        reg.password=pass.text
        reg.repass=renterPass.text
        reg.userimg=imgData
        
        NSUserDefaults.standardUserDefaults().setValue(phone.text, forKey: "phoneno")
        NSUserDefaults.standardUserDefaults().setValue(fname.text, forKey: "firstname")
        NSUserDefaults.standardUserDefaults().setValue("1", forKey: "bool")

            
        do{
            
           try self.managedObjectContext.save()
            fname.text!=""
            lname.text!=""
            dob.text!=""
            gender.text!=""
            address.text!=""
            phone.text!="+91"
            email.text!=""
            pass.text!=""
            renterPass.text!=""
            
            //alert
//            let alertController = UIAlertController(title: "", message: "Successfully Registered", preferredStyle: .Alert)
//            self.presentViewController(alertController, animated: true, completion: nil)
//            let delay = 1.0 * Double(NSEC_PER_SEC)
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                alertController.dismissViewControllerAnimated(true, completion: nil)
//            })
            //segue
            self.performSegueWithIdentifier("registerdone", sender: self)

            print("Saved")
        }
            
        catch
        {
            print("Error")
            
        }
    }
        
    }
    
   /* @IBAction func fetchButton(sender: AnyObject) {
        
        let fetchDetail = NSEntityDescription.entityForName("Register", inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        
        request.entity = fetchDetail
        
        let predicate = NSPredicate(format: "fname = %@", fname.text!)
        
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
                pass.text = match.valueForKey("password") as? String
                renterPass.text = match.valueForKey("repass") as? String
                
                let img = match.valueForKey("userimg")as! NSData
                imgdp.image = UIImage(data: img)
                
                
            }
            
        }
        catch
        {
            print("Error")
            
        }
    } */
    
    func processKeyboardDisable (sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func processDoubleTap (sender: UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgdp.image = pickedImage

        }
        dismissViewControllerAnimated(true, completion: nil)
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
