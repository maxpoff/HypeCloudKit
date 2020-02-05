//
//  HypeListViewController.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/4/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import UIKit

class HypeListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var hypeTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    //MARK: - Private Methods
    func setupViews() {
        hypeTableView.dataSource = self
        hypeTableView.delegate = self
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.hypeTableView.reloadData()
        }
    }
    
    func loadData() {
        HypeController.sharedInstance.FetchAllHypes { (result) in
            switch result {
            case .success(let hypes):
                HypeController.sharedInstance.hypes = hypes
                self.updateViews()
            case .failure(let error):
                print(error, error.errorDescription)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func composeButtonTapped(_ sender: Any) {
        presentAddHypeAlert()
    }
}//End of class

//MARK: - Extensions
extension HypeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HypeController.sharedInstance.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.sharedInstance.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.body
        
        cell.detailTextLabel?.text = hype.timestamp.formatToString()
        
        return cell
    }
}//End of extension

//MARK: - Alert Controller
extension HypeListViewController {
    
    func presentAddHypeAlert(for hype: Hype?) {
        let alertController = UIAlertController(title: "Hype", message: "whatever", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.delegate = self
            textfield.placeholder = "Enter here"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
        }
        
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {return}
            
            if let hype = hype {
                hype.body = text
                HypeController.sharedInstance.update(hype) { (result) in
                    self.updateViews()
                }
            }
            
            HypeController.sharedInstance.saveHype(with: text) { (result) in
                switch result {
                case .success(let hype):
                    guard let hype = hype else {return}
                    HypeController.sharedInstance.hypes.insert(hype, at: 0)
                    self.updateViews()
                    
                case .failure(let error):
                    print(error, error.errorDescription)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addHypeAction)
        
        self.present(alertController, animated: true)
    }
}

extension HypeListViewController: UITextFieldDelegate {
    
}
