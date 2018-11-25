//
//  NewsDetailViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/30/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import SDWebImage

class NewsDetailViewController: UIViewController {

    @IBAction func actionTapped(_ sender: Any) {
        let ac = UIActivityViewController(activityItems: [storyURL!], applicationActivities: [])
        present(ac, animated: true)
        
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsInfo: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    
    var titleText = String()
    var info = String()
    var imageLink: URL?
    var news = String()
    var storyLink = String()
    var storyURL: URL?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        storyURL = URL(string: storyLink)
        navigationBar.my_setNavigationBar()
        newsTitle.text = titleText.uppercased()
        newsInfo.text = info.uppercased()
        imageView.sd_setImage(with: imageLink, placeholderImage: UIImage(named: "newsPlaceholder"))
        let newsFix = news.replacingOccurrences(of: "<p>", with: "<br><p>")
        let attributedText = try! NSAttributedString(data: newsFix.data(using: .unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue ], documentAttributes: nil)
  
        content.text = attributedText.string
        
//        let attributedString = NSMutableAttributedString(string: content.text!)
//        let attributes: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Lato-Regular", size: CGFloat(18).relativeToWidth), .foregroundColor: UIColor.blue]
//
//        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: 1))
//        content.attributedText = attributedString
       
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
