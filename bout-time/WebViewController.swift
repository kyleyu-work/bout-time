//
//  WebViewController.swift
//  bout-time
//
//  Created by Yi YU on 9/25/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  @IBOutlet weak var webView: UIWebView!
  
  var wikiUrl: URL!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    let wikiUrlRequest = URLRequest(url: wikiUrl)
    webView.loadRequest(wikiUrlRequest)
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  
  @IBAction func dismissWebView() {
    dismiss(animated: true, completion: nil)
  }
}
