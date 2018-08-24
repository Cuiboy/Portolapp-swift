//
//  PNNViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/13/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit

class PNNViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
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
