//
//  Tweet.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/27/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var text: String
  var retweetCount: Int = 0
  var favoriteCount: Int = 0
  var user: TwitterUser?
  var id: String
  var creationDate: Date
  var favorited: Bool
  var retweeted: Bool
  
  init(tweetData: Dictionary<String, Any>) {
    text = tweetData["text"] as? String ?? ""
    retweetCount = tweetData["retweet_count"] as? Int ?? 0
    favoriteCount = tweetData["favourites_count"] as? Int ?? 0
    id = tweetData["id_str"] as? String ?? ""
    favorited = tweetData["favorited"] as? Bool ?? false
    retweeted = tweetData["retweeted"] as? Bool ?? false
    
    // Extract the creation date
    creationDate = Date.init()
    if tweetData["created_at"] != nil {
      let timestampString: String = tweetData["created_at"] as? String ?? ""
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      creationDate = formatter.date(from: timestampString)!
    }
    
    // Extract the user
    if tweetData["user"] != nil {
      user = TwitterUser(userData: tweetData["user"] as! Dictionary<String, Any>)
    }
    
  }
  
  // MARK:- Functions on tweets
  func retweet() {
    TwitterClient.sharedInstance?.retweet(tweet: self, onRetweetResult: { (success: Bool, error: Error?) in
      if success {
        print("Retweet successful")
      } else {
        print("Failed to retweet \(error!.localizedDescription)")
      }
    })
  }
  
  func unRetweet() {
    TwitterClient.sharedInstance?.retweet(tweet: self, onRetweetResult: { (success: Bool, error: Error?) in
      if success {
        print("Retweet successful")
      } else {
        print("Failed to retweet \(error!.localizedDescription)")
      }
    })
  }

  
  func favorite() {
    TwitterClient.sharedInstance?.favorite(tweet: self, onFavoriteResult: { (success: Bool, error: Error?) in
      if success {
        print("Favorite successful")
      } else {
        print("Failed to favorite \(error!.localizedDescription)")
      }
    })
  }
  
  func unFavorite() {
    TwitterClient.sharedInstance?.unFavorite(tweet: self, onFavoriteResult: { (success: Bool, error: Error?) in
      if success {
        print("Favorite successful")
      } else {
        print("Failed to favorite \(error!.localizedDescription)")
      }
    })
  }
  
  // MARK:- Helper functions
  // Return list of tweets from json data fetched from Twitter
  class func tweetsFromDictionaries(dictionaries: [Dictionary<String, Any>]) -> [Tweet] {
    var tweetArray: [Tweet] = []
    for dictionary in dictionaries {
      tweetArray.append(Tweet(tweetData: dictionary))
    }
    return tweetArray
  }

}

