
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import FirebaseDatabase
import Photos

class FireDbHelper {
    
    public static let shared = FireDbHelper()
    
    var storageRef: StorageReference!
    var db: Firestore!
    var dbRef : CollectionReference!
    var gallary : CollectionReference!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        dbRef = db.collection("Users")
        gallary = db.collection("Gallary")
        storageRef = Storage.storage().reference()
    }
    
    
    func registerUser(name:String,email:String,password:String,mobile:String) {
        
        self.checkAlreadyExistAndRegister(email:email, name:name,password:password,mobile:mobile)
    }
    
    
    func loginUser(email:String,password:String,completion: @escaping (Bool)->()) {
        let  query = db.collection("Users").whereField("email", isEqualTo: email)
        
        query.getDocuments { (querySnapshot, err) in
            
            if(querySnapshot?.count == 0) {
                showAlertView(message: "Email not found!!")
            }else {
                
                if let document = querySnapshot!.documents.first {
                    
                    
                    if let pwd = document.data()["password"] as? String{
                        
                        if(pwd == password) {
                            
                            let name = document.data()["name"] as? String ?? ""
                            let email = document.data()["email"] as? String ?? ""
                            let password = document.data()["password"] as? String ?? ""
                            let mobile = document.data()["mobile"] as? String ?? ""
                            let address = document.data()["address"] as? String ?? ""
                            
                            UserDefaultsDb.shared.saveData(name: name, email: email, password: password,mobile:mobile, address: address, documentId: document.documentID)
                            completion(true)
                            
                        }else {
                            showAlertView(message: "Password doesn't match")
                        }
                        
                    }else {
                        showAlertView(message: "Something went wrong!!")
                    }
                    
                }
                
                
            }
        }
    }
    
    
    
    func checkAlreadyExistAndRegister(email:String,name:String,password:String,mobile:String) {
        
        getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
            
            print(querySnapshot.count)
            
            if(querySnapshot.count > 0) {
                showAlertView(message: "This Email is Already Registerd!!")
            }else {
                
                
                
                self.getQueryFromFirestore(field: "mobile", compareValue: mobile) { querySnapshot in
                    
                    print(querySnapshot.count)
                    
                    if(querySnapshot.count > 0) {
                        showAlertView(message: "This Mobile is Already Registerd!!")
                    }else {
                        
                        let data = ["name":name,"email":email,"password":password, "userType" : "Pet Donor" ,"mobile":mobile] as [String : Any]
                        
                        self.addDataInDb(data: data) { _ in
                            
                            showGlobalOkeyAlert(message: "Registration Success!!") {
                                
                                DispatchQueue.main.async {
                                    SceneDelegate.shared?.setHomeScreen()
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func getQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
        
        dbRef.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
            
            if let err = err {
                
                showAlertView(message: "Error getting documents: \(err)")
                return
            }else {
                
                if let querySnapshot = querySnapshot {
                    return completionHandler(querySnapshot)
                }else {
                    showAlertView(message: "Something went wrong!!")
                }
                
            }
        }
        
    }
    
    func addDataInDb(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
        let dbr = db.collection("Users")
        dbr.addDocument(data: data) { err in
            if let err = err {
                showAlertView(message: "Error adding document: \(err)")
            } else {
                completionHandler("success")
            }
        }
    }
    
    func addPet(data: [String:Any], images: [UIImage], completionHandler: @escaping (Any) -> Void) {
        var dataWithID = data // Create a mutable copy of the original data
        
        showLoading()
        
        let db = Firestore.firestore().collection("Pet")
        
        // Add the document ID reference to the data
        let documentReference = db.document()
        let documentID = documentReference.documentID
        dataWithID["id"] = documentID
        
        // Upload images to Firebase Storage
        var imageUrls: [String] = []
        let dispatchGroup = DispatchGroup()
        
        for (index, image) in images.enumerated() {
            dispatchGroup.enter()
            let imageRef = Storage.storage().reference().child("pet_images/\(documentID)_\(index)")
            guard let imageData = image.jpegData(compressionQuality: 0.1) else { continue }
          
            imageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    dispatchGroup.leave()
                } else {
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                            dispatchGroup.leave()
                        } else if let url = url {
                            imageUrls.append(url.absoluteString)
                            dispatchGroup.leave()
                        }
                    }
                }
            }
        }
        
        // When all images are uploaded, update the "petImages" field in Firestore
        dispatchGroup.notify(queue: .main) {
            dataWithID["petImages"] = imageUrls
            documentReference.setData(dataWithID) { error in
                
                hideLoading()
                if let error = error {
                    print("Error adding document: \(error)")
                    completionHandler(error)
                } else {
                    print("Document added with ID: \(documentID)")
                    completionHandler(documentID)
                }
            }
        }
    }


    
    func getPetRecord(petType: String, location: String, completion: @escaping ([PetRecord]) -> Void) {
        let dbRef = db.collection("Pet")
           var query = dbRef.whereField("petType", isEqualTo: petType.lowercased())
           
           if !location.isEmpty {
               query = query.whereField("city", isEqualTo: location.capitalized)
           }
           
           query.getDocuments { querySnapshot, err in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion([])
                }else {
                    
                    var list: [PetRecord] = []
                    for document in querySnapshot!.documents {
                        do {
                            let temp = try document.data(as: PetRecord.self)
                            list.append(temp)
                        } catch let error {
                            print(error)
                        }
                    }
                    completion(list)
                }
            }
    }
    
    
    func getFavoritePet(completion: @escaping ([PetRecord]) -> Void) {
        let myEmail = UserDefaultsDb.shared.getEmail().lowercased()
        
        db.collection("Pet").whereField("fav", arrayContains: myEmail).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var favoritePets: [PetRecord] = []
                for document in querySnapshot!.documents {
                    do {
                        let pet = try document.data(as: PetRecord.self)
                        favoritePets.append(pet)
                    } catch let error {
                        print("Error decoding pet: \(error)")
                    }
                }
                completion(favoritePets)
            }
        }
    }

    
    
    func fetchPetsByLocation(locationName: String, completion: @escaping ([PetRecord]) -> Void) {
        let petsCollection = self.db.collection("Pet")
        
        petsCollection.whereField("city", isEqualTo: locationName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting pets by location: \(error)")
                completion([])
                return
            }
            
            else {
                
                var list: [PetRecord] = []
                for document in querySnapshot!.documents {
                    do {
                        let temp = try document.data(as: PetRecord.self)
                        list.append(temp)
                    } catch let error {
                        print(error)
                    }
                }
                completion(list)
            }
        }
    }
    
    func fetchAllLocationNames(completion: @escaping ([String]) -> Void) {
        let petsCollection = self.db.collection("Pet")
        
        petsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([""])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                completion([""])
                return
            }
            
            var locationNames: [String] = []
            
            for document in documents {
                if let locationName = document["city"] as? String {
                    locationNames.append(locationName)
                }
            }
            
            completion(locationNames)
        }
    }
    
    func addMeetingRequest(meetingRequest: MeetingRequestData, completion: @escaping (Bool) -> Void) {
        let meetingsCollection = self.db.collection("meetings")
        
        meetingsCollection.addDocument(data: [
            "petId": meetingRequest.petId,
            "ownerEmail": meetingRequest.ownerEmail,
            "ownerName": meetingRequest.ownerName,
            "ownerPhone": meetingRequest.ownerPhone,
            "date": meetingRequest.date,
            "time": meetingRequest.time,
            "location": meetingRequest.location,
            "requesterName": meetingRequest.requesterName,
            "requesterEmail": meetingRequest.requesterEmail,
            "requesterPhone": meetingRequest.requesterPhone,
            "timestamp": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(false)
            } else {
                print("Document added successfully")
                completion(true)
            }
        }
    }

    
    func getMyMeetings(completion: @escaping ([MeetingRequestData]) -> Void) {
       
        let myEmail = UserDefaultsDb.shared.getEmail().lowercased()
        
        db.collection("meetings")
            .whereField("requesterEmail", isEqualTo: myEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting accommodation offers: \(error.localizedDescription)")
                    completion([])
                } else {
                    
                    var list: [MeetingRequestData] = []
                    
                    for document in querySnapshot!.documents {
                        do {
                            var temp = try document.data(as: MeetingRequestData.self)
                            list.append(temp)
                        } catch let error {
                            print(error)
                        }
                    }
                    completion(list)
                }
            }
    }
    
    func getReceivedMeetingRequests(completion: @escaping ([MeetingRequestData]) -> Void) {
       
        let myEmail = UserDefaultsDb.shared.getEmail().lowercased()
        
        db.collection("meetings")
            .whereField("ownerEmail", isEqualTo: myEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting accommodation offers: \(error.localizedDescription)")
                    completion([])
                } else {
                    
                    var list: [MeetingRequestData] = []
                    
                    for document in querySnapshot!.documents {
                        do {
                            var temp = try document.data(as: MeetingRequestData.self)
                            list.append(temp)
                        } catch let error {
                            print(error)
                        }
                    }
                    completion(list)
                }
            }
    }
    
    
    func addPetInFavorite(id: String, fav: Bool, completion: @escaping (String, Bool) -> Void) {
        let petRef = db.collection("Pet").document(id)
        let myEmail = UserDefaultsDb.shared.getEmail().lowercased()
        
        if fav {
            // If fav is true, append your email to the "fav" array
            petRef.updateData(["fav": FieldValue.arrayUnion([myEmail])]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(id, false)
                } else {
                    print("Document successfully updated")
                    completion(id, true)
                }
            }
        } else {
            // If fav is false, remove your email from the "fav" array
            petRef.updateData(["fav": FieldValue.arrayRemove([myEmail])]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(id, false)
                } else {
                    print("Document successfully updated")
                    completion(id, true)
                }
            }
        }
    }

    
    
    func getPetDetail(id: String, completion: @escaping (PetRecord?) -> Void) {
        let petRef = db.collection("Pet").document(id)
        
        petRef.getDocument { document, error in
            if let error = error {
                print("Error getting pet document: \(error)")
                completion(nil)
            } else {
                if let document = document, document.exists {
                    do {
                        let pet = try document.data(as: PetRecord.self)
                        completion(pet)
                    } catch let error {
                        print("Error decoding pet document: \(error)")
                        completion(nil)
                    }
                } else {
                    print("Pet document does not exist")
                    completion(nil)
                }
            }
        }
    }

    

}


extension FireDbHelper {
    
    
    func getFavoritePets(forUserEmail userEmail: String, completion: @escaping ([PetRecord]) -> Void) {
        db.collection("Pet").whereField("fav", arrayContains: userEmail).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var list: [PetRecord] = []
                for document in querySnapshot!.documents {
                    do {
                        let temp = try document.data(as: PetRecord.self)
                        list.append(temp)
                    } catch let error {
                        print(error)
                    }
                }
                completion(list)
            }
        }
    }

    
}
