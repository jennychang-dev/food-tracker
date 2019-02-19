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
        
        let url = URL(string: "https://i.imgur.com//DEdzdZw.png")
        let sessionTask = URLSession.shared
        let request = URLRequest(url: url!)
        let task = sessionTask.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            print("\(String(describing: responseError))")
            return
        }
            
            if let data = responseData {
                cell.photoImageView.image = UIImage(data: data)
                cell.photoImageView.contentMode = .scaleToFill
            }
        }
        
        task.resume()
        
        cell.nameLabel.text = meal.name
        
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
//    SAVING MEALS - LOCALLY
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
//    LOADING MEALS - FROM CLOUD TRACKER
////////////////////////////////////////////////////////
    
    private func loadMeals()  {
        
        let ctm = CloudTrackerManager()
        ctm.fetchAllMeals() { (result: String) in
            
            
            print("got back: \(result)")
            self.meals = ctm.meals
            print(self.meals.count)
            self.tableView.reloadData()
        }
    }
}
