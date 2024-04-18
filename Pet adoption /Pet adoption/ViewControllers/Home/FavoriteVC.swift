 

import UIKit

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noData: UILabel!

    var allPetData: [PetRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.petRecord(petType: "cat")
    }
    
    
    func petRecord(petType : String){
        FireDbHelper.shared.getFavoritePet() { petData in
            self.allPetData = petData
            self.tableView.isHidden = true
            self.noData.text = "No Favorite Found"

            self.tableView.isHidden = self.allPetData.count != 0 ? false : true
            self.noData.isHidden = self.allPetData.count != 0 ? true : false

            print(self.allPetData)
            
            self.tableView.reloadData()
        }
    }
    
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
