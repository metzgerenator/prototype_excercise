import Foundation

class TopEntriesViewModel {
    
    var hasError = false
    var errorMessage: String? = nil
    var entries = [EntryViewModel]()
    var filteredEntries = [EntryViewModel]()
    var favoriteEntries = [EntryViewModel]()

    private let client: Client
    private var afterTag: String? = nil
    
    private var retriveFromDiskDataSource: RetriveFromDiskDataSource?

    init(withClient client: Client) {
        
        self.client = client
        self.retriveFromDiskDataSource = self
    }
    
    func loadEntries(withCompletion completionHandler: @escaping () -> ()) {
        
        self.client.fetchTop(after: self.afterTag, completionHandler: { [weak self] responseDictionary in
            
                guard let strongSelf = self else {
                    
                    return
                }
            
                guard let data = responseDictionary["data"] as? [String: AnyObject],
                    let children = data["children"] as? [[String:AnyObject]] else {
                    
                    strongSelf.hasError = true
                    strongSelf.errorMessage = "Invalid responseDictionary."
                        
                    return
                }
            
                strongSelf.afterTag = data["after"] as? String
            
                let newEntries = children.map { dictionary -> EntryViewModel in

                    // Empty [String: AnyObject] dataDictionary will result in a non-nill EntryViewModel
                    // with hasErrors set to true.
                    let dataDictionary = dictionary["data"] as? [String: AnyObject] ?? [String: AnyObject]()
                    
                    let entryModel = EntryModel(withDictionary: dataDictionary)
                    let entryViewModel = EntryViewModel(withModel: entryModel)
                    
                    return entryViewModel
                }
            
            
            //MARK: appending to filtered entries here
            
            let newEntriesFiltered = newEntries.filter{$0.isover18 != true}
            strongSelf.filteredEntries.append(contentsOf: newEntriesFiltered)
            strongSelf.entries.append(contentsOf: newEntries)
            //MARK: loading saved posts
            self?.loadSavedPosts()
                strongSelf.hasError = false
                strongSelf.errorMessage = nil

            DispatchQueue.main.async() {
                    
                    completionHandler()
                }
            
            }, errorHandler: { [weak self] message in
                
                guard let strongSelf = self else {
                    
                    return
                }

                strongSelf.hasError = true
                strongSelf.errorMessage = message
                
                DispatchQueue.main.async() {
                    
                    completionHandler()
                }
        })
    }
}



extension TopEntriesViewModel: RetriveFromDiskDataSource {
    
    private func loadSavedPosts() {
        guard let savedTitles = retriveFromDiskDataSource?.retriveTitlesFromDefaults() else {return}
        for savedTitle in savedTitles {
            self.favoriteEntries = self.favoriteEntries + self.entries.filter{$0.title == savedTitle}
        }
        
    }
    
    
    
}




