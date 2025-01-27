//
//  IssueFineViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class IssueFineViewController: UIViewController {

    @IBOutlet weak var tfViolationNumber: UITextField!
    @IBOutlet weak var tfFineAmount: UITextField!
    @IBOutlet weak var txtVwNotes: RDTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
        
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
    }
    
}
