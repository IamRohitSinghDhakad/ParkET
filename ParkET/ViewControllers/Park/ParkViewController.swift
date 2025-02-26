//
//  ParkViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 13/12/24.
//

import UIKit
import GoogleMaps
import CoreLocation
import iOSDropDown


class ParkViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var vwSubVw: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tfSearchZone: UITextField!
    @IBOutlet var subVw: UIView!
    @IBOutlet weak var tfZone: UITextField!
    @IBOutlet weak var tfSelectVehicle: DropDown!
    @IBOutlet weak var tfHours: DropDown!
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var markers: [GMSMarker] = []
    var didCenterMap = false
    var arrData = [ZoneModel]()
    var filteredData = [ZoneModel]()
    var arrrVehicle = [VehicleModel]()
    var strSelectedZoneID = ""
    var objZoneModel : ZoneModel?
    var objVehicleModel : VehicleModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tfSelectVehicle.delegate = self
        self.tfHours.delegate = self
        
        self.tfSelectVehicle.isSearchEnable = false
        self.tfHours.isSearchEnable = false
        
        self.tfHours.optionArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        self.tfHours.didSelect { selectedText, index, id in
            self.tfHours.text = selectedText
        }
        
        self.tfSelectVehicle.didSelect { selectedText, index, id in
            self.tfSelectVehicle.text = selectedText
            print(index)
            self.objVehicleModel = self.arrrVehicle[index]
        }
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.tfSearch.delegate = self
        self.vwSubVw.isHidden = true
        setupMapView()
        setupLocationManager()
        fetchZones()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        call_WsGetVehicleList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.addSubview(isAdd: false)
    }
    
    @IBAction func btnOpenSubVw(_ sender: Any) {
        self.vwSubVw.isHidden = false
    }
    @IBAction func btnCancel(_ sender: Any) {
        self.vwSubVw.isHidden = true
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        self.addSubview(isAdd: false)
        call_WsGetPaymentStatus()
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController")as! PaymentMethodViewController
        //        vc.strZone = self.tfZone.text!
        //        vc.carNumber = self.tfSelectVehicle.text!
        //        vc.hours = self.tfHours.text!
        //        vc.strZoneID = self.strSelectedZoneID
        //        vc.strIsCommingFrom = "Booking"
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnCloseSubVw(_ sender: Any) {
        self.addSubview(isAdd: false)
    }
    
    func setupMapView() {
        mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: mapContainerView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor)
        ])
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    func fetchZones() {
        call_WsGetZones { [weak self] zones, error in
            guard let self = self, let zones = zones else {
                // print("Error fetching zones: \(error ?? \"Unknown error\")")
                return
            }
            self.arrData = zones
            self.filteredData = zones
            self.tblVw.reloadData()
            self.addMarkers(for: zones)
        }
    }
    
    func addMarkers(for zones: [ZoneModel]) {
        for zone in zones {
            if let latStr = zone.lat, let lngStr = zone.lng,
               let latitude = CLLocationDegrees(latStr),
               let longitude = CLLocationDegrees(lngStr) {
                addMarkers(at: latitude, longitude: longitude, imageName: "icon_loc", zone: zone)
            }
        }
    }
    
    //    func addMarker(at latitude: CLLocationDegrees, longitude: CLLocationDegrees, imageName: String) {
    //        let marker = GMSMarker()
    //        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    //        marker.icon = UIImage(named: imageName)
    //        marker.map = mapView
    //        markers.append(marker)
    //    }
    //
    func addMarkers(at latitude: CLLocationDegrees, longitude: CLLocationDegrees, imageName: String, zone: ZoneModel) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.icon = UIImage(named: imageName)
        marker.map = mapView
        marker.userData = zone  // ✅ Set the zone object to marker userData
        markers.append(marker)
        
        print("Marker added for: \(zone.name ?? "Unknown")")  // Debugging log
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !didCenterMap else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
        mapView.camera = camera
        didCenterMap = true
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let cameraUpdate = GMSCameraUpdate.setTarget(marker.position, zoom: 15.0)
        mapView.animate(with: cameraUpdate)
        if let zone = marker.userData as? ZoneModel {
            print(zone)
            self.objZoneModel = zone
            print(objZoneModel?.name ?? "")
            print("Tapped on Marker for: \(zone.name ?? "Unknown")")  // Debug log
            self.tfZone.text = zone.name
            self.strSelectedZoneID = zone.id ?? ""
            if self.arrrVehicle.count == 0 {  // Check if vehicles are available
                self.showToast(message: "Add vechile first!!")
                self.pushVc(viewConterlerId: "VehicleViewController")
            } else {
                self.tfHours.text = ""
                self.tfSelectVehicle.text = ""
                self.addSubview(isAdd: true)
            }
        } else {
            print("⚠️ Marker userData is nil!")
        }
        return true
    }
    
    
}


