import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
/*
 whenever we change our button, we should call on the method to change the state of the stars
 */
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44, height: 44) {
        didSet {
            setUpButtons() // this updates the control
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setUpButtons() // this updates the control
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpButtons()
    }
    
    private func setUpButtons() {
        
//////////////////////////////////////////////////////////
//   this removes old buttons
//////////////////////////////////////////////////////////
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
//////////////////////////////////////////////////////////
//    this sets up the new buttons
 ////////////////////////////////////////////////////////

        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
//////////////////////////////////////////////////////////
//    this decides on which star to set depending on the state
////////////////////////////////////////////////////////
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
//////////////////////////////////////////////////////////
//    called when the user taps on a button
//    if rating is still 0 then leave it at 0 else change it
////////////////////////////////////////////////////////
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("the button \(button) is not in the array")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // user has given the rating a 0
            rating = 0
            
        } else {
            rating = selectedRating
        }
    }

//////////////////////////////////////////////////////////
//    loop through array of stars
//    if newly selected is less than current rating, then change it
//    else just add a new star/s
////////////////////////////////////////////////////////

    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // if the button is less than the rating, that button should be selected
            button.isSelected = index < rating
        }
    }
}
