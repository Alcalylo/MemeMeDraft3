//
//  ViewController.swift
//  MemeMeDraft3
//
//  Created by ALCALY LO on 12/27/17.
//  Copyright © 2017 ALCALY LO. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    // Define prope/Users/alcalylo/Desktop/myApps/MemeMeDraft3/MemeMeDraft3/ViewController.swiftrties
    
    @IBOutlet weak var Camera: UIBarButtonItem!
    @IBOutlet weak var Album: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var Share: UIBarButtonItem!

    
    
    struct Meme {
        var topText : String
        var bottomText : String
        var memeOriginal : UIImage
        var memedImage : UIImage
        
        init (topText: String, bottomText: String, memeOriginal: UIImage, memedImage: UIImage) {
            
            self.topText = topText
            self.bottomText = bottomText
            self.memeOriginal = memeOriginal
            self.memedImage = memedImage
        }
    }
    
    // Define TextField Delegates
    
    let textField1 = TextFieldDelegate()
    let textField2 = TextFieldDelegate()
    
    
    // Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        imageView.contentMode = .scaleAspectFit
        Camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        Share.isEnabled = false
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // Set TextField Delegate
    
    self.topTextField.delegate = textField1
    self.bottomTextField.delegate = textField2
    
    topTextField.text = ""
    bottomTextField.text = ""
        
        // Set Meme Styles
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.white,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        
    
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //Pick An Image From Album
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        Share.isEnabled = true
        topToolbar.isHidden = false
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //Pick An Image From Camera
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        Share.isEnabled = true
        topToolbar.isHidden = false
    }
    
    
    //Present An Image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.contentMode = .scaleAspectFit
            topTextField.contentMode = .scaleAspectFit
            bottomTextField.contentMode = .scaleAspectFit
            
            imageView.image = image
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            topTextField.textAlignment = NSTextAlignment.center
            bottomTextField.textAlignment = NSTextAlignment.center
           topToolbar.isHidden = false
            Share.isEnabled = true
        
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss View
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
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
        
        self.bottomToolbar.isHidden = true
        self.topToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    
    // Save the meme

    func save(memedImage: UIImage) {
                let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, memeOriginal: imageView.image!, memedImage: generateMemedImage())
    }
    
    
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
    


}

