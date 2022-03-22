import XCTest
@testable import PhotoAlbumApp

class PhotoAlbumAppTests: XCTestCase {
    
    func testGenerateRandom() {
        //given
        let subject = ColorFactory.generateRandom(count:)
        
        //when
        let testCount = 40
        let guess = subject(testCount)
        
        //then
        XCTAssertEqual(guess.count, testCount)
    }
}
