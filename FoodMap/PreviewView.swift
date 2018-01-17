//
//  PreviewView.swift
//  FoodMap
//
//  Created by USER on 2018. 1. 15..
//  Copyright © 2018년 Aguno. All rights reserved.
//

import Foundation
import UIKit

class PreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.clipsToBounds=true
        self.layer.masksToBounds=false
        setupViews()
    }
    
    func setData(title: String,hours: String, number: String, img: UIImage) {
        lblTitle.text = title
        imgView.image = img
        lblHours.text = hours
        lblNumber.text = number
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        containerView.addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive=true
        imgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive=true
        imgView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        containerView.addSubview(lblTitle)
        lblTitle.leftAnchor.constraint(equalTo: imgView.rightAnchor).isActive=true
        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor).isActive=true
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        containerView.addSubview(lblHours)
        lblHours.leftAnchor.constraint(equalTo: imgView.rightAnchor).isActive=true
        lblHours.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive=true
        lblHours.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lblHours.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(lblNumber)
        lblNumber.leftAnchor.constraint(equalTo: imgView.rightAnchor).isActive=true
        lblNumber.topAnchor.constraint(equalTo: lblHours.bottomAnchor).isActive=true
        lblNumber.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lblNumber.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        

    }
    
    let containerView: UIView = {
        let v=UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.image=#imageLiteral(resourceName: "chicken2")
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let lblHours: UILabel = {
        let lbl=UILabel()
        lbl.text = "Hour"
        lbl.font=UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblNumber: UILabel = {
        let lbl=UILabel()
        lbl.text = "Number"
        lbl.font=UIFont.boldSystemFont(ofSize: 11)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