extension ParkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkTableViewCell", for: indexPath) as! ParkTableViewCell
        let obj = filteredData[indexPath.row]
        cell.lblTitle.text = obj.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedZone = filteredData[indexPath.row]
        tfSearchZone.text = selectedZone.name
        self.tfZone.text = selectedZone.name
        self.objZoneModel = filteredData[indexPath.row]
        self.strSelectedZoneID = selectedZone.id ?? ""
        if let latStr = selectedZone.lat, let lngStr = selectedZone.lng,
           let latitude = CLLocationDegrees(latStr),
           let longitude = CLLocationDegrees(lngStr) {
            let cameraUpdate = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: 15.0)
            mapView.animate(with: cameraUpdate)
        }
        
        if self.arrrVehicle.count == 0 {  // Check if vehicles are available
            self.showToast(message: "Add vechile first!!")
            self.pushVc(viewConterlerId: "VehicleViewController")
        } else {
            self.tfHours.text = ""
            self.tfSelectVehicle.text = ""
            self.addSubview(isAdd: true)  // Only add subview if vehicles are found
        }
        
        
        vwSubVw.isHidden = true
    }
}

extension ParkViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfSearch {
            let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            filterResults(searchText: searchText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == tfSearch {
            filterResults(searchText: "")
        }
        return true
    }
    
    func filterResults(searchText: String) {
        if searchText.isEmpty {
            filteredData = arrData
        } else {
            filteredData = arrData.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        }
        tblVw.reloadData()
    }
}


extension ParkViewController {
    func call_WsGetZones(completion: @escaping ([ZoneModel]?, String?) -> Void) {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            completion(nil, "No Internet Connection")
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "attender_id": ""
        ]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetZone, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [[String: Any]] {
                    self.arrData.removeAll()
                    let zones = resultArray.map { ZoneModel(from: $0) }
                    self.arrData = zones
                    self.tblVw.reloadData()
                    completion(zones, nil)
                } else {
                    completion(nil, "Invalid data format")
                }
            } else {
                let message = response["message"] as? String ?? "Something went wrong!"
                objAlert.showAlert(message: message, title: "", controller: self)
                completion(nil, message)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
            completion(nil, "Request failed. Please try again.")
        }
    }
    
    func call_WsGetVehicleList() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetVehicle, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [[String: Any]] {
                    var arrVehicle = [String]()
                    for data in resultArray{
                        let obj = VehicleModel(from: data)
                        self.arrrVehicle.append(obj)
                        arrVehicle.append("\(obj.brand ?? "") \(obj.model ?? "") (\(obj.vehicle_no ?? ""))")
                    }
                    self.tfSelectVehicle.optionArray = arrVehicle
                    
                    //                    self.arrVehicle = resultArray.map { VehicleModel(from: $0) }
                    //                    self.tblVw.reloadData()
                    
                } else {
                    
                }
            } else {
                // let message = response["message"] as? String ?? "Something went wrong!"
                self.showToast(message: "No vechile found!!")
                //objAlert.showAlert(message: message, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    
    func call_WsGetPaymentStatus() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_CheckPayStatus, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                    
                    var paymentStatus = ""
                    
                    if let payStatus = resultArray["pay_status"]as? String{
                        paymentStatus = payStatus
                    }else if let payStatus = resultArray["pay_status"]as? Int{
                        paymentStatus = "\(payStatus)"
                    }
                    
                    if paymentStatus == "1"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController")as! PaymentMethodViewController
                        vc.objZoneModel = self.objZoneModel
                        vc.objVehicleModel = self.objVehicleModel
                        vc.strZone = self.tfZone.text!
                        vc.carNumber = self.tfSelectVehicle.text!
                        vc.hours = self.tfHours.text!
                        vc.strZoneID = self.strSelectedZoneID
                        vc.strIsCommingFrom = "Booking"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController")as! PaymentMethodViewController
                        vc.objZoneModel = self.objZoneModel
                        vc.objVehicleModel = self.objVehicleModel
                        vc.strZone = self.tfZone.text!
                        vc.carNumber = self.tfSelectVehicle.text!
                        vc.hours = self.tfHours.text!
                        vc.strZoneID = self.strSelectedZoneID
                        vc.strIsCommingFrom = "Direct"
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    
                } else {
                    
                }
            } else {
                // let message = response["message"] as? String ?? "Something went wrong!"
                self.showToast(message: "No vechile found!!")
                //objAlert.showAlert(message: message, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    

    
    func addSubview(isAdd: Bool) {
        if isAdd {
            self.subVw.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(subVw)
            
            UIView.animate(withDuration: 0.5) {
                self.subVw.frame.origin.y = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.subVw.frame.origin.y = self.view.frame.height
            } completion: { y in
                self.subVw.removeFromSuperview()
            }
        }
    }
    
    
    func showToast(message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: window.frame.height - 120, width: window.frame.width - 40, height: 40))
        toastLabel.backgroundColor = .white
        toastLabel.textColor = .red
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        window.addSubview(toastLabel)  // Add toast to key window so it's above the tab bar
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    
    
    
}
