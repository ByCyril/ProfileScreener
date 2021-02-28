//
//  ViewController.swift
//  ProfileScreener
//
//  Created by Cyril Garcia on 2/28/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var userInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func parseProfile() {
        let nlp = NLPLayer()
        nlp.parse(userInput.text)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        vc.userInfo = nlp.parsedInfo
        show(vc, sender: self)
    }


}

