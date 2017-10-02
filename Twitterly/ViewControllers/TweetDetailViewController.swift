//
//  TweetDetailViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 10/1/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
  
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var screenName: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var retweetCount: UILabel!
  @IBOutlet weak var favoriteCount: UILabel!
  @IBOutlet weak var favoriteIcon: UIButton!
  @IBOutlet weak var retweetIcon: UIButton!
  
  
  var tweet: Tweet?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    profilePic.setImageWith(tweet?.user?.profilePic ?? URL(string:"https://google.com")!)
    userName.text = tweet?.user?.name
    screenName.text = "@\(tweet?.user?.screenName ?? "")"
    tweetText.text = tweet?.text
    retweetCount.text = String(describing:tweet!.retweetCount)
    favoriteCount.text = String(describing:tweet!.favoriteCount)
    if tweet!.favorited {
      favoriteIcon.setImage(UIImage(named:"favorited"), for: UIControlState.normal)
    }
    if tweet!.retweeted {
      retweetIcon.setImage(UIImage(named:"retweeted"), for: UIControlState.normal)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func replyToTweet(_ sender: Any) {
  }
  
  @IBAction func retweet(_ sender: Any) {
    if tweet!.retweeted {
      //tweet?.unRetweet()
    } else {
      tweet?.retweet()
      tweet?.retweeted = true
      tweet?.retweetCount += 1
      retweetCount.text = String(describing:tweet!.retweetCount)
      retweetIcon.setImage(UIImage(named:"retweeted"), for: UIControlState.normal)
    }
  }

  @IBAction func favoriteTweet(_ sender: Any) {
    if tweet!.favorited {
      tweet?.unFavorite()
      tweet?.favorited = false
      tweet?.favoriteCount -= 1
      favoriteCount.text = String(describing:tweet!.favoriteCount)
      favoriteIcon.setImage(UIImage(named:"favorite"), for: UIControlState.normal)
    } else {
      tweet?.favorite()
      tweet?.favorited = true
      tweet?.favoriteCount += 1
      favoriteCount.text = String(describing:tweet!.favoriteCount)
      favoriteIcon.setImage(UIImage(named:"favorited"), for: UIControlState.normal)
    }
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

