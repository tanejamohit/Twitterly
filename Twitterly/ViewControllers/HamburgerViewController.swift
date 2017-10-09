//
//  HamburgerViewController.swift
//  Twitterly
//
//  Created by Mohit Taneja on 10/5/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
  
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
  
  var menuOpenPosition:CGFloat?
  
  var menuViewController: MenuViewController! {
    didSet {
      view.layoutIfNeeded()
      menuViewController.view.layoutIfNeeded()
      menuView.addSubview(menuViewController.view)
    }
  }
  
  var contentViewController: UIViewController! {
    didSet {
      view.layoutIfNeeded()
      contentView.addSubview(contentViewController.view)
      contentViewLeadingConstraint.constant = 0
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuOpenPosition = self.view.frame.width - 150
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func showMenu(_ sender: UIPanGestureRecognizer) {
    
    let translation = sender.translation(in: view)
    
    if (sender.state == .changed) {
      contentViewLeadingConstraint.constant = clamp(value: contentViewLeadingConstraint.constant + translation.x, lower: 0, upper: menuOpenPosition ?? 0)
      sender.setTranslation(CGPoint.zero, in: view)
    }
    else if (sender.state == .ended) {
      let velocity = sender.velocity(in: view)
      contentViewLeadingConstraint.constant = (velocity.x > 0) ? menuOpenPosition ?? 0 : 0
    }
  }
  
  func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
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

