
import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    func test_MealInitializationSucceeds_WhenPassingInZeroAsRating() {
        
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        
        XCTAssertNotNil(zeroRatingMeal)
    }
    
    func test_MealInitializationSucceeds_WhenPassingInHighestAsRating() {
        
        let highestRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        
        XCTAssertNotNil(highestRatingMeal)
    }
    
    func test_MealInitializationFails_WhenPassingInNegativeAsRating() {
        
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -2)
        
        XCTAssertNil(negativeRatingMeal)
    }
    
}
