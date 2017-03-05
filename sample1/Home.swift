//
//  Home.swift
//  sample1
//
//  Created by Ayush Verma on 14/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData
import AudioToolbox

class Home: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{

    let  managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var phonenumber : String!
    var seconds : Double = 60.0
    var timerCnvrt = [Int]()
    var delay : NSTimer = NSTimer()
    
    @IBOutlet weak var viewMap: GMSMapView!
    var placePicker: GMSPlacePicker!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var tabBar: UIView!
    
    @IBOutlet var centreBtn: UIButton!
    @IBOutlet weak var hiddenView: UIView!
    
    var imageForMarker: UIImage!
    
    var marker = GMSMarker()

    var location: String!
    var street: NSString!
    var city: String!
    
    var locationManager = CLLocationManager()
    
    let datePickerView:UIDatePicker  = UIDatePicker(frame: CGRect(x: 0, y: 440, width: 380, height: 230))
    var doneToolbar: UIToolbar!
    
//    override func canBecomeFirstResponder() -> Bool {
//        return true
//    }
//    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
//        if motion == .MotionShake {
//            print("Shaken, not stirred in Home")
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() //related to shake
        
        //internet check
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            
            if reachability.currentReachabilityStatus == .ReachableViaWiFi || reachability.currentReachabilityStatus == .ReachableViaWWAN
            {
                print("Internet connection OK (Wifi Or Cellular)")
            }
            else{
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        catch let error as NSError{
            print(error.debugDescription)
        }
        
        //Map Work
        viewMap.delegate = self
        locationManager.delegate = self
        viewMap.myLocationEnabled = true
        viewMap.settings.myLocationButton = true
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
       // locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 20
        locationManager.startUpdatingLocation()
        
        //logo
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "safeway")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        
//        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(30.733315, longitude: 76.779418, zoom: 14.0)
//        viewMap.camera = camera
        
        //bar button
        barButton.target = self.revealViewController()
        barButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
                
