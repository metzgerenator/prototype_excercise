import XCTest
@testable import freeza

class RedditEntryModelTest: XCTestCase {

    func testInit() {

        let title = "TEST_TITLE"
        let author = "TEST_AUTHOR"
        let creation = NSDate()
        let thumbnailURL = URL(string: "http://mysite.com/thumb.jpg")!
        let commentsCount = 200
        let isOverEignteen = true
        // self.isOverEignteen = dictionary["over_18"] as? Bool
        let dictionary: [String: AnyObject] = [
            "title": title as AnyObject,
            "author": author as AnyObject,
            "created_utc": creation.timeIntervalSince1970 as AnyObject,
            "thumbnail": thumbnailURL.absoluteString as AnyObject,
            "num_comments": commentsCount as AnyObject,
            "over_18" : isOverEignteen as AnyObject
        ]
        
        let entryModel = EntryModel(withDictionary: dictionary)
        
        XCTAssertEqual(entryModel.title, title)
        XCTAssertEqual(entryModel.author, author)
        XCTAssertEqual(entryModel.creation?.timeIntervalSince1970, creation.timeIntervalSince1970)
        XCTAssertEqual(entryModel.thumbnailURL, thumbnailURL)
        XCTAssertEqual(entryModel.commentsCount, commentsCount)
        XCTAssertEqual(entryModel.isOverEignteen, isOverEignteen)
    }
    
    func testInitWithNils() {
        
        let dictionary = [String: AnyObject]()
        let entryModel = EntryModel(withDictionary: dictionary)
        
        XCTAssertNil(entryModel.title)
        XCTAssertNil(entryModel.author)
        XCTAssertNil(entryModel.creation)
        XCTAssertNil(entryModel.thumbnailURL)
        XCTAssertNil(entryModel.commentsCount)
         XCTAssertNil(entryModel.isOverEignteen)
    }
}
