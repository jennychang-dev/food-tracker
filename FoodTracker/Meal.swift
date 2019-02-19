import UIKit
import os.log

//////////////////////////////////////////////////////////
//    we will use NSCoding to persist data
//    to conform  to NSCoding, we need to subclass NSObject as that's the base class
////////////////////////////////////////////////////////

class Meal: NSObject, NSCoding {
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var calories: Int
    var details: String
    var userId: Int
    var id: Int
    
    // marking these constants as static means they belong to the class instead of an instance of the class
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let calories = "calories"
        static let details = "details"
        static let userId = "userId"
        static let id = "id"
    }
    
    init?(name: String, photo: UIImage?, rating: Int, calories: Int, details: String, userId: Int, id: Int) {
        
        // adding ! makes means not
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.calories = calories
        self.details = details
        self.id = id
        self.userId = userId
    }
    
//////////////////////////////////////////////////////////
//    NSCoding methods
    
//     1st - encode(with) - prepares the class's info to be archived

//     2nd - init?(coder) - unarchives the data when the class is created
//          REQUIRED - initializer must be implemented on every subclass, if the subclass defines its own initializers
//          CONVENIENCE - this is a secondary initializer, and that it must call a designiation initializer from the same class
////////////////////////////////////////////////////////
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(calories, forKey: PropertyKey.calories)
        aCoder.encode(details, forKey: PropertyKey.details)
        aCoder.encode(userId, forKey: PropertyKey.userId)
        aCoder.encode(id, forKey: PropertyKey.id)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            
            os_log("unable to decode the name for a meal object as your name isn't a string", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let calories = aDecoder.decodeInteger(forKey: PropertyKey.calories)
        let details = aDecoder.decodeObject(forKey: PropertyKey.details) as! String
        let userId = aDecoder.decodeInteger(forKey: PropertyKey.userId)
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        
        self.init(name: name, photo: photo, rating: rating, calories: calories, details: details, userId: userId, id: id)
    }

}
