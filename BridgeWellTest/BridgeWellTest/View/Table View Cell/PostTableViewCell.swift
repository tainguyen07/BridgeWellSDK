//
//  PostTableViewCell.swift
//  BridgeWellTest
//
//  Created by Tai Nguyen on 08/01/2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configData(post: Post) {
        DispatchQueue.main.async {
            self.lblTitle.text = post.title
            self.lblBody.text = post.body
            self.lblCount.text = "Comment count: \(post.comments.count)"
        }
    }
    
}
