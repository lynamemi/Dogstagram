//
//  EditDogViewController.swift
//  Dogstagram
//
//  Created by Emily Lynam on 9/16/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import UIKit; import Foundation; import CoreData

class EditDogViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate {

    var editDelegate: EditDog?
    var dogToEdit: Dog?
    var dogToEditIndexPath: Int?
    var currentImageDate: Double?
    @IBOutlet weak var changePhotoPressed: UIImageView!
    @IBOutlet weak var dogTreatText: UITextField!
    @IBOutlet weak var dogColorText: UITextField!
    @IBOutlet weak var dogNameText: UITextField!
    @IBOutlet weak var dogPhotoView: UIImageView!
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        editDelegate?.deleteDog(self, didFinishDeletingDog: dogToEditIndexPath!)

    
    }
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        dogToEdit?.name = dogNameText.text!
        dogToEdit?.color = dogColorText.text!
        dogToEdit?.treat = dogTreatText.text!
        if (currentImageDate != nil) {
            dogToEdit?.photo = self.currentImageDate!
        } else {
            dogToEdit?.photo = (dogToEdit?.photo)!
        }
        editDelegate?.editDog(self, didFinishEditingDog: (dogToEdit?.name)!, color: (dogToEdit?.color)!, treat:  (dogToEdit?.treat)!, photo: (dogToEdit?.photo)!)
    }
    
    @IBAction func cancelButtonnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dogToEditIndexPath)
        dogNameText.text = dogToEdit?.name
        dogColorText.text = dogToEdit?.color
        dogTreatText.text = dogToEdit?.treat
        dogPhotoView.image = imageFromUrlString(double: (dogToEdit?.photo)!)
        
        let dogImage = changePhotoPressed
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedLabel(sender:)))
        dogImage?.addGestureRecognizer(tap)
        tap.delegate = self
        
        print(dogToEdit?.color)
        print(dogToEdit?.photo)
        // Do any additional setup after loading the view.
    }

    func pressedLabel(sender: Any?) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains the original image that was selected in the picker, and the edited version of that image, if one exists:
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentImageDate = NSDate().timeIntervalSince1970
            let data = UIImagePNGRepresentation(pickedImage)
            // saving the picture to documents
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = "\(paths[0])/\(currentImageDate! as Double).png"
            let url = URL(fileURLWithPath: path)
            do {
                try data?.write(to: url, options: .atomicWrite)
            } catch {
                print("\(error)")
            }
            print(currentImageDate)
            print(path)
            // set the selected image in the image view outlet that you created earlier:
            changePhotoPressed.image = pickedImage
        } else {
            print("doesn't like image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageFromUrlString(double: Double) -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0].appending("/"+String(double)+".png")
        print(path)
        //        let url = NSURL(string: path)
        if let data = NSData(contentsOfFile: path) {
            let image = UIImage(data: data as Data)
            return image
        }
        print("couldn't find image")
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
