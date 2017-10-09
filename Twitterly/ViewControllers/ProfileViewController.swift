//
//  ProfileViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 10/8/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var backgroundProfileImage: UIImageView!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var userDescription: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var numFollowers: UILabel!
  @IBOutlet weak var numFollowing: UILabel!
  
  var tweets:[Tweet] = []
  var isMoreDataLoading = false
  var loadingMoreView:InfiniteScrollActivityView?
  var refreshControl: UIRefreshControl = UIRefreshControl()
  var user:TwitterUser? {
    didSet {
      view.layoutIfNeeded()
      
      backgroundProfileImage.setImageWith(user?.backgroundProfilePic ?? URL(string:"")!)
      profileImage.setImageWith(user?.profilePic ?? URL(string:"")!)
      profileImage.setRadius()
      userNameLabel.text = user?.name
      screenNameLabel.text = "@\(user?.screenName ?? "")"
      userDescription.text = user?.bio
      numFollowers.text = String(describing: user!.numFollowers)
      numFollowing.text = String(describing: user!.numFollowing)
      loadUserTimeline(useOffset: false)
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup table view data source
    tableView.dataSource = self
    tableView.delegate = self
    loadUserTimeline(useOffset: false)
    
    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
    loadingMoreView = InfiniteScrollActivityView(frame: frame)
    loadingMoreView!.isHidden = true
    tableView.addSubview(loadingMoreView!)
    
    var insets = tableView.contentInset
    insets.bottom += InfiniteScrollActivityView.defaultHeight
    tableView.contentInset = insets
    
    // Add UI refreshing on pull down
    refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    // Register the nib for table view cell
    tableView.register(UINib.init(nibName: "TweetViewCell", bundle: nil), forCellReuseIdentifier: "TweetViewCell")
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK:- Network requests
  private func loadUserTimeline(useOffset: Bool) {
    var maxId: String? = nil
    if useOffset {
      maxId = tweets[tweets.count - 1].id
    }
    
    // Request home timeline
    TwitterClient.sharedInstance?.getUserTimeline(userScreenName: user?.screenName, maxId: maxId, onDataLoad: { (success:Bool, error:Error?, twitterData:[Dictionary<String, Any>]?) in
      self.onTweetsLoaded(useOffset: useOffset, success: success, error: error, twitterData: twitterData)
    })
  }
  
  private func onTweetsLoaded(useOffset: Bool, success:Bool, error:Error?, twitterData:[Dictionary<String, Any>]?) {
    if(success) {
      // Skip the first tweet, as it is repeated
      print("loaded \(twitterData!.count) tweets")
      if useOffset {
        self.tweets.append(contentsOf: Tweet.tweetsFromDictionaries(dictionaries: twitterData ?? [])[1...])
      } else {
        self.tweets = Tweet.tweetsFromDictionaries(dictionaries: twitterData ?? [])
      }
      //self.tableView.reloadData()
      self.tableView.reloadSections([0], with: .automatic)
      self.isMoreDataLoading = false
      self.loadingMoreView!.stopAnimating()
      self.refreshControl.endRefreshing();
      print("total number of tweets \(self.tweets.count)")
    } else {
      self.loadingMoreView!.stopAnimating()
      self.refreshControl.endRefreshing();
      print("Failed to load home timeline")
    }
  }

  // Function called when user tries to refresh
  @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
    loadUserTimeline(useOffset: false)
  }

  // MARK:- Scroll view functions
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      // Calculate the position of one screen length before the bottom of the results
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      
      // When the user has scrolled past the threshold, start requesting
      if(scrollView.contentOffset.y > scrollOffsetThreshold &&
        tableView.isDragging) {
        
        // Update position of loadingMoreView, and start loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
        
        isMoreDataLoading = true
        loadMoreData()
      }
    }
  }
  
  private func loadMoreData() {
    loadUserTimeline(useOffset: true)
  }

  
  // MARK:- Table View functions
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetViewCell", for: indexPath) as! TweetViewCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "tweetDetailSegue", sender: tableView.cellForRow(at: indexPath))
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

