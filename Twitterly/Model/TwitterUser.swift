//
//  TwitterUser.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/27/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit
import AFNetworking

class TwitterUser: NSObject {
  var name: String
  var profilePic:URL
  var backgroundProfilePic:URL
  var screenName: String
  var id: String
  var bio: String
  var numFollowers: Int
  var numFollowing: Int
  var dictionary: Dictionary<String, Any>
  
  static var UserLogoutNotification = Notification(name: NSNotification.Name(rawValue: "userLoggedOut"), object: nil)
  
  // Save the current user in Defaults and load it from the same
  static var _currentUser: TwitterUser?
  class var currentUser: TwitterUser? {
    get {
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.data(forKey: "currentUserData")
        if let userData = userData {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! Dictionary<String, Any>
          _currentUser = TwitterUser(userData: dictionary)
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary , options: [])
        defaults.set(data, forKey: "currentUserData")
      } else {
        defaults.set(nil, forKey: "currentUserData")
      }
      defaults.synchronize()
    }
  }
  
  // Initializer
  init(userData:Dictionary<String, Any>) {
    name = userData["name"] as? String ?? ""
    id = userData["id_str"] as? String ?? ""
    var profilePicUrl: String = userData["profile_image_url_https"] as? String ?? ""
    if profilePicUrl != "" {
      profilePicUrl = profilePicUrl.replacingOccurrences(of: "_normal", with: "")
    }
    profilePic = URL(string:profilePicUrl)!
    let backgroundPicUrl: String = userData["profile_background_image_url_https"] as? String ?? ""
    backgroundProfilePic = URL(string:backgroundPicUrl)!

    screenName = userData["screen_name"] as? String ?? ""
    numFollowers = userData["followers_count"] as? Int ?? 0
    numFollowing = userData["friends_count"] as? Int ?? 0
    bio = userData["description"] as? String ?? ""

    dictionary = userData
  }
  
}

