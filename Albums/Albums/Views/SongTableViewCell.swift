//
//  SongTableViewCell.swift
//  Albums
//
//  Created by Carlos E. Alvarez-Berrios on 4/18/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addSong(_ sender: Any) {
    }
}
