 

import UIKit
import MapKit

class RequestMeetingVC: UIViewController {
    
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    
    var allPetData : PetRecord?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        
        self.dateTxt.inputView =  datePicker
        self.timeTxt.inputView = datePicker
        
        self.showDatePicker()
        self.showTimePicker()
        
        self.ownerName.text = allPetData?.ownerName
    }
    
     
    
    @IBAction func onLocation(_ sender: Any) {
        let mapKit = MapKitSearchViewController(delegate: self)
        mapKit.modalPresentationStyle = .fullScreen
        present(mapKit, animated: true, completion: nil)
    }
    
    @IBAction func onRequestMeeting(_ sender: Any) {
        if(dateTxt.text!.isEmpty) {
            showAlertView(message: "Please select date.")
            return
        }else  if(self.timeTxt.text!.isEmpty) {
            showAlertView(message: "Please select time.")
            return
        }else  if(self.locationTxt.text!.isEmpty) {
            showAlertView(message: "Please select location.")
            return
        }else {
            
            let myName = UserDefaultsDb.shared.getName()
            let myEmail = UserDefaultsDb.shared.getEmail()
            let phone = UserDefaultsDb.shared.getPhone()
            
           let meetingRequest =  MeetingRequestData(petId: allPetData?.id ?? "", ownerEmail: allPetData?.ownerEmail ?? "", ownerName: allPetData?.ownerName ?? "", ownerPhone: allPetData?.ownerPhone ?? "", date: dateTxt.text ?? "", time: timeTxt.text ?? "", location: locationTxt.text ?? "", requesterName: myName, requesterEmail: myEmail, requesterPhone: phone, timestamp: nil)
            
            FireDbHelper.shared.addMeetingRequest(meetingRequest: meetingRequest) { success in
                if success {
                    showAlertView(message: "Meeting Request added successfully")
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                }
            }
        }
    }
}

extension RequestMeetingVC {
    func showDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
        }
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneDatePicker))
        doneButton.tintColor = .black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        cancelButton.tintColor = .black
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dateTxt.inputAccessoryView = toolbar
        dateTxt.inputView = datePicker
        
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTxt.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
    func showTimePicker() {
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneOpingTimePicker))
        doneButton.tintColor = .black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        cancelButton.tintColor = .black
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        timeTxt.inputAccessoryView = toolbar
        timeTxt.inputView = timePicker
        
    }
    
    @objc func doneOpingTimePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        timeTxt.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
}

extension RequestMeetingVC: MapKitSearchDelegate {
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, mapItem: MKMapItem) {
    }
    
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, searchReturnedOneItem mapItem: MKMapItem) {
    }
    
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedListItem mapItem: MKMapItem) {
    }
    
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedGeocodeItem mapItem: MKMapItem) {
    }
    
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedAnnotationFromMap mapItem: MKMapItem) {
        print(mapItem.placemark.address)
        
        mapKitSearchViewController.dismiss(animated: true)
        self.setAddress(mapItem: mapItem)
    }
    
    
    func setAddress(mapItem: MKMapItem) {
        
        self.locationTxt.text = mapItem.placemark.mkPlacemark!.description.removeCoordinates()
        
    }
    
}
