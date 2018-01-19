//
//  ViewController.swift
//  MemeMeDraft3
//
//  Created by ALCALY LO on 12/27/17.
//  Copyright © 2017 ALCALY LO. All rights reserved.
//  Users/alcalylo/Desktop/myApps/MemeMeDraft3/MemeMeDraft3/ViewController.swift

import UIKit

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // Define Properties
    
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var Share: UIBarButtonItem!
    @IBOutlet weak var Cancel: UIBarButtonItem!
    
    
    // Configure TextFields and Buttons
    
    func configureTextFieldsAndButtons(show: Bool) {
        
        if show == true {
            topTextField.isHidden = false
            bottomTextField.isHidden = false
            Share.isEnabled = true
            Cancel.isEnabled = true
        }
    }
    
    
    //Configure Toobars
    
    func configureToolbars(show: Bool) {
        
        if show == true {
            topToolbar.isHidden = false
            bottomToolbar.isHidden = false
        }
        else {
            topToolbar.isHidden = true
            bottomToolbar.isHidden = true
        }
    }
    
    
    // Define TextField Delegates
    
    let upperTextField = TextFieldDelegate()
    let lowerTextField = TextFieldDelegate()
    
    
    // Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        imageView.contentMode = .scaleAspectFit
        topTextField.contentMode = .scaleAspectFit
        bottomTextField.contentMode = .scaleAspectFit
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields(textField: topTextField, withText: "")
        configureTextFields(textField: bottomTextField, withText: "")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    
    // Configure the Text Fields
    
    func configureTextFields(textField: UITextField, withText text: String) {
        
        
        // Set TextField Delegate
        
        topTextField.delegate = upperTextField
        bottomTextField.delegate = lowerTextField
        
        
        // Set Meme Styles
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
        
    }
    
    
    // Pick an Image
    
    func pickAnImage(source : UIImagePickerControllerSourceType) {
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    //Pick An Image From Album
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        pickAnImage(source: .photoLibrary)
        
    }
    
    
    //Pick An Image From Camera
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pickAnImage(source: .camera)
    }
    
    
    //Present An Image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // Dismiss View
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Keyboard Setup And Notifications
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // Generate a MemedImage
    
    func generateMemedImage() -> UIImage {
        
        configureToolbars(show: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureToolbars(show: true)
        
        return memedImage
    }
    
    
    // Save the meme
    
            // Create the meme
    
    func save(memedImage: UIImage) {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, memeOriginal: imageView.image!, memedImage: generateMemedImage())
    
        // Add it to the memes array in the Application Delegate
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        let tabBarController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        present(tabBarController, animated: true, completion: nil)
        
    }
    
    
    // Instantiate Activity View Controller
    
    @IBAction func shareAnImageController (_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            activity, completed, returned, error in
            if completed {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)
        
        

    }
    
    
    // Cancel the Meme
    
    @IBAction func cancelMeme(_ sender: Any) {
        
        topTextField.text = ""
        bottomTextField.text = ""
        
    }
    
}

