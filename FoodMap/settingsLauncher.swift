//
//  settingsLauncher.swift
//  FoodMap
//
//  Created by USER on 2018. 1. 17..
//  Copyright © 2018년 Aguno. All rights reserved.
//

import UIKit
class SettingsLauncher: NSObject{
    
    let blackView = UIView()

    
    let collectionView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    let chickenImageView: UIImageView = {
        let v=UIImageView()
        v.image = #imageLiteral(resourceName: "roast-turkey")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let chickenTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Chicken"
        lbl.font=UIFont.systemFont(ofSize: 28)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let pastaImageView: UIImageView = {
        let v=UIImageView()
        v.image = #imageLiteral(resourceName: "pasta")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let pastaTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Pasta"
        lbl.font=UIFont.systemFont(ofSize: 28)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let boonShikImageView: UIImageView = {
        let v=UIImageView()
        v.image = #imageLiteral(resourceName: "boonshik")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let boonShikTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "BoonShik"
        lbl.font=UIFont.systemFont(ofSize: 28)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            }
        }
    }
    
    @objc func showSettings(){
        if let window = UIApplication.shared.keyWindow{
            
            self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //add gesture recognizer
            self.blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(self.blackView)
            
            window.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            self.blackView.frame = window.frame
            self.blackView.alpha = 0
            //add categories

            
            
            
            UIView.animate(withDuration: 1, delay:0,usingSpringWithDamping:1,initialSpringVelocity: 1, options: .curveEaseOut,animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 200, height: window.frame.height)
                self.collectionView.addSubview(self.chickenImageView)
                self.chickenImageView.topAnchor.constraint(equalTo: self.collectionView.topAnchor).isActive=true
                self.chickenImageView.leftAnchor.constraint(equalTo: self.collectionView.leftAnchor).isActive=true
                self.chickenImageView.heightAnchor.constraint(equalToConstant: 20).isActive=true
                self.chickenImageView.widthAnchor.constraint(equalToConstant: 20).isActive=true
            }, completion: nil)
 
        }
        
    }
    

    
    override init(){
        super.init()

    }
}
