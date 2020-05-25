//
//  ProfileViewController.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 29.04.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var firstname: String?
    var lastname: String?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstnameTextField.text = firstname
        lastnameTextField.text = lastname
        photoImageView.image = image
    }
    
    @IBAction func changeInfoTapped(_ sender: Any) {
        performSegue(withIdentifier: "myUnwindSegue", sender: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = photoImageView.image else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                print("Успешно!")
            } else {
                ///.....что-то другое, ошибка
            }
        }
        
        shareController.popoverPresentationController?.sourceView = sender
        present(shareController, animated: true)
        
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
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
        
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) -> MainTabBarController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: ProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) {
            
        }
    }
}
