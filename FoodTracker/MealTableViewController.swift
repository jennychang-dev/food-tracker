import UIKit
import os_object

class MealTableViewController: UITableViewController {

    var meals = [Meal]()
    var meal: Meal!
    var data: Data!
    var json = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // goes into editing mode on its own!!
        navigationItem.leftBarButtonItem = editButtonItem
        
        print("attempting to load meals")
        loadMeals()
    }
    
//////////////////////////////////////////////////////////
//    reverse segue - receiving from AddMealViewController
////////////////////////////////////////////////////////
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? AddMealViewController, let meal = sourceViewController.meal {

            let newIndexPath = IndexPath(row: meals.count, section: 0)
            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        saveMeals()
        
    }

//////////////////////////////////////////////////////////
//    setting up table view
////////////////////////////////////////////////////////

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cellID"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MealTableViewCell else {
            fatalError("dequeued cell is not an instance of MealTableViewCell")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.photoImageView.contentMode = .scaleToFill
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
 
//////////////////////////////////////////////////////////
//    allow user to edit --> delete
////////////////////////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        saveMeals()
    }
    
//////////////////////////////////////////////////////////
//    return false if you don't want item to be editable
////////////////////////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//////////////////////////////////////////////////////////
//    SAVING MEALS
////////////////////////////////////////////////////////
    
    private func saveMeals() {
        
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try data.write(to: Meal.ArchiveURL)
        } catch {
            print("error!!!!")
        }
        
//        let ctm = CloudTrackerManager()
//        ctm.postMeal()
    }
    
//////////////////////////////////////////////////////////
//    LOADING MEALS
////////////////////////////////////////////////////////
    
    private func loadMeals()  {
        
//        let dataURL = Meal.ArchiveURL
//        guard let codedData = try? Data(contentsOf: dataURL) else { return }
//
//        print("Attempting to load meals")
//
//        meals = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Meal] ?? [Meal]()
        
        let ctm = CloudTrackerManager()
        ctm.fetchAllMeals() { (result: String) in
            
            
            print("got back: \(result)")
            self.meals = ctm.meals
            print(self.meals.count)
            self.tableView.reloadData()
            
            
        }

//        tableView.reloadData()
        
//        for meal in meals {
//            print(meal.name)
//        }
//
//        for meal in json {
//
//            let newMeal = Meal(name: meal["title"] as! String, photo: nil, rating: meal["rating"] as! Int, calories: meal["calories"] as! Int, details: meal["description"] as! String)
//
//            print("looping")
//            meals.append(newMeal!)
//            print("NUMBER OF MEALS IN YOUR ARRAY IS: \(meals.count)")
////            print(meals)
//
//            // initialize a new meal
//            // then append to meal array
//        }
        
    }

}
