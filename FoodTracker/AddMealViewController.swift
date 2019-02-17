import UIKit
import os.log

class AddMealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var meal: Meal?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var foodPicView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
    // enable save only if the text field has a valid Meal name
        updateSaveButtonState()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        // if meal detail scene is in add meal mode
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
            
        // if user is editing an existing meal then safely unwrap the navigation controller
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
            
        // shouldn't be executed if code is written properly
        } else {
            fatalError("the AddMealViewController is not inside a navigation controller")
        }
    }
    
//////////////////////////////////////////////////////////
//    configure the destination view controller only when the save button is pressed
// in storyboard, we dragged the save button to the 'exit' button
// this links to "unwind to meal list in MealTableViewController"
////////////////////////////////////////////////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("the save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = foodPicView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
//////////////////////////////////////////////////////////
//    reverse segue - add an action to the destination view controller (the one we want to segue to)
////////////////////////////////////////////////////////
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let iPC = UIImagePickerController()
        iPC.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        iPC.sourceType = .photoLibrary
        
        
        present(iPC, animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // disable save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hides keyboard
        textField.resignFirstResponder()
        return true
    }
    
//////////////////////////////////////////////////////////
//    disable save button when text field is empty
////////////////////////////////////////////////////////
    
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("expected a dictionary containing an image, but it provided the following: \(info)")
        }
        
        foodPicView.contentMode = .scaleAspectFit
        foodPicView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    

}

