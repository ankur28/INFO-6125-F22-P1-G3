//
//  ViewController.swift
//  WordleGame
//
//  Created by Ankur Kalson on 2022-10-18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var q_key: UIButton!
    
    @IBOutlet weak var w_key: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func keyboardPres(sender: UIButton) {
        switch sender {
        case q_key:
            // Change Language to French
            print ("q is pressed")
            break
        case w_key:
            // or Spanish
            print ("w is pressed")
            break
        default:
            break

        }

    }

}

