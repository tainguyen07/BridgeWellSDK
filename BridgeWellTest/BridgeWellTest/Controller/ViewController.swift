//
//  ViewController.swift
//  BridgeWellTest
//
//  Created by Tai Nguyen on 08/01/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let sdk = BridgeWellSDK.shared
    var posts: [Post] = []
    var isLoadingData = false
    var currentPage = 1 // Initial page
    let pageSize = 10 // Adjust the page size as needed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        loadData()
    }
    func loadData() {
        guard !isLoadingData else {
            return
        }
        
        isLoadingData = true
        
        sdk.getPostWithCommentByIds(ids: Array(currentPage...(currentPage + pageSize - 1))) { [weak self] result in
            switch result {
            case .success(let newPosts):
                self?.posts += newPosts
                self?.isLoadingData = false
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
                self?.isLoadingData = false
            }
        }
    }
    
}

//MARK: -TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        cell.configData(post: posts[indexPath.row])
        return cell
    }
    // Implement infinite scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        // Check if the user has scrolled to the bottom of the content
        if offsetY > contentHeight - screenHeight {
            // Load more data only if not already loading
            guard !isLoadingData else {
                return
            }
            
            isLoadingData = true
            
            // Increment the current page index based on your pagination logic
            currentPage += 1
            
            // Fetch more data
            sdk.getPostWithCommentByIds(ids: Array(currentPage...(currentPage + pageSize - 1))) { [weak self] result in
                switch result {
                case .success(let newPosts):
                    // Append new data to the existing array
                    self?.posts += newPosts
                    self?.isLoadingData = false
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                    self?.isLoadingData = false
                }
            }
        }
    }
}
