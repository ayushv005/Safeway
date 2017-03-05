//
//  Feedback.swift
//  sample1
//
//  Created by Ayush Verma on 29/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit
import MessageUI

class Feedback: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var viewFeedback: UIView!
    @IBOutlet weak var feebackBarBtn: UIBarButtonItem!
    @IBOutlet weak var sendFeedBtn: UIButton!
    @IBOutlet weak var feedbackText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendFeedBtn.layer.cornerRadius = 7
        feedbackText.layer.cornerRadius = 7
        
        feebackBarBtn.target = self.revealViewController()
        feebackBarBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        //logo
        let imageView = UIImageView(frame: CGRect(x: -20, y: 0, width: 150, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "safeway2")
        imageView.image = image
        navigationItem.titleView = imageView

        //disable keyboard
        let disablekeyboard : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController2.processKeyboardDisable(_:)))
        disablekeyboard.numberOfTapsRequired = 1
        viewFeedback.addGestureRecognizer(disablekeyboard)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processKeyboardDisable (sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }

    @IBAction func sendFeedAction(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["vayush005@gmail.com"])
        mailComposerVC.setSubject("Safeway - Feedback")
        mailComposerVC.setMessageBody(feedbackText.text, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Could Not Send Feedback", message: "Please check internet connection or e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
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
