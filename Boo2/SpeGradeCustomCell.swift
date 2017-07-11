//
//  SpeGradeCustomCell.swift
//  Boo2
//
//  Created by pmkjkr on 2017. 7. 8..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class SpeGradeCustomCell: UITableViewCell {

    
    @IBOutlet var lectureName: UILabel!
    @IBOutlet var lectureGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
