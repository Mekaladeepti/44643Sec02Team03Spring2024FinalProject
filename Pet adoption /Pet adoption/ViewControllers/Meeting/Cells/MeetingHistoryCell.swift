 

import UIKit

class MeetingHistoryCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var itemDes: UILabel!
    
    override func awakeFromNib() {
        bgView.dropShadow()
    }
    
    func setData(title:String,desc:String) {
        
        self.itemTitle.text = title
        self.itemDes.text = desc
        
    }
    
}
