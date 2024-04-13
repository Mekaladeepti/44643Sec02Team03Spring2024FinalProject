 
import UIKit
import MapKit

class AddPetDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, MKMapViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petType: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var training: UISlider!
    @IBOutlet weak var socialibility: UISlider!
    @IBOutlet weak var activity: UISlider!
    @IBOutlet weak var health: UISlider!
    @IBOutlet weak var trainingLbl: UILabel!
    @IBOutlet weak var socialibilityLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var healthLbl: UILabel!
    var selectedCity = ""
    var images: [UIImage] = []
    let category = ["Cat", "Dog", "Bird", "Others"]
    
    @IBOutlet weak var ageType: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        detail.delegate = self
        let layout = CollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout

    }
    
    @IBAction func onAgeType(_ sender: Any) {
        
        let globalPicker = GlobalPicker()
        globalPicker.stringArray = ["Day","Week","Month","Year"]
        
        globalPicker.modalPresentationStyle = .overCurrentContext
        globalPicker.onDone = { [self] index in
            self.ageType.setTitle(globalPicker.stringArray[index], for: . normal)
        }
        self.present(globalPicker, animated: true, completion: nil)
        
    }
    
    @IBAction func onPetType(_ sender: Any) {
        let globalPicker = GlobalPicker()
        globalPicker.stringArray = category
        
        globalPicker.modalPresentationStyle = .overCurrentContext
        globalPicker.onDone = { [self] index in
            self.petType.text = globalPicker.stringArray[index]
        }
        self.present(globalPicker, animated: true, completion: nil)
    }
    @IBAction func onGender(_ sender: Any) {
        let globalPicker = GlobalPicker()
        globalPicker.stringArray = ["Male" , "Female"]
        
        globalPicker.modalPresentationStyle = .overCurrentContext
        globalPicker.onDone = { [self] index in
            self.gender.text = globalPicker.stringArray[index]
        }
        self.present(globalPicker, animated: true, completion: nil)
        
    }
    @IBAction func clickOnAddPetImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
   
    @IBAction func clickOnAddNow(_ sender: UIButton) {
       
        guard let petNameValue = petName.text, !petNameValue.isEmpty,
                  let petTypeValue = petType.text, !petTypeValue.isEmpty,
                  let genderValue = gender.text, !genderValue.isEmpty,
                  let ageValue = age.text, !ageValue.isEmpty,
                  let locationValue = location.text, !locationValue.isEmpty,
                  let detailValue = detail.text, !detailValue.isEmpty else {
                  showAlertView(message: "Please fill in all fields.")
                return
            }
        
        let activityValue = Int(round(activity.value))
        let trainingValue = Int(round(training.value))
        let socialibilityValue = Int(round(socialibility.value))
        let healthValue = Int(round(health.value))
      
        if(images.isEmpty){
            
            showAlertView(message: "Please add images")
        }else {
            
            
          let age = "\(ageValue) \(self.ageType.currentTitle!)"
        
          let database =  [
                "activity": activityValue,
                "city": selectedCity,
                "gender": genderValue,
                "health": healthValue,
                "ownerLocation": locationValue,
                "ownerName": UserDefaultsDb.shared.getName(),
                "ownerEmail": UserDefaultsDb.shared.getEmail(),
                "ownerPhone": UserDefaultsDb.shared.getMobile(),
                "petAge": age,
                "petDetails": detailValue,
                "petName": petNameValue,
                "petType": petTypeValue.lowercased(),
                "socialiblity":socialibilityValue,
                "training": trainingValue,
                "petImages": images
          ] as [String : Any]
            
            
            sender.isEnabled = false
            
            FireDbHelper.shared.addPet(data: database, images: images) { _  in
                
                showGlobalOkeyAlert(message: "Pet Added") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
               
              
    }

    
    
    @IBAction func trainingValueChanged(_ sender: UISlider) {
        let sliderValue = Int(round(sender.value))
        self.trainingLbl.text = "\(sliderValue)"
        print("Slider value: \(sliderValue)")
    }
    
    @IBAction func socilibilityValueChanged(_ sender: UISlider) {
        let sliderValue = Int(round(sender.value))
        self.socialibilityLbl.text = "\(sliderValue)"
        print("Slider value: \(sliderValue)")
    }
    
    @IBAction func activityValueChanged(_ sender: UISlider) {
        let sliderValue = Int(round(sender.value))
        self.activityLbl.text = "\(sliderValue)"
        print("Slider value: \(sliderValue)")
    }
    
    @IBAction func healthValueChanged(_ sender: UISlider) {
        let sliderValue = Int(round(sender.value))
        self.healthLbl.text = "\(sliderValue)"
        print("Slider value: \(sliderValue)")
    }
    
    @IBAction func onLocation(_ sender: Any) {
        let mapKit = MapKitSearchViewController(delegate: self)
        mapKit.modalPresentationStyle = .fullScreen
        present(mapKit, animated: true, completion: nil)
    }

   
}

extension AddPetDetailVC {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! CollectionViewCell
        cell.imageview.image = images[indexPath.item]
        cell.imageview.layer.cornerRadius = 20.0
        cell.imageview.clipsToBounds = true
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let spacingBetweenCells: CGFloat = 10
         let collectionViewWidth = collectionView.frame.width
         let cellWidth = (collectionViewWidth - spacingBetweenCells) / 2
         return CGSize(width: cellWidth, height: 170)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 5
     }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        images.remove(at: sender.tag)
        collectionView.reloadData()
    }
}


extension AddPetDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            images.append(editedImage)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}



extension AddPetDetailVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detail.text == "Description" {
            detail.text = ""
            detail.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == detail {
            if detail.text == "" {
                detail.text = "Description"
                detail.textColor = UIColor.lightGray
            }
        }
    }
}


extension AddPetDetailVC: MapKitSearchDelegate {
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
        
        
        
        if let city = mapItem.placemark.locality {
            self.selectedCity = city
        }
    
       
        mapKitSearchViewController.dismiss(animated: true)
        self.setAddress(mapItem: mapItem)
    }
    
    
    func setAddress(mapItem: MKMapItem) {
        
            self.location.text = mapItem.placemark.mkPlacemark!.description.removeCoordinates()
        
    }
    
}
