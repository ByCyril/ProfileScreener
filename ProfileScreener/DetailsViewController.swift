//
//  DetailsViewController.swift
//  ProfileScreener
//
//  Created by Cyril Garcia on 2/28/21.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    var userInfo = [String: String]()
    
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = userInfo["PersonalName"] ?? "User"
        let company = userInfo["ORG"] ?? "na"
        let phoneNumber = userInfo["PhoneNumber"] ?? "na"
        let email = userInfo["Email"] ?? "na"
        let position = userInfo["ROLE"] ?? "na"
        
        title = name
        
        positionLabel.text = "Position: " + position
        companyLabel.text = "Company: " + company
        phoneNumberLabel.text = "Phone Number: " + phoneNumber
        emailLabel.text = "Email: " + email
    }
    
}
