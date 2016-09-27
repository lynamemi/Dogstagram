//
//  AddDogViewController.swift
//  Dogstagram
//
//  Created by Emily Lynam on 9/15/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import UIKit; import Foundation; import CoreData

class AddDogViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: AddDog?
    var dogs = [Dog]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var addDogName: UITextField!
    @IBOutlet weak var addDogColor: UITextField!
    @IBOutlet weak var addDogTreat: UITextField!
    @IBAction func addDogPressed(_ sender: UIButton) {
        let name = addDogName.text!
        let color = addDogColor.text!
        let treat = addDogTreat.text!
        if (currentImageDate != nil) {
            let photo = self.currentImageDate!
            delegate?.addDog(self, didFinishAddingDog: name, color: color, treat: treat, photo: photo)
        } else {
            let photo = 0.1
            delegate?.addDog(self, didFinishAddingDog: name, color: color, treat: treat, photo: photo)
        }
    }
    
    @IBOutlet weak var addPhotoImagePressed: UIImageView!
    var currentImageDate: Double?
    override func viewDidLoad() {
        fetchAllDogs()
        super.viewDidLoad()
        let dogImage = addPhotoImagePressed
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedLabel(sender:)))
        dogImage?.addGestureRecognizer(tap)
        tap.delegate = self
        
        // saving the default image to docs in so that the user can use it
        let data = UIImagePNGRepresentation((dogImage?.image)!)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = "\(paths[0])/\(0.1 as Double).png"
        let url = URL(fileURLWithPath: path)
        do {
            try data?.write(to: url, options: .atomicWrite)
        } catch {
            print("\(error)")
        }
        print(path)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            addPhotoImagePressed.image = pickedImage
        } else {
            print("doesn't like image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func fetchAllDogs() {
        do {
            try context.fetch(Dog.fetchRequest())
//            let dogs = results as! [Dog]
        } catch {
            print("\(error)")
        }
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
