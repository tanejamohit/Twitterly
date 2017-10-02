//
//  HomeViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 9/30/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NewTweetDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets:[Tweet] = []
  var isMoreDataLoading = false
  var loadingMoreView:InfiniteScrollActivityView?
  var refreshControl: UIRefreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Setup table view data source
    tableView.dataSource = self
    tableView.delegate = self
    loadHomeScreen(useOffset: false)
    
    // Add Scroll Loading view for infinite scrolling
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
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadHomeScreen(useOffset: Bool) {
    var maxId: String? = nil
    if useOffset {
      maxId = tweets[tweets.count - 1].id
    }
    // Request home timeline
    TwitterClient.sharedInstance?.getHomeTimeline(maxId: maxId, onDataLoad: { (success:Bool, error:Error?, twitterData:[Dictionary<String, Any>]?) in
      if(success) {
        // Skip the first tweet, as it is repeated
        print("loaded \(twitterData!.count) tweets")
        if useOffset {
        self.tweets.append(contentsOf: Tweet.tweetsFromDictionaries(dictionaries: twitterData ?? [])[1...])
        } else {
          self.tweets = Tweet.tweetsFromDictionaries(dictionaries: twitterData ?? [])
        }
        self.tableView.reloadData()
        self.isMoreDataLoading = false
        self.loadingMoreView!.stopAnimating()
        self.refreshControl.endRefreshing();
        print("total number of tweets \(self.tweets.count)")
      } else {
        self.loadingMoreView!.stopAnimating()
        self.refreshControl.endRefreshing();
        print("Failed to load home timeline")
      }
    })
    
  }
  
  // Function called when user tries to refresh
  @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
    loadHomeScreen(useOffset: false)
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
  
  @IBAction func onLogout(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
  
  @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
    
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
  
  func loadMoreData() {
    loadHomeScreen(useOffset: true)
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "newTweetSegue" {
      let newTweetViewController = segue.destination as! NewTweetViewController
      newTweetViewController.delegate = self
    } else if segue.identifier == "tweetDetailSegue" {
      let cell = sender as! UITableViewCell
      let indexPath = tableView.indexPath(for: cell)
      let tweetDetailViewController = segue.destination as! TweetDetailViewController
      tweetDetailViewController.tweet = tweets[indexPath!.row];
    }
  }
  
  func newTweetAdded(tweet: Tweet) {
    print("numtweets = \(tweets.count)")
    tweets.insert(tweet, at: 0)
    self.tableView.reloadData()
  }

}

