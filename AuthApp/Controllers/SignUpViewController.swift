//
//  SignUpViewController.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 29.04.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var someProperty: String? = "1" {
           didSet {
               print("someProperty")
           }
       }
    
    let profileVC = ProfileViewController()
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            print("passwordTextField")
        }
    }
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        
//        registerButton.isEnabled = false
//        registerButton.alpha = 0.3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "toProfileVC":
            guard let dvc = segue.destination as? ProfileViewController else { return }
            dvc.firstname = firstnameTextField.text
            dvc.lastname = lastnameTextField.text
            dvc.image = photoImageView.image
        case "toAnotherVC":
            print("anotherVC")

        default:
            break
        }
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        
        switch segue.identifier {
        case "myUnwindSegue":
            guard let sourceVC = segue.source as? ProfileViewController else { return }
            self.firstnameTextField.text = sourceVC.firstnameTextField.text
            self.lastnameTextField.text = sourceVC.lastnameTextField.text
        case "toAnotherVC":
            print("anotherVC")
        default:
            break
        }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: nil)
    }
    
    
    @IBAction func textFieldsChanged(_ sender: Any) {
        
//        guard Validators.isFilled(firstname: firstnameTextField.text,
//                                  lastname: lastnameTextField.text,
//                                  email: emailTextField.text,
//                                  password: passwordTextField.text) else {
//                                    registerButton.isEnabled = false
//                                    registerButton.alpha = 0.3
//                                    return }
//
//        guard Validators.isSimpleEmail(emailTextField.text!) else {
//            registerButton.isEnabled = false
//            registerButton.alpha = 0.3
//            return }
//
//        registerButton.isEnabled = true
//        registerButton.alpha = 1
    }
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

