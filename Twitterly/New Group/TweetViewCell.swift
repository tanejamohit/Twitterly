//
//  TweetViewCell.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/30/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
  
  @IBOutlet weak var userProfilePic: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userScreenName: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  
  var tweet: Tweet? {
    didSet {
      userProfilePic.setImageWith(tweet?.user?.profilePic ?? URL(string:"")!)
      userName.text = tweet?.user?.name
      userScreenName.text = "@\(tweet?.user?.screenName ?? "")"
      tweetText.text = tweet?.text
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

