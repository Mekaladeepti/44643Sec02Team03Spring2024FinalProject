
import UIKit

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate   {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var noData: UILabel!
    var globalPicker = GlobalPicker()
    var locationKey = ""
    let category = ["Cat", "Dog", "Bird", "Others"]
    let dogcategory = [UIImage(named: "dog"), UIImage(named: "dog2"), UIImage(named: "dog3"), UIImage(named: "dog4"), UIImage(named: "dog")]

    var allPetData: [PetRecord] = []

    var locationData : [String] = [""]
    var petType = "cat"
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        self.locationTxt.text = "New York"
        self.petRecord(petType: "cat")

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now()  + 3, execute: {
//            let vc = NewMessageController()
//            self.navigationController?.pushViewController(vc, animated: true)
//           
//        })
      
    }
    
    @IBAction func clickOnPlus(_ sender: Any) {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier:  "AddPetDetailVC" ) as! AddPetDetailVC
                 self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func petRecord(petType : String){
        FireDbHelper.shared.getPetRecord(petType: petType, location: self.locationTxt.text ?? "") { petData in
            self.allPetData = petData
            self.tableView.isHidden = true

            self.noData.text = "No \(petType) Found"
            
            self.tableView.isHidden = self.allPetData.count != 0 ? false : true
            self.noData.isHidden = self.allPetData.count != 0 ? true : false

            print(self.allPetData)
            
            self.tableView.reloadData()
        }
    }
    
    

    @IBAction func onLocation(_ sender: UIButton) {
        sender.isEnabled = false
        FireDbHelper.shared.fetchAllLocationNames { location in
            self.locationData = location
            sender.isEnabled = true
            
            self.globalPicker.stringArray = self.locationData
            
            self.globalPicker.modalPresentationStyle = .overCurrentContext
            self.globalPicker.onDone = { [self] index in
              locationKey =  globalPicker.stringArray[index]
                self.locationTxt.text = locationKey
                
                FireDbHelper.shared.getPetRecord(petType: self.petType, location: self.locationTxt.text ?? "") { petData in
                    self.allPetData = petData
                    self.tableView.isHidden = true
                    
                    self.tableView.isHidden = self.allPetData.count != 0 ? false : true
                    self.noData.isHidden = self.allPetData.count != 0 ? true : false

                    print(self.allPetData)
                    
                    self.tableView.reloadData()
                }
            }
            self.present(self.globalPicker, animated: true, completion: nil)
            
        }
        
    }

}


extension HomeVC {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return category.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
           cell.backgroundColor = UIColor.blue
           cell.textLbl?.text = category[indexPath.item].lowercased()
           return cell
       }

       // MARK: - UICollectionViewDelegate

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if let selectedIndex = selectedIndex {
               let previousSelectedCell = collectionView.cellForItem(at: selectedIndex) as? CollectionViewCell
               previousSelectedCell?.backView?.backgroundColor = .white
               previousSelectedCell?.textLbl?.textColor = .black
           }
           
           if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
               cell.backView?.backgroundColor = UIColor.appColor
               cell.textLbl?.textColor = .white
           }
           
           selectedIndex = indexPath

           self.petType = category[indexPath.item].lowercased()
           self.petRecord(petType: category[indexPath.item].lowercased())
       }
}


extension HomeVC{
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allPetData.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let allPetData = allPetData[indexPath.row]

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            
            cell.setData(title: allPetData.petName ?? "", location: allPetData.city ?? "", description: allPetData.petDetails ?? "", imageUrl: allPetData.petImages?.first ?? "", fav: allPetData.fav ?? [])
            
            return cell
        }

        // MARK: - UITableViewDelegate

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let allPetData = allPetData[indexPath.row]

            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "PetDetailVC" ) as! PetDetailVC
            vc.id = allPetData.id ?? ""
    
            self.navigationController?.pushViewController(vc, animated: true)

        }
}
