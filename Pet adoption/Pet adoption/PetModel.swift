 
import Foundation
import Firebase

class PetRecord: Codable {
    let petDetails: String?
    let petName: String?
    let city: String?
    let gender: String?
    let petAge: String?
    let petType: String?
    let training: Float?
    let socialiblity: Float?
    let activity: Float?
    let health: Float?
    let petImages: [String]?
    let ownerName: String?
    let ownerLocation: String?
    var documentID: String?
    var ownerPhone:String?
    var ownerEmail:String?
    var id:String?
    var fav : [String]?
}

struct MeetingRequestData: Codable {
    var petId: String
    var ownerEmail: String
    var ownerName: String
    var ownerPhone: String
    var date: String
    var time: String
    var location: String
    var requesterName: String
    var requesterEmail: String
    var requesterPhone: String
    var timestamp: Timestamp?
}
