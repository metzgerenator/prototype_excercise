import Foundation
import UIKit

class TopEntriesViewController: UITableViewController {

    static let showImageSegueIdentifier = "showImageSegue"
    let viewModel = TopEntriesViewModel(withClient: RedditClient())
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let errorLabel = UILabel()
    let tableFooterView = UIView()
    let moreButton = UIButton(type: .system)
    var urlToDisplay: URL?
    
    @IBOutlet var leftBarItem: UIBarButtonItem!
    private var saveToDisDelegate: SaveToDisDelegate?

    @IBOutlet var filterEighteenSwitch: UISwitch!
    
    @IBOutlet var favAndTopSegmentedControl: UISegmentedControl!
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
        
    }
    
   
    
    
    @IBAction func filterEighteenAction(_ sender: UISwitch) {
        filterEighteenSwitch.isOn = sender.isOn
        switch sender.isOn {
        case true:
            leftBarItem.title = "SAFE"
        case false:
            leftBarItem.title = "NSFW"
        }
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureViews()
        self.loadEntries()
        
        saveToDisDelegate = self
        
        
        
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { [weak self] (context) in
            
            self?.configureErrorLabelFrame()
            
            }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == TopEntriesViewController.showImageSegueIdentifier {
            
            if let urlViewController = segue.destination as? URLViewController {
                
                urlViewController.url = self.urlToDisplay
            }
        }
    }

    @objc func retryFromErrorToolbar() {
        
        self.loadEntries()
        self.dismissErrorToolbar()
    }
    
    @objc func dismissErrorToolbar() {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func moreButtonTapped() {
        
        self.moreButton.isEnabled = false
        self.loadEntries()
    }
    
    private func loadEntries() {

        self.activityIndicatorView.startAnimating()
        self.viewModel.loadEntries {
            
            self.entriesReloaded()
        }
    }
    
    private func configureViews() {

        func configureNavigationBar() {

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicatorView)
        }

        func configureTableView() {
            
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 110.0

            self.tableFooterView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)
            self.tableFooterView.addSubview(self.moreButton)
            
            self.moreButton.frame = self.tableFooterView.bounds
            self.moreButton.setTitle("More...", for: [])
            self.moreButton.setTitle("Loading...", for: .disabled)
            self.moreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.moreButton.addTarget(self, action: #selector(TopEntriesViewController.moreButtonTapped), for: .touchUpInside)
        }
        
        func configureToolbar() {

            self.configureErrorLabelFrame()

            let errorItem = UIBarButtonItem(customView: self.errorLabel)
            let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let retryItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(TopEntriesViewController.retryFromErrorToolbar))
            let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let closeItem = UIBarButtonItem(image: UIImage(named: "close-button"), style: .plain, target: self, action: #selector(TopEntriesViewController.dismissErrorToolbar))
            
            fixedSpaceItem.width = 12
            
            self.toolbarItems = [errorItem, flexSpaceItem, retryItem, fixedSpaceItem, closeItem]
        }
        
        configureNavigationBar()
        configureTableView()
        configureToolbar()
    }
    
    private func configureErrorLabelFrame() {
        
        self.errorLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 92, height: 22)
    }
    
    private func entriesReloaded() {
        
        self.activityIndicatorView.stopAnimating()
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = self.tableFooterView
        self.moreButton.isEnabled = true
        
        if self.viewModel.hasError {

            self.errorLabel.text = self.viewModel.errorMessage
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
}

extension TopEntriesViewController { // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.returnCorrectArrayfromModel().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entryTableViewCell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.cellId, for: indexPath as IndexPath) as! EntryTableViewCell
        let entry = self.returnCorrectArrayfromModel()[indexPath.row]
        entryTableViewCell.entry = entry
        
        if (self.viewModel.favoriteEntries.contains{$0.title == entry.title}) {
            entryTableViewCell.addToFavoritesButton.setTitle("⭐️", for: .normal)
        } else {
            entryTableViewCell.addToFavoritesButton.setTitle("➕", for: .normal)
        }
        entryTableViewCell.delegate = self
        
        return entryTableViewCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.returnCorrectArrayfromModel()[indexPath.row]
        
        if let url = entry.url {
            self.presentImage(withURL: url)
        }
    }
    
    
    //MARK: return filtered vs unfiltered array.  Also checking for Favorite Entries 
    private func returnCorrectArrayfromModel() -> [EntryViewModel] {

        switch (filterEighteenSwitch.isOn, favAndTopSegmentedControl.selectedSegmentIndex == 1 ) {
        case (true, true):
            return self.viewModel.favoriteEntries.filter{$0.isover18 != true}
        case (true, false):
            return self.viewModel.filteredEntries
        case(false, true):
            return self.viewModel.favoriteEntries
        case(false, false):
            return self.viewModel.entries
        }
        
    }
    
    
}

//MARK: add and remove from memeory
extension TopEntriesViewController: EntryTableViewCellDelegate, SaveToDisDelegate {
    func entrySelectedforFavorite(entry: EntryViewModel) {
        let isAlreadySelected = self.viewModel.favoriteEntries.contains{$0.title == entry.title}
        switch isAlreadySelected {
        case true:
            self.viewModel.favoriteEntries = self.viewModel.favoriteEntries.filter{$0.title != entry.title}
            
        case false:
            self.viewModel.favoriteEntries.append(entry)
        }
        saveToDisDelegate?.saveStringArraytoUserDefaults(array: self.viewModel.favoriteEntries.map{$0.title})
        self.tableView.reloadData()
        
        
    }
    
    func presentImage(withURL url: URL) {
        
        self.urlToDisplay = url
        self.performSegue(withIdentifier: TopEntriesViewController.showImageSegueIdentifier, sender: self)
    }
    
    
}
