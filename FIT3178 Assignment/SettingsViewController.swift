//
//  SettingsViewController.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 19/05/2022.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSwitch(_ sender: UISwitch) {
        
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first
            
            if sender.isOn {
                appDelegate?.overrideUserInterfaceStyle = .dark
                return
            }
            
            appDelegate?.overrideUserInterfaceStyle = .light
            
        } else {
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
