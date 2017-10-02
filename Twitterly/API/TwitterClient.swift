//
//  TwitterClient.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/27/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "NmCOUo7FfVRqEvu9fzBYZqLic"
let twitterConsumerSecret = "4nJAy3Ndu7JyhnfTLwMYv7WBvlcm1v5cwhJXLBXMigojNCXlA2"
let twitterBaseURL = URL(string:"https://api.twitter.com/")

class TwitterClient: BDBOAuth1SessionManager {
  
  static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
  
  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?
  
  func getCurrentUser(onDataLoad:@escaping (_ success:Bool, _ error:Error?, _ result:Dictionary<String, Any>?)->Void) {
    
    self.get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
      // Success
      onDataLoad(true, nil, response as? Dictionary)
    }) { (task:URLSessionDataTask?, error:Error) in
      // Failure
      onDataLoad(false, error, nil)
      print("error getting current user data \(error.localizedDescription)")
    }
  }

  func getHomeTimeline(maxId: String?, onDataLoad:@escaping (_ success:Bool, _ error:Error?, _ result:[Dictionary<String, Any>]?)->Void) {
    
    var parameters:[String:Any]? = nil
    if maxId != nil {
      parameters = ["max_id": maxId! ]
    }
    self.get("/1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
      // Success
      onDataLoad(true, nil, response as? [Dictionary])
    }) { (task:URLSessionDataTask?, error:Error) in
      // Failure
      onDataLoad(false, error, nil)
      print("error fetching home timeline \(error.localizedDescription)")
    }
  }

  func login(onSuccess:@escaping ()->Void, onFailure:@escaping (_ error: Error) -> Void) {
    self.loginSuccess = onSuccess
    self.loginFailure = onFailure
    self.deauthorize()
    self.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterly://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
      let authLinkString: String = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)"
      let twitterAuthURL = URL(string:authLinkString)!
      UIApplication.shared.open(twitterAuthURL, options: [:], completionHandler: { (success: Bool) in
        if (success) {
          print("login oauth handoff worked")
        }
      })
      
    }, failure: { (error: Error?) in
      print("error trying to login \(error!.localizedDescription)")
      self.loginFailure?(error!)
    })

  }

  func handleOpenUrl(url: URL) {
    let requestToken: BDBOAuth1Credential = BDBOAuth1Credential(queryString: url.query)
    
    self.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken:requestToken, success: {(accessToken: BDBOAuth1Credential?) in
      self.getCurrentUser(onDataLoad: { (success:Bool, error:Error?, userData: Dictionary<String, Any>?) in
        if success {
          TwitterUser.currentUser = TwitterUser(userData: userData!)
          self.loginSuccess?()
        } else {
          self.loginFailure?(error!)
        }
      })
    }, failure: { (error: Error?) in
      self.loginFailure?(error!)
      print("error while handling url \(error!.localizedDescription)")
    })
    
  }
  
  func logout () {
    TwitterUser.currentUser = nil
    deauthorize()
    NotificationCenter.default.post(TwitterUser.UserLogoutNotification)
  }
  
  func tweet(tweetText: String, onTweetResult:@escaping (_ success:Bool, _ error:Error?)->Void) {
    self.post("1.1/statuses/update.json", parameters: ["status": tweetText], progress: nil, success: { (task:URLSessionDataTask, result:Any?) in
      print("Tweet posted successfully")
      onTweetResult(true, nil)
    }) { (task:URLSessionDataTask?, error:Error) in
      print("Error trying to tweet \(error.localizedDescription)")
      onTweetResult(false, error)
    }
  }
  
  func retweet(tweet: Tweet, onRetweetResult:@escaping (_ success:Bool, _ error:Error?)->Void) {
    self.post("1.1/statuses/retweet/\(tweet.id).json", parameters: ["id": tweet.id], progress: nil, success: { (task:URLSessionDataTask, result:Any?) in
      print("Tweet rewteeted successfully")
      onRetweetResult(true, nil)
    }) { (task:URLSessionDataTask?, error:Error) in
      print("Error trying to retweet \(error.localizedDescription)")
      onRetweetResult(false, error)
    }
  }

  func unRetweet(tweet: Tweet, onRetweetResult:@escaping (_ success:Bool, _ error:Error?)->Void) {
    self.post("1.1/statuses/retweet/\(tweet.id).json", parameters: ["id": tweet.id], progress: nil, success: { (task:URLSessionDataTask, result:Any?) in
      print("Tweet rewteeted successfully")
      onRetweetResult(true, nil)
    }) { (task:URLSessionDataTask?, error:Error) in
      print("Error trying to retweet \(error.localizedDescription)")
      onRetweetResult(false, error)
    }
  }

  func favorite(tweet: Tweet, onFavoriteResult:@escaping (_ success:Bool, _ error:Error?)->Void) {
    self.post("1.1/favorites/create.json", parameters: ["id": tweet.id], progress: nil, success: { (task:URLSessionDataTask, result:Any?) in
      print("Tweet favorited successfully")
      onFavoriteResult(true, nil)
    }) { (task:URLSessionDataTask?, error:Error) in
      print("Error trying to favorite \(error.localizedDescription)")
      onFavoriteResult(false, error)
    }
  }

  func unFavorite(tweet: Tweet, onFavoriteResult:@escaping (_ success:Bool, _ error:Error?)->Void) {
    self.post("1.1/favorites/destroy.json", parameters: ["id": tweet.id], progress: nil, success: { (task:URLSessionDataTask, result:Any?) in
      print("Tweet favorited successfully")
      onFavoriteResult(true, nil)
    }) { (task:URLSessionDataTask?, error:Error) in
      print("Error trying to favorite \(error.localizedDescription)")
      onFavoriteResult(false, error)
    }
  }

}