                let img = match.valueForKey("userimg")as! NSData
                imageForMarker = UIImage(data: img)!
                
                
            }
        }
        catch
        {
            print("Error")
            
        }

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            //locationManager.startUpdatingLocation()
           // viewMap.myLocationEnabled = true
            //viewMap.settings.myLocationButton = true
            
          //  let locValue:CLLocationCoordinate2D = manager.location!.coordinate
          //  print("locations = \(locValue.latitude) \(locValue.longitude)")

        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let newLocation = locations.last {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(newLocation.coordinate, zoom: 14.0)
        
        marker.position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        marker.map = self.viewMap
        marker.title = "Me"
            
        //marker.icon = UIImage(named: "car.png")
        //locationManager.stopUpdatingLocation()
            
            do {
               let reachability2: Reachability = try Reachability.reachabilityForInternetConnection()
                
                if reachability2.currentReachabilityStatus == .ReachableViaWiFi || reachability2.currentReachabilityStatus == .ReachableViaWWAN
                {

            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Address dictionary
               // print(placeMark.addressDictionary)
                
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    self.marker.snippet = city as String
                    
                }
                
                // location for sms
                self.location = placeMark.addressDictionary!["Name"] as! String
                self.street = placeMark.addressDictionary!["SubLocality"] as! String
                self.city = placeMark.addressDictionary!["City"] as! String
            
            })
            // locationManager.stopUpdatingLocation()
        
        }
        else
        {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        }
        catch let error as NSError{
            print(error.debugDescription)
        }
    }
    }

    
    @IBAction func pickPlace(sender: UIBarButtonItem)
    {
        let center = CLLocationCoordinate2D(latitude: (viewMap.myLocation?.coordinate.latitude)!, longitude: (viewMap.myLocation?.coordinate.longitude)!)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error
            {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place
            {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.attributions)")
                
            } else {
                print("No place selected")
            }

        })
    }
    
    @IBAction func CentreButton(sender: AnyObject) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

        let firstname = NSUserDefaults.standardUserDefaults().objectForKey("firstname") as! String
        let phonenumber = NSUserDefaults.standardUserDefaults().objectForKey("phoneno") as! String

        
            // Use your own details here
            let twilioSID = "ACcd491c1121a92a4c271ec00e2a232390"
            let twilioSecret = "782458447b099d967ef45fde496a5483"
            let fromNumber = "+15167144361"
            let toNumber = "%2B91\(NSUserDefaults.standardUserDefaults().valueForKey("friendno1") as! String)"
            let message = "Your friend \(firstname) is in trouble. Please contact him/her at %2B\(phonenumber)\nSent from Safeway."
            
            // Build the request
            var request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
            request.HTTPMethod = "POST"
            request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
            
            // Build the completion block and send the request
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                print("Finished")
                if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    // Success
                    print("Response: \(responseDetails)")
                    // alert
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    let alertController = UIAlertController(title: "Success", message: "Safeway text sent to your friend/s.", preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    })

                } else {
                    // Failure
                    print("Error: \(error)")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    let alertController = UIAlertController(title: "Error", message: "Safeway text not sent due to poor internet connection. Please try again.", preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    })

                }
            }).resume()
        
        
        let toNumber2 = "%2B91\(NSUserDefaults.standardUserDefaults().valueForKey("friendno2") as! String)"
        
        // Build the request
         request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber2)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()

        
    }
   
    @IBAction func CallFriend(sender: AnyObject) {
        
        let phoneURL = "tel://\(NSUserDefaults.standardUserDefaults().valueForKey("friendno1") as! String)"
        let URL: NSURL = NSURL(string: phoneURL)!
        UIApplication.sharedApplication().openURL(URL)
        
        if phoneURL == "tel://" {
            let alert = UIAlertController(title: "Invalid", message: "Please check phone no. for 'Friend 1'", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func imHere(sender: AnyObject) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

        do {
            let reachability3: Reachability = try Reachability.reachabilityForInternetConnection()
            
            if reachability3.currentReachabilityStatus == .ReachableViaWiFi || reachability3.currentReachabilityStatus == .ReachableViaWWAN
            {
                
        print("\(location), \(street), \(city). Yess!" )
        let firstname = NSUserDefaults.standardUserDefaults().objectForKey("firstname") as! String
        
        let locationString = "https://www.google.co.in/maps/dir//\(viewMap.myLocation!.coordinate.latitude),\(viewMap.myLocation!.coordinate.longitude)"
        
        // Use your own details here
        let twilioSID = "ACcd491c1121a92a4c271ec00e2a232390"
        let twilioSecret = "782458447b099d967ef45fde496a5483"
        let fromNumber = "+15167144361"
        let toNumber = "%2B91\(NSUserDefaults.standardUserDefaults().valueForKey("friendno1") as! String)"
        let message = "\(firstname)'s Safeway location: \(locationString)"
        
        // Build the request
        let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                let alertController = UIAlertController(title: "Success", message: "Safeway location sent to your friend.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            
            } else {
                // Failure
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                print("Error: \(error)")
                let alertController = UIAlertController(title: "Error", message: "Safeway text not sent due to poor internet connection. Please try again.", preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
       }).resume()
        
        }
                
                else
                {   AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    print("Internet connection FAILED")
                    let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            catch let error as NSError{
                print(error.debugDescription)
            }
    }
    
    @IBAction func Timer(sender: AnyObject) {
        
        // datePickerView:UIDatePicker = UIDatePicker(frame: CGRectMake(0, 420, 380, 230))
        datePickerView.datePickerMode = UIDatePickerMode.CountDownTimer
        datePickerView.backgroundColor = UIColor.lightGrayColor()
        
        //dob.inputView = datePickerView
        self.view.addSubview(datePickerView)
        datePickerView.addTarget(self, action: #selector(Home.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        //done button toolbar
        doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 400, width: 320, height: 40))
        doneToolbar.barStyle = UIBarStyle.Default
        //doneToolbar.tintColor = UIColor.whiteColor()
        doneToolbar.barTintColor = UIColor.init(colorLiteralRed: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(Home.doneButtonActionDOB))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: #selector(Home.cancelButtonActionDOB))
        
        var items = [AnyObject]()
        items.append(cancel)
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.view.addSubview(doneToolbar)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.dateFormat = "HH"
        var timer = dateFormatter.stringFromDate(sender.date)
        let hours = Double(timer)
        //print("hours: \(hours!)")
        
        dateFormatter.dateFormat = "mm"
        timer = dateFormatter.stringFromDate(sender.date)
        let mins = Double(timer)
        //print("mins: \(mins!)")
        
        seconds = (hours!*60+mins!)*60
    }
    
    func doneButtonActionDOB()
    {
        print("secs: \(seconds)")
        datePickerView.removeFromSuperview()
        doneToolbar.removeFromSuperview()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //alert
        let alertController = UIAlertController(title: "Local Notification for Success will be sent upon task completion.", message: "", preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        let delayTime = 1.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })

        //delay for task
        delay = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: #selector(Home.timedMessage), userInfo: nil, repeats: true)
        
    }
    
    func timedMessage()
    {
        print("If you smell what the Rock is cooking.")
        
        print("\(NSUserDefaults.standardUserDefaults().objectForKey("timerText") as? String)")
        
        // Use your own details here
        let twilioSID = "ACcd491c1121a92a4c271ec00e2a232390"
        let twilioSecret = "782458447b099d967ef45fde496a5483"
        let fromNumber = "+15167144361"
        let toNumber = "%2B91\(NSUserDefaults.standardUserDefaults().objectForKey("friendno1") as! String)"
        let message = "\(NSUserDefaults.standardUserDefaults().objectForKey("timerText") as! String)\nSent from Safeway."
        
        // Build the request
        let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)

        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
                
                let notification = UILocalNotification()
                notification.alertBody = "Safeway user-defined timer text sent successfully."
                notification.alertAction = "open"
                notification.timeZone = NSTimeZone.localTimeZone()
                notification.fireDate = NSDate(timeIntervalSinceNow: 3)
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                let alertController = UIAlertController(title: "Success", message: "Safeway user-defined timer text sent to your friend.", preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })

            } else {
                // Failure
                print("Error: \(error)")
                let notification = UILocalNotification()
                notification.alertBody = "Error! Please check Internet Connection."
                notification.alertAction = "open"
                notification.timeZone = NSTimeZone.localTimeZone()
                notification.fireDate = NSDate(timeIntervalSinceNow: 3)
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                print("Error: \(error)")
                let alertController = UIAlertController(title: "Error", message: "Unable to send timer text. Please check Internet Connection.", preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }).resume()
        
        
        delay.invalidate()
    }
    
    func cancelButtonActionDOB()
    {
        datePickerView.removeFromSuperview()
        doneToolbar.removeFromSuperview()
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil)!.first as! CustomInfoWindow
        
        infoWindow.image.layer.cornerRadius = 75.0/2.0
        
        //infoWindow.photo.layer.cornerRadius = infoWindow.photo.frame.width/2
        infoWindow.name.text = NSUserDefaults.standardUserDefaults().valueForKey("firstname") as? String
        infoWindow.address.text = "\(location),\n\(street),\n\(city)"
        
        
        infoWindow.image.image = imageForMarker
        return infoWindow
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: ({
            self.centreBtn.center.y = self.view.frame.height / 4
        }), completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [], animations: ({
            self.centreBtn.center.y = self.view.frame.height / 6
        }), completion: nil)
        UIView.animateWithDuration(0.9, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: [], animations: ({
            self.centreBtn.center.y = self.view.frame.height / 4
        }), completion: nil)
        UIView.animateWithDuration(1, delay: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: [], animations: ({
            self.centreBtn.center.y = self.view.frame.height / 5.5
        }), completion: nil)
        UIView.animateWithDuration(1.05, delay: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: [], animations: ({
            self.centreBtn.center.y = self.view.frame.height / 4
        }), completion: nil)
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(event!.subtype == UIEventSubtype.MotionShake) {
            print("Device shaken")
            //Home.CentreButton(Home)
            
            let firstname = NSUserDefaults.standardUserDefaults().objectForKey("firstname") as! String
            let phonenumber = NSUserDefaults.standardUserDefaults().objectForKey("phoneno") as! String
            
            
            // Use your own details here
            let twilioSID = "ACcd491c1121a92a4c271ec00e2a232390"
            let twilioSecret = "782458447b099d967ef45fde496a5483"
            let fromNumber = "+15167144361"
            let toNumber = "%2B91\(NSUserDefaults.standardUserDefaults().valueForKey("friendno1") as! String)"
            let message = "Your friend \(firstname) is in trouble. Please contact him/her at %2B\(phonenumber)\nSent from Safeway."
            
            // Build the request
            var request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
            request.HTTPMethod = "POST"
            request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
            
            // Build the completion block and send the request
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                print("Finished")
                if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    // Success
                    print("Response: \(responseDetails)")
                    
                    // local notification
                    let notification = UILocalNotification()
                    notification.alertBody = "Safeway shake alert text sent successfully."
                    notification.alertAction = "open"
                    notification.timeZone = NSTimeZone.localTimeZone()
                    notification.fireDate = NSDate(timeIntervalSinceNow: 3)
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    let alertController = UIAlertController(title: "Success", message: "Safeway shake alert text sent to your friend.", preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    })

                } else {
                    // Failure
                    print("Error: \(error)")
                    let notification = UILocalNotification()
                    notification.alertBody = "Error! Please check Internet Connection."
                    notification.alertAction = "open"
                    notification.timeZone = NSTimeZone.localTimeZone()
                    notification.fireDate = NSDate(timeIntervalSinceNow: 3)
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    print("Error: \(error)")
                    let alertController = UIAlertController(title: "Error", message: "Unable to send shake alert. Please check Internet Connection.", preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            }).resume()
            
            
            let toNumber2 = "%2B91\(NSUserDefaults.standardUserDefaults().valueForKey("friendno2") as! String)"
            
            // Build the request
            request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
            request.HTTPMethod = "POST"
            request.HTTPBody = "From=\(fromNumber)&To=\(toNumber2)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
            
            // Build the completion block and send the request
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                print("Finished")
                if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    // Success
                    print("Response: \(responseDetails)")
                    
                    
                    
                } else {
                    // Failure
                    print("Error: \(error)")
                }
            }).resume()
            
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
