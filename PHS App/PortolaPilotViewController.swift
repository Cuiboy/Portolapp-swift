//
//  PortolaPilotViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/13/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import SwiftyXMLParser
import Segmentio



class PortolaPilotViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return current.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let article = current[indexPath.row]
           let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
            cell.newsTitle.text = article.title
            cell.authorLabel.text = article.author
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
            cell.dateLabel.text = formatter.string(from: article.pubDate)
        if article.image != nil {
            cell.thumbnail.image = article.image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    

    var content = [SegmentioItem]()
    
    var articles = [NewsArticle]()
    var groupDictionary = [String: [NewsArticle]]()
    var groupCategories = [String]()
    var current = [NewsArticle]()
    
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var newsTableView: UITableView!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
       print("VIEW DID LOAD")
        
        
        setSegmentedControl()
        if CheckInternet.Connection() {
            performSelector(inBackground: #selector(parseFeed), with: nil)
        } else {
             setAlertController(title: "No Internet Connection", message: "We could not load any news articles because you are not connected to the Internet.", preferredStyle: .alert, actionTitle: "OK")
        }
        newsTableView.delegate = self
        newsTableView.dataSource = self 

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if current.count == 0 {
            indicator.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
            indicator.center = self.view.center
            indicator.color = UIColor.black
            indicator.startAnimating()
            indicator.alpha = 1
            view.addSubview(indicator)
            view.bringSubview(toFront: indicator)
        }
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            switch segmentIndex {
                
            case 0:
              self.current = self.articles
            case 1:
                self.current = self.groupDictionary["NEWS"] ?? []
            case 2:
                  self.current = self.groupDictionary["OPINION"] ?? []
            case 3:
                  self.current = self.groupDictionary["FEATURES"] ?? []
            case 4:
                  self.current = self.groupDictionary["SHOWCASE"] ?? []
            case 5:
                  self.current = self.groupDictionary["SPORTS"] ?? []
            case 6:
                  self.current = self.groupDictionary["A&E"] ?? []
            case 7:
                  self.current = self.groupDictionary["THE PAW PRINT"] ?? []
            default:
                print("more coming")
            }
            self.newsTableView.reloadData()
        }
    }
    
    
    
    func setSegmentedControl() {
        
        let position = SegmentioPosition.dynamic
        let indicator = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 1, color: .white)
        let horizontal = SegmentioHorizontalSeparatorOptions(type: SegmentioHorizontalSeparatorType.none)
        let vertical = SegmentioVerticalSeparatorOptions(ratio: 0.1, color: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0))
        segmentioView.selectedSegmentioIndex = 0
        let options = SegmentioOptions(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), segmentPosition: position, scrollEnabled: true, indicatorOptions: indicator, horizontalSeparatorOptions: horizontal, verticalSeparatorOptions: vertical, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: (
            defaultState: SegmentioState(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), titleFont: UIFont(name: "Lato-Bold", size: CGFloat(16).relativeToWidth)!, titleTextColor: UIColor.white.withAlphaComponent(0.5)),
            selectedState: SegmentioState(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), titleFont: UIFont(name: "Lato-Bold", size: CGFloat(16).relativeToWidth)!, titleTextColor: .white),
            highlightedState: SegmentioState(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), titleFont: UIFont(name: "Lato-Bold", size: CGFloat(16).relativeToWidth)!, titleTextColor: .white)
            )
            ,animationDuration: 0.2)
        
        let allItem = SegmentioItem(title: "ALL", image: nil)
        let aeItem = SegmentioItem(title: "A&E", image: nil)
        let featuresItem = SegmentioItem(title: "FEATURES", image: nil)
        let opinionItem = SegmentioItem(title: "OPINION", image: nil)
        let pawPrintItem = SegmentioItem(title: "PAW PRINT", image: nil)
        let sportsItem = SegmentioItem(title: "SPORTS", image: nil)
        let newsItem = SegmentioItem(title: "NEWS", image: nil)
        let showcaseItem = SegmentioItem(title: "SHOWCASE", image: nil)
        content = [allItem, newsItem, opinionItem, featuresItem, showcaseItem, sportsItem, aeItem, pawPrintItem]
        segmentioView.setup(content: content, style: .onlyLabel, options: options)
        
    }
    
    func setAlertController(title: String, message: String?, preferredStyle: UIAlertControllerStyle, actionTitle: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
       present(ac, animated: true)
    }

    
    func loadThumbnail(url: URL) -> UIImage? {
   
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
            return image
            
        } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    
    
    @objc func parseFeed() {
        if let xmlContent = try? String(contentsOf: URL(string: "https://portolapilot.com/feed/")!) {
            let xml = try! XML.parse(xmlContent)
            let itemArray = xml["rss"]["channel"]["item"].all!
            
            for i in 0...itemArray.count - 1 {
                let item = itemArray[i]
                //configure categories array
               var categories = [String?]()
                for elements in item.childElements {
                    if elements.name == "category" {
                        categories.append(elements.text)
                    }
                }
                if categories.count < 3 {
                    for _ in 0...(2 - categories.count) {
                        categories.append(nil)
                    }
                }
                let object = xml["rss"]["channel"]["item"][i]
                let article = NewsArticle()
                article.title = object["title"].text ?? "News Article"
                article.link = object["link"].text ?? "https://portolapilot.com/"
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                formatter.timeZone = Calendar.current.timeZone
                formatter.locale = Calendar.current.locale
                let dateString = object["pubDate"].text
                if dateString != nil {
                    article.pubDate = formatter.date(from: dateString!)!
                } else {
                    article.pubDate = Date.distantPast
                }
                article.author = object["dc:creator"].text ?? "Student Journalist"
                article.category1 = categories[0]!
                article.category2 = categories[1]
                article.category3 = categories[2]
                article.content = object["content:encoded"].text?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? "Error Loading Article."
                if let linkString = object["link"].text {
                    let array = linkString.components(separatedBy: "/")
                        if array.count >= 5 {
                        let shortTitle = array[3]
                            if let data = try? String(contentsOf: URL(string: "http://portolapilot.com/wp-json/oembed/1.0/embed?url=http%3A%2F%2Fportolapilot.com%2F\(shortTitle)%2F")!) {
                                if let jsonData = JSON(parseJSON: data).dictionaryObject!["thumbnail_url"] as? String {
                                    if let urlImage = URL(string: jsonData) {
                                        article.image = loadThumbnail(url: urlImage)
                                    }
                                }
                            }
                    }
                }
                articles.append(article)
                
            }
            
           generateTypes()
            
        } else {
            setAlertController(title: "Error", message: "There was an error accessing Portola Pilot feed, please try again later.", preferredStyle: .alert, actionTitle: "OK")
        }
       
    }

    func generateTypes() {
        for news in articles {
            
                
                let key = news.category1
                let key2 = news.category2
                let key3 = news.category3
                
               
                let upper = key.uppercased()
                let upper2 = key2?.uppercased()
                let upper3 = key3?.uppercased()
                
                if var newsType = groupDictionary[upper] {
                   newsType.append(news)
                    groupDictionary[upper] = newsType
                } else {
                    
                    groupDictionary[upper] = [news]
                }
            if upper2 != nil {
                if var newsType2 = groupDictionary[upper2!] {
                    newsType2.append(news)
                    groupDictionary[upper] = newsType2
                } else {
                    
                    groupDictionary[upper2!] = [news]
                }
            }
            
            if upper3 != nil {
                if var newsType3 = groupDictionary[upper3!] {
                    newsType3.append(news)
                    groupDictionary[upper] = newsType3
                } else {
                    groupDictionary[upper3!] = [news]

                }
            }
            
            

            
    }
        groupCategories = [String](groupDictionary.keys)
        print(groupCategories)
        DispatchQueue.main.async {
            self.indicator.viewFadeOut()
            self.current = self.articles
            self.newsTableView.reloadData()
        }
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
