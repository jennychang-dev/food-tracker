import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var foodPicView: UIImageView!
    
    @IBAction func setDefaultLabelText(_ sender: Any) {
        mealNameLabel.text = "default text"
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        print("tapping")
        
        let iPC = UIImagePickerController()
        iPC.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        iPC.sourceType = .photoLibrary
        
        
        present(iPC, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hides keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = textField.text
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

