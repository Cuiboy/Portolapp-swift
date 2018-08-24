//
//  PortolaPilotViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/13/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit

class PortolaPilotViewController: UIViewController {
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
