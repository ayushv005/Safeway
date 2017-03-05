 //
//  AppDelegate.swift
//  sample1
//
//  Created by Ayush Verma on 08/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.becomeFirstResponder() //related to shake

        GMSServices.provideAPIKey("AIzaSyAZKVQJs3On0uBCiMzp5F313u3RqcuZ1qY")
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        

        // UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if let bool = NSUserDefaults.standardUserDefaults().valueForKey("bool")
        {
            
            if(bool as! String == "1")
            {
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainView")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
            }
                
            else
            {
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Login")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
            
        else
        {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("Login")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        
        //let navBackgroundImage:UIImage! = UIImage(named: "navimg.jpg")
       // UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, forBarMetrics: .Default)
       
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ayush.sample1" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("sample1", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
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

}

