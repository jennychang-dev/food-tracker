import UIKit
import os_object

class MealTableViewController: UITableViewController {

    var meals = [Meal]()
    var meal: Meal!
    var data: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // goes into editing mode on its own!!
        navigationItem.leftBarButtonItem = editButtonItem
        
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
//    loading default
////////////////////////////////////////////////////////
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese salad", photo: photo1, rating: 4) else {
            fatalError("unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and potatoes", photo: photo2, rating: 5) else {
            fatalError("unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with meatballs", photo: photo3, rating: 3) else {
            fatalError("unable to instantiate meal3")
        }
        
        meals.append(contentsOf: [meal1, meal2, meal3])
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
    }
    
//////////////////////////////////////////////////////////
//    LOADING MEALS
////////////////////////////////////////////////////////
    
    private func loadMeals()  {
        
        let dataURL = Meal.ArchiveURL
        guard let codedData = try? Data(contentsOf: dataURL) else { return }
        
        meals = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Meal] ?? [Meal]()
        
    }

}
