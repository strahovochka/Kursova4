//
//  TextTableViewCell.swift
//  Kursova
//
//  Created by Jane Strashok on 06.12.2023.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var processed: UILabel!
    @IBOutlet weak var tokenized: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
