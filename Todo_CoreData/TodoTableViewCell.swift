//
//  todoTableViewCell.swift
//  Todo_CoreData
//
//  Created by lpiem2 on 03/03/2021.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var todo : Tache? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(title : String, subtitle : String, image : UIImage?){
        titleLabel.text = title
        subtitleLabel.text = subtitle
        if (image != nil){
            imageView?.image = image
        }
    }
    
    

}
