
import UIKit
import Firebase

class PetDetailVC: UIViewController {
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var petCategory: UIButton!
    @IBOutlet weak var favPet: UIButton!
    @IBOutlet weak var gender: UIButton!
    @IBOutlet weak var age: UIButton!
    @IBOutlet weak var petDescription: UILabel!
    @IBOutlet weak var training: UIProgressView!
    @IBOutlet weak var socialibility: UIProgressView!
    @IBOutlet weak var activity: UIProgressView!
    @IBOutlet weak var health: UIProgressView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var adoptNowButton: UIButton!
    var images: [String] = []
    
    var allPetData : PetRecord?
    var id = ""
    var favPetBool = false
    
    override func viewDidLoad() {
        
        adoptNowButton.isHidden = true
        
        self.petName.text = ""
        self.location.text = ""
        self.petCategory.setTitle("", for: .normal)
        self.gender.setTitle("", for: .normal)
        self.age.setTitle("", for: .normal)
      
        
        
        getPetDetail()
    }
    func petData() {
        self.petName.text = allPetData?.petName
        self.location.text = allPetData?.city
        self.petCategory.setTitle(allPetData?.petType, for: .normal)
        self.gender.setTitle(allPetData?.gender, for: .normal)
        self.age.setTitle(allPetData?.petAge, for: .normal)
        
        self.petDescription.text = allPetData?.petDetails
        
        self.training.progress = (allPetData?.training ?? 0.0) / 10
        self.socialibility.progress = (allPetData?.socialiblity ?? 0.0) / 10
        self.health.progress = (allPetData?.health ?? 0.0) /  10
        self.activity.progress = (allPetData?.activity ?? 0.0) / 10
        
        self.mobile.text = allPetData?.ownerPhone ?? "NA"
        self.ownerName.text = allPetData?.ownerName
        self.mobile.text = "\(allPetData?.ownerPhone ?? "")"
        self.email.text = "\(allPetData?.ownerEmail ?? "")"
        self.images = allPetData?.petImages ?? [""]
        
        self.favPetBool = self.allPetData?.fav?.contains(UserDefaultsDb.shared.getEmail().lowercased()) ?? false
       
        if(favPetBool) {
            self.favPet.setImage(UIImage(systemName:"heart.fill"), for: .normal)
        }else {
            self.favPet.setImage(UIImage(systemName:"heart"), for: .normal)
        }
        
        
        let imageUrls = allPetData?.petImages ?? [""]
        
        downloadImages(from: imageUrls) { urls in
            print("Downloaded image URLs: \(urls)")
            self.setupImageSlideShow(imageUrls: urls)
        }
        
        if let ownerEmail = allPetData?.ownerEmail {
            
            if(ownerEmail.lowercased() == UserDefaultsDb.shared.getEmail().lowercased()) {
                // my self
              self.adoptNowButton.isHidden = true
            }else {
              self.adoptNowButton.isHidden = false
            }
        }
        
    }
    
     
    func downloadImages(from urls: [String], completion: @escaping ([String]) -> Void) {
        var downloadedImageUrls: [String] = []
        
        let dispatchGroup = DispatchGroup()
        
        for urlString in urls {
            if let imageUrl = URL(string: urlString) {
                dispatchGroup.enter()
                
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let error = error {
                        print("Error downloading image from \(urlString): \(error)")
                        return
                    }
                    
                    downloadedImageUrls.append(urlString)
                }.resume()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(downloadedImageUrls)
        }
    }
     
    @IBAction func onFavClick(_ sender: UIButton) {
        guard let petName = allPetData?.id else {
            return
        }
        
        let isCurrentlyFav = favPetBool
        let newFavState = !isCurrentlyFav
        
        FireDbHelper.shared.addPetInFavorite(id: petName, fav: newFavState) { petId, success in
            if success {
                let heartImageName = newFavState ? "heart.fill" : "heart"
                self.favPet.setImage(UIImage(systemName: heartImageName), for: .normal)
                self.favPetBool = newFavState
                let message = newFavState ? "Favorite added" : "Favorite removed"
                
                
                if newFavState {
                               // If the pet is marked as a favorite, add the user's email to the local fav array
                               self.allPetData?.fav?.append(UserDefaultsDb.shared.getEmail().lowercased())
                           } else {
                               // If the pet is unmarked as a favorite, remove the user's email from the local fav array
                               self.allPetData?.fav?.removeAll(where: { $0 == UserDefaultsDb.shared.getEmail().lowercased() })
                    }
                
                showAlertView(message: message)
            }
        }
    }
    
    @IBAction func clickOnAdoptNow(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "RequestMeetingVC" ) as! RequestMeetingVC
        vc.allPetData = allPetData
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getPetDetail(){
    
        
        FireDbHelper.shared.getPetDetail(id: self.id) { pet in
            self.allPetData = pet
            self.petData()
        }
        
    }

    
    func setupImageSlideShow(imageUrls: [String]) {
        var localSource: [InputSource] = []
        
        for imageUrl in imageUrls {
            guard let url = URL(string: imageUrl) else {
                continue
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }
                
                DispatchQueue.main.async {
                    localSource.append(ImageSource(image: image))
                    self.imageSlideShow.setImageInputs(localSource)
                }
            }.resume()
        }
        
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = .scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
    }
}

extension PetDetailVC: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        
    }
    
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}
