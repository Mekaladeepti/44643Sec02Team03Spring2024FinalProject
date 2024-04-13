

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    @IBOutlet weak var imgDog: UIImageView!
    @IBOutlet weak var commonTitle: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var favPet: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(title:String,location:String,description:String,imageUrl:String,fav:[String])  {
        
        self.commonTitle.text = title
        self.locationLbl.text = location
        self.descriptionLbl.text = description

//        if(isFav) {
//            self.favPet.setImage(UIImage(systemName:"heart.fill"), for: .normal)
//        }else {
//            self.favPet.setImage(UIImage(systemName:"heart"), for: .normal)
//        }
        
        if let imageUrl = URL(string: imageUrl) {
                  
            
            self.imgDog.sd_setImage(with: imageUrl, placeholderImage:nil,options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                
            })
            

         }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


var commonUrl = "https://firebasestorage.googleapis.com/v0/b/campus-explorer-4c66e.appspot.com/o/others%2Fpersomn.png?alt=media&token=cfdb2747-58aa-4f06-988d-df85a6ef54be"
