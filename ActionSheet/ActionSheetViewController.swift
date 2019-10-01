//
//  ActionSheetViewController.swift
//  ActionSheet
//
//  Created by Britto Thomas on 01/10/19.
//  Copyright © 2019 Britto Thomas. All rights reserved.
//

import UIKit

class ActionSheetViewController: ViewController {

    var instance        : ActionSheetViewController!
    var containerView   = UIView()
    var overlayColor    = UIColor(white: 0, alpha: 0.2)
    var showing         = false
    let tag             = 2345
    
    var keyWindow:UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        }else {
            return UIApplication.shared.keyWindow
        }

    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        let dissmisTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissSheet))
        self.view.addGestureRecognizer(dissmisTapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show() {
        self.view.backgroundColor = overlayColor
        self.initContainerView()
        
        UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 0,
                                   options: .curveEaseIn,
                                   animations: {
                                    self.containerView.frame.origin.y = self.view.frame.height - self.containerView.frame.height
                                    self.getTopViewController()?.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                    self.getTopViewController()?.view.layer.cornerRadius = 10
                                   }, completion: nil)
    }
    
    
    @objc func dismissSheet() {
        showing = false
        UIView.animate(withDuration: 0.2,
                                   animations: {
                                    self.containerView.frame.origin.y = self.view.frame.height
                                    self.view.backgroundColor = UIColor(white: 0, alpha: 0)
                                    self.getTopViewController()?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    self.getTopViewController()?.view.layer.cornerRadius = 0
        },
                                   completion:  { (finished) in
                                    self.view.removeFromSuperview()
        })
    }
    
    func getTopViewController() -> UIViewController? {
        
        if let keyWindow = self.keyWindow {
            var topVC = keyWindow.rootViewController
            while topVC?.presentedViewController != nil {
                topVC = topVC?.presentedViewController
            }
            return topVC
        }
        return nil
    }
    
    func initContainerView() {
        
        
        for subView in containerView.subviews {
            subView.removeFromSuperview()
        }
        
        for subView in self.view.subviews {
            subView.removeFromSuperview()
        }
        
        showing = true
        instance = self
        let viewWidth = view.frame.width * 0.95
        let viewHeight:CGFloat = 200
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.frame = CGRect(x: 10, y:view.frame.height , width: viewWidth, height: viewHeight)
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.95, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -20),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: viewHeight)
            ])
        
        if let keyWindow = self.keyWindow {
            if keyWindow.viewWithTag(tag) == nil {
                view.tag = tag
                keyWindow.addSubview(view)
            }
        }
    }
}
