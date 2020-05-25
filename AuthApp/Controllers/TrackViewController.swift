//
//  TrackViewController.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 11.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

protocol TrackMovingDelegate: class {
    func moveToPreviousTrack() -> Track?
    func moveToNextTrack() -> Track?
}

class TrackViewController: UIViewController {
    let dragDownButton = UIButton()
    let trackImageView = UIImageView()
    let slider = UISlider()
    let currentSecondsLabel = UILabel()
    let timeLeftLabel = UILabel()
    let trackNameLabel = UILabel()
    let artistNameLabel = UILabel()
    let previousTrackButton = UIButton()
    let startStopButton = UIButton()
    let nextTrackButton = UIButton()
    let volumeSlider = UISlider()
    let offVolumeImageView = UIImageView()
    let onVolumeImageView = UIImageView()
    
    let player: AVPlayer = {
        let avplayer = AVPlayer()
        avplayer.automaticallyWaitsToMinimizeStalling = false
        return avplayer
    }()
    
    weak var trackDelegate: TrackMovingDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupConstraints()
    }
    
    func set(track: Track?) {
        guard let track = track else { return }
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        playTrack(previewUrl: track.previewUrl)
        observePlayerCurrentTime()
        let string600 = track.artworkUrl60?.replacingOccurrences(of: "60x60", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - Animations
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
           UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                      let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
                 }, completion: nil)
       }
    
    func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentSecondsLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.timeLeftLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
            
            if self?.timeLeftLabel.text == "-00:00" {
                //                sleep(4)
                //                let seconds = 1.0
                guard let track = self!.trackDelegate?.moveToNextTrack() else { return }
                self!.set(track: track)
                //                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                //
                //                                   }
                
            }
        }
    }
    
    func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.slider.value = Float(percentage)
    }
}

// MARK: - Setup View
extension TrackViewController {
    
    
    func setupElements() {
        view.backgroundColor = .systemBackground
        dragDownButton.setImage(#imageLiteral(resourceName: "Drag Down"), for: .normal)
        currentSecondsLabel.text = "00:00"
        timeLeftLabel.text = "--:--"
        
        //        trackImageView.image = #imageLiteral(resourceName: "fouth")
        
        timeLeftLabel.textAlignment = .right
        trackNameLabel.textAlignment = .center
        artistNameLabel.textAlignment = .center
        
        trackNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        artistNameLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
        
        previousTrackButton.setImage(#imageLiteral(resourceName: "Left"), for: .normal)
        startStopButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        nextTrackButton.setImage(#imageLiteral(resourceName: "Right"), for: .normal)
        
        offVolumeImageView.image = #imageLiteral(resourceName: "Icon Min")
        onVolumeImageView.image = #imageLiteral(resourceName: "IconMax")
        
        //        slider.thumb
        slider.thumbTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        slider.minimumTrackTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        offVolumeImageView.contentMode = .scaleAspectFit
        onVolumeImageView.contentMode = .scaleAspectFit
        
        volumeSlider.value = 1
        
        dragDownButton.addTarget(self, action: #selector(dragDownPressed), for: .touchUpInside)
        
        startStopButton.addTarget(self, action: #selector(playStopButtonPressed), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        
        slider.addTarget(self, action: #selector(trackPositionChanged), for: .valueChanged)
        
        slider.addTarget(self, action: #selector(sliderTouchedUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchedDown), for: .touchDown)
        
        previousTrackButton.addTarget(self, action: #selector(previousTrackPressed), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(nextTrackPressed), for: .touchUpInside)
        
    }
    
    
}

// MARK: - Actions
extension TrackViewController {
    
    @objc func dragDownPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func playStopButtonPressed() {
        if player.timeControlStatus == .paused {
            player.play()
            startStopButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
            
        } else {
            player.pause()
            startStopButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
           reduceTrackImageView()
        }
    }
    
    @objc func volumeChanged() {
        player.volume = volumeSlider.value
    }
    
    @objc func sliderTouchedUp() {
        slider.thumbTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        slider.minimumTrackTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    @objc func sliderTouchedDown() {
        slider.thumbTintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        slider.minimumTrackTintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    @objc func trackPositionChanged() {
        
        
        let percentage = slider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeUnSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeUnSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
        
    }
    
    @objc func previousTrackPressed() {
        startStopButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let track = trackDelegate?.moveToPreviousTrack()
        set(track: track)
    }
    
    @objc func nextTrackPressed() {
        startStopButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let track = trackDelegate?.moveToNextTrack()
        set(track: track)
    }
}

// MARK: - Setup Constrains
extension TrackViewController {
    func setupConstraints() {
        
        
        let topImageStackView = UIStackView(arrangedSubviews: [dragDownButton, trackImageView], axis: .vertical, spacing: 16)
        
        let labelsStackView = UIStackView(arrangedSubviews: [currentSecondsLabel, timeLeftLabel], axis: .horizontal, spacing: 0)
        labelsStackView.distribution = .fillEqually
        let topSliderStackView = UIStackView(arrangedSubviews: [slider, labelsStackView], axis: .vertical, spacing: 4)
        
        let trackInfoStackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel], axis: .vertical, spacing: 4)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [previousTrackButton, startStopButton, nextTrackButton], axis: .horizontal, spacing: 0)
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .center
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let volimeStackView = UIStackView(arrangedSubviews: [offVolumeImageView, volumeSlider, onVolumeImageView], axis: .horizontal, spacing: 10)
        volimeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let topStackView = UIStackView(arrangedSubviews: [topImageStackView, topSliderStackView, trackInfoStackView], axis: .vertical, spacing: 8)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topStackView)
        view.addSubview(buttonsStackView)
        view.addSubview(volimeStackView)
        
        trackImageView.heightAnchor.constraint(equalTo: topImageStackView.widthAnchor).isActive = true
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonsStackView.bottomAnchor.constraint(equalTo: volimeStackView.topAnchor, constant: -24)
            
        ])
        
        offVolumeImageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        offVolumeImageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        onVolumeImageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        onVolumeImageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        NSLayoutConstraint.activate([
            volimeStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            volimeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            volimeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct TrackVCProvider: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                ContainerView().edgesIgnoringSafeArea(.all)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                    .previewDisplayName("iPhone 11 Pro")
                
                ContainerView().edgesIgnoringSafeArea(.all)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 7"))
                    .previewDisplayName("iPhone 7")
            }
        }
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = TrackViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TrackVCProvider.ContainerView>) -> TrackViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: TrackVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TrackVCProvider.ContainerView>) {
            
        }
    }
}
