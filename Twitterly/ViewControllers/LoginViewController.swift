//
//  LoginViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/26/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func onLoginButton(_ sender: Any) {
    TwitterClient.sharedInstance?.login(onSuccess: {
      // Transition to home timeline
      print("Login Successful");
    }, onFailure: { (error:Error) in
      print("Error while logging in \(error.localizedDescription)")
    })
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
