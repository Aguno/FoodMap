//
//  ViewController.swift
//  FoodMap
//
//  Created by USER on 2018. 1. 15..
//  Copyright © 2018년 Aguno. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}
class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate,  UITextFieldDelegate {
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    var menuArray:  [[String]] = []
    var tagArray: Array<(title:String, hours:String, number: String, img: UIImage)> = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GMSServices.provideAPIKey("AIzaSyD77Kq6d_YFlCVtdR0TTEdUl3IhsQuljv0")
        self.title = "FoodMap"
        self.view.backgroundColor = UIColor.white
        myMapView.delegate=self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        setupViews()
        
        initGoogleMaps()
        txtFieldSearch.delegate=self
        showPartyMarkers(category: "chicken")
        
    }
    
    func initGoogleMaps() {
        //Set camera to 궁동
        //36.365003, 127.345276
        let camera = GMSCameraPosition.camera(withLatitude: 36.365003, longitude: 127.345276, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.myMapView.animate(to: camera)
        
        
    }
    
    // MARK: GOOGLE MAP DELEGATE
    //when mark tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = tagArray[customMarkerView.tag]
        //deleted price
        restaurantPreviewView.setData(title: data.title,hours: data.hours, number: data.number, img: data.img)
        return restaurantPreviewView
    }
    //when the preview is clicked
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        restaurantTapped(tag: tag)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    func showPartyMarkers(category: String) {
        myMapView.clear()
        //GET from server
        print(category)
        var latitudeArr = Array<double_t>()
        var longitudeArr = Array<double_t>()
        Alamofire.request("http://143.248.132.103:80/"+category).responseJSON { response in
            switch response.result{
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    let json = JSON(data)
                    //self.jsonArray = json
                    self.tagArray = []
                    self.menuArray = []
                    var i = 0
                    for item in json.arrayValue{
                        latitudeArr.append(double_t(item["latitude"].floatValue))
                        longitudeArr.append(double_t(item["longitude"].floatValue))
                        let marker=GMSMarker()
                        let chickenNumber = String(i+1)
                        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: self.customMarkerWidth, height: self.customMarkerHeight),image: #imageLiteral(resourceName: category+chickenNumber), borderColor: UIColor.darkGray, tag: i)
                            i+=1
                        marker.iconView = customMarker
                        marker.position = CLLocationCoordinate2D(latitude: double_t(item["latitude"].floatValue), longitude: double_t(item["longitude"].floatValue))
                        marker.map=self.myMapView
                        
                        self.tagArray.append((title: item["name"].stringValue,hours:item["openinghours"].stringValue,number : item["phonenumber"].stringValue, img: #imageLiteral(resourceName: category+chickenNumber)))
                        
                        var b: [String] = []
                        var list = item["menu"].arrayValue
                        
                        for i in 0 ..< list.count{
                            b.append(list[i].stringValue)
                        }
                        self.menuArray.append(b)
                        
                    }
                    
                    print("something here")
                    
                    print(self.tagArray)
                    print(self.menuArray)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //my location button pressed
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    
    @objc func btnCategoryAction() {
        let pasta :String = "pasta"
        showPartyMarkers(category: pasta)
        //궁동 좌표 36.361409, 127.350300
        let camera = GMSCameraPosition.camera(withLatitude: 36.361409, longitude: 127.350300, zoom: 17.0)
        self.myMapView.camera = camera
    }
    
    @objc func btnchickenAction() {
        let chicken :String = "chicken"
        showPartyMarkers(category: chicken)
        let camera = GMSCameraPosition.camera(withLatitude: 36.361409, longitude: 127.350300, zoom: 17.0)
        self.myMapView.camera = camera
        
    }
    @objc func btnBoonShikAction() {
        let chicken :String = "boonshik"
        showPartyMarkers(category: chicken)
        let camera = GMSCameraPosition.camera(withLatitude: 36.361409, longitude: 127.350300, zoom: 17.0)
        self.myMapView.camera = camera
    }
    /*
    let settingsLauncher = SettingsLauncher()
    @objc func handleMore(){
        settingsLauncher.showSettings()
    }
    
    */
    @objc func restaurantTapped(tag: Int) {
        let v=DetailsVC()
        v.passedData = tagArray[tag]
        
        v.menulist = menuArray[tag]
        
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    func setupViews() {
        //Add GMS
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        //Add previewView
        restaurantPreviewView=PreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        //Add my location 
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        
        
        self.view.addSubview(btnCategory)
        btnCategory.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive=true
        btnCategory.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnCategory.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnCategory.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        self.view.addSubview(btnChicken)
        btnChicken.topAnchor.constraint(equalTo: btnCategory.topAnchor, constant: 50).isActive=true
        btnChicken.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnChicken.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnChicken.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        self.view.addSubview(btnBoonShik)
        btnBoonShik.topAnchor.constraint(equalTo: btnChicken.topAnchor, constant: 50).isActive=true
        btnBoonShik.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnBoonShik.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnBoonShik.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
    }
    
    let myMapView: GMSMapView = {
        let v=GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "gps"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    //Button for different category
    let btnCategory: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "pasta"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.addTarget(self, action: #selector(btnCategoryAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnChicken: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "roast-turkey (4)"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.addTarget(self, action: #selector(btnchickenAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnBoonShik: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "boonshik"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.addTarget(self, action: #selector(btnBoonShikAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
 
    var restaurantPreviewView: PreviewView = {
        let v=PreviewView()
        return v
    }()
    

}

