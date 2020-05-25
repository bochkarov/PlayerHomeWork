//
//  TrackCell.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 11.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import SDWebImage

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function)
        
    }
    
    func setup(track: Track?) {
        guard let track = track else { return }
        self.trackNameLabel.text = track.trackName
        self.artistNameLabel.text = track.artistName
        self.collectionNameLabel.text = track.collectionName
        guard let url = URL(string: track.artworkUrl60 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
}
