//
//  CMTime + Extension.swift
//  AuthApp
//
//  Created by Bochkarov Valentyn on 18/05/2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
            guard !CMTimeGetSeconds(self).isNaN else { return "" }
            let totalSecond = Int(CMTimeGetSeconds(self))
            let seconds = totalSecond % 60
            let minutes = totalSecond / 60
            let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
            return timeFormatString
        }
}
