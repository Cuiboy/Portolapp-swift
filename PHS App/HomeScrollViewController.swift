//
//  HomeScrollViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 9/20/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit

class HomeScrollViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    var pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: UIPageViewController.NavigationOrientation(rawValue: 0)!, options: nil)

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var distanceConstant: NSLayoutConstraint!
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            storyboard!.instantiateViewController(withIdentifier: "home"),
            storyboard!.instantiateViewController(withIdentifier: "bellSchedule")

        ]
    }()
    
    var currentPage = 0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if self.distanceConstant.constant >= self.distanceConstant.constant.barRelativeToWidth {
            self.distanceConstant.constant = self.distanceConstant.constant.relativeToWidth
        } else {
            self.distanceConstant.constant = self.distanceConstant.constant + CGFloat(20)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageContainer.delegate = self
        pageContainer.dataSource = self
        
        if let firstVC = pages.first {
           
            pageContainer.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            
        }
        
        view.addSubview(pageContainer.view)
        view.bringSubviewToFront(pageControl)
      
        for subview in pageContainer.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentPage == pages.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (currentPage == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentPage == pages.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return pages.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentPage
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        if let currentViewController = pageContainer.viewControllers!.first {
            if let currentIndex = pages.index(of: currentViewController) {
              currentPage = currentIndex
            }
        }
        pageControl.currentPage = currentPage
    }

 
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
        guard let viewControllerIndex = pages.index(of: viewController) else {return nil }
       
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0
            else {return nil }
        
        guard pages.count > previousIndex
            else {return nil}
        
        return pages[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        

        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil}
        return pages[nextIndex]
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
