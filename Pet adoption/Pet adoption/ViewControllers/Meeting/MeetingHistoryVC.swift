import UIKit

class MeetingHistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var meetings = [MeetingRequestData]()
    var myMeeting = true 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCells([MeetingHistoryCell.self])
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    func loadData() {
        
        if(myMeeting) {
            FireDbHelper.shared.getMyMeetings { data in
                self.meetings = data
                self.tableView.reloadData()
            }
        }else {
            FireDbHelper.shared.getReceivedMeetingRequests { data in
                self.meetings = data
                self.tableView.reloadData()
            }
        }
      
    }
}

extension MeetingHistoryVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingHistoryCell", for: indexPath) as! MeetingHistoryCell
        let booking = meetings[indexPath.row]

        let title = "Meeting \(indexPath.row + 1)"
        
        if(myMeeting) {
            
            let desc = """
                Meeting Date: \(booking.date)\n
                Meeting Time: \(booking.time)\n
                Location: \(booking.location)\n
                Owner Name: \(booking.ownerName)\n
                Owner Email: \(booking.ownerEmail)\n
                Owner Phone: \(booking.ownerPhone)\n
                """
            
            cell.setData(title: title, desc: desc)
            
        }else {
            
            let desc = """
                Meeting Date: \(booking.date)\n
                Meeting Time: \(booking.time)\n
                Location: \(booking.location)\n
                Requester Name: \(booking.requesterName)\n
                Requester Email: \(booking.requesterEmail)\n
                Requester Phone: \(booking.requesterPhone)\n
                """

            cell.setData(title: title, desc: desc)
            
        }
       

        return cell
    }
  

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "PetDetailVC" ) as! PetDetailVC
        vc.id =  self.meetings[indexPath.row].petId

        self.navigationController?.pushViewController(vc, animated: true)
        
         
       
    }
}
