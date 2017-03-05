//
//  TableSidebar.swift
//  sample1
//
//  Created by Ayush Verma on 13/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit

class TableSidebar: UIViewController {

    @IBOutlet weak var tableSideBar: UITableView!
    
    let label = ["Home","My Profile","Settings","F.A.Q's","Feedback" ,"Logout"]
    
    let icons = ["home.png","profile.png","settings.png","faq.png","feedback.png","logout.png"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return label.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TableCellSideBar = self.tableSideBar.dequeueReusableCellWithIdentifier("Cell") as! TableCellSideBar
        
        cell.labelcell.text = self.label [indexPath.row]
        cell.imgcell.image = UIImage(named: icons [indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // print("You selected cell #\(indexPath.row)!")
        
        if indexPath.row==0{
            self.performSegueWithIdentifier("gotohome", sender: self)
        }
        if indexPath.row==1{
            self.performSegueWithIdentifier("gotoprofile", sender: self)
        }
        if indexPath.row==2{
            self.performSegueWithIdentifier("gotosettings", sender: self)
        }
        if (indexPath as NSIndexPath).row==3{
            self.performSegueWithIdentifier("gotofaq", sender: self)
        }
        if indexPath.row==4{
            self.performSegueWithIdentifier("gotofeedback", sender: self)
        }
        if indexPath.row==5{
    
    let alert = UIAlertController(title: "Confirm", message: "Are you sure you wish to logout?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                [unowned self] (action) -> Void in
                NSUserDefaults.standardUserDefaults().setValue("0", forKey: "bool")
                self.performSegueWithIdentifier("gotologin", sender: self)
                }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in print("you have pressed the Cancel button")
    }))
    self.presentViewController(alert, animated: true, completion: nil)
    
    
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
