//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Macbook on 01/07/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var likeBond: Bond<[PFUser]?>!
    
    var post: Post? {
        didSet{
            // free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != post {
                // 2
                likeBond.unbindAll()
                postImageView.designatedBond.unbindAll()
                // 3
                if (oldValue.image.bonds.count == 0) {
                    oldValue.image.value = nil
                }
            }
            
            if let post = post {
                // bind the image of the post to the 'postImage' view
                post.image ->> postImageView
                
                // bind the likeBond that we defined earlier, to update like label and button when likes change
                post.likes ->> likeBond
            }
        }
    }
    
    func stringFromUserList(userList: [PFUser]) -> String {

        let usernameList           = userList.map { user in user.username! }
        let commaSeparatedUserList = ", ".join(usernameList)
        
        return commaSeparatedUserList
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
            
            if let likeList = likeList {
                
                self.likesLabel.text           = self.stringFromUserList(likeList)
                self.likeButton.selected       = contains(likeList, PFUser.currentUser()!)
                self.likesIconImageView.hidden = (likeList.count == 0)
            } else {
                // if there is no list of users that like this post, reset everything
                self.likesLabel.text           = ""
                self.likeButton.selected       = false
                self.likesIconImageView.hidden = true
            }
        }
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
    }

    @IBAction func likeButtonPressed(sender: AnyObject) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PFObject : Equatable {
    
}

public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}




















