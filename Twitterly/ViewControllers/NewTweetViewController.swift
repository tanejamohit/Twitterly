//
//  TweetDetailViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/30/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

protocol NewTweetDelegate {
  func newTweetAdded(tweet: Tweet);
}

class NewTweetViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var tweetCharCountLabel: UILabel!
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetInputField: UITextView!
  
  var delegate: NewTweetDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tweetCharCountLabel.text = "140"
    profilePicture.setImageWith(TwitterUser.currentUser?.profilePic ?? URL(string:"")!)
    userNameLabel.text = TwitterUser.currentUser?.name
    screenNameLabel.text = "@\(TwitterUser.currentUser?.screenName ?? "")"
    
    tweetInputField.delegate = self
    tweetInputField.becomeFirstResponder()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
 func textViewDidChange(_ textView: UITextView) {
    tweetCharCountLabel.text = String(140 - tweetInputField.text.count)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let maxLength = 140
    let currentString: NSString = textView.text! as NSString
    let newString: NSString =
      currentString.replacingCharacters(in: range, with: text) as NSString
    return newString.length <= maxLength

  }

  @IBAction func tweet(_ sender: Any) {
    TwitterClient.sharedInstance?.tweet(tweetText: tweetInputField.text, onTweetResult: { (success: Bool, error: Error?) in
      if success {
        self.tweetInputField.resignFirstResponder()
        let newTweet: Tweet = Tweet(tweetData: [:])
        newTweet.text = self.tweetInputField.text
        newTweet.user = TwitterUser.currentUser
        self.delegate?.newTweetAdded(tweet: newTweet)
        self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
        print("Successfully posted tweet")
      } else {
        print("Failed to post tweet")
      }
    })
  }
  
  @IBAction func cancelTweet(_ sender: Any) {
    self.tweetInputField.resignFirstResponder()
    self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
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

