//
//  MenuViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 10/7/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var numberOfFollowersLabel: UILabel!
  @IBOutlet weak var numFollowingLabel: UILabel!
  
  var hamburgerViewController: HamburgerViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    hamburgerViewController.contentViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
  }
  
  private func setupView() {
    // Setup the view
    profileImageView.setImageWith(TwitterUser.currentUser?.profilePic ?? URL(string:"")!)
    nameLabel.text = TwitterUser.currentUser?.name
    screenNameLabel.text = "@\(TwitterUser.currentUser?.screenName ?? "")"
    numberOfFollowersLabel.text = String(describing: TwitterUser.currentUser!.numFollowers)
    numFollowingLabel.text = String(describing: TwitterUser.currentUser!.numFollowing)
    
    // Make profile image rounded
    profileImageView.setRadius()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func loadProfileView(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    profileViewController.user = TwitterUser.currentUser
    hamburgerViewController.contentViewController = profileViewController
  }

  @IBAction func loadMentionsView(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    (mentionsViewController.childViewControllers[0] as! HomeViewController).timelineType = .Mentions
    hamburgerViewController.contentViewController = mentionsViewController
  }
  
  @IBAction func loadHomeTimelineView(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let homeViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    (homeViewController.childViewControllers[0] as! HomeViewController).timelineType = .Home
    hamburgerViewController.contentViewController = homeViewController
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

