//
//  ImageCollectionViewController.swift
//  Dogstagram
//
//  Created by Emily Lynam on 9/15/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import UIKit; import CoreData

private let reuseIdentifier = "DogCell"

class ImageCollectionViewController: UICollectionViewController, AddDog, EditDog, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dogs = [Dog]()
    @IBOutlet var albumCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = UIColor.white
        fetchAllDogs()
        let dogImageToEdit = DogCell()
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedImage(sender:)))
        dogImageToEdit.addGestureRecognizer(tap)
        tap.delegate = self
//        print(dogs[0].photo)
//        let image = imageFromUrlString(double: 1473998392.11027)
//        print(image)
        //
//        albumCollectionView?.delegate? = self
        // if the view controller wants to know what images to use for the collection, talk to me:
//        albumCollectionView?.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
        // Register cell classes
//        self.collectionView!.register(AlbumCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    func pressedImage(sender: Any?) {
        performSegue(withIdentifier: "EditDog", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllDogs()
    }

    func addDog(_ controller: AddDogViewController, didFinishAddingDog name: String, color: String, treat: String, photo: Double) {
        _ = navigationController?.popViewController(animated: true)
        let newDog = NSEntityDescription.insertNewObject(forEntityName: "Dog", into: context) as  NSManagedObject
        do {
            newDog.setValue(name, forKey: "name")
            newDog.setValue(color, forKey: "color")
            newDog.setValue(treat, forKey: "treat")
            newDog.setValue(photo, forKey: "photo")
            try self.context.save()
            print("Success!")
        } catch {
            print("Error: \(error)")
        }
        fetchAllDogs()
        collectionView?.reloadData()
    }
    
    func editDog(_ controller: EditDogViewController, didFinishEditingDog name: String, color: String, treat: String, photo: Double) {
        dismiss(animated: true, completion: nil)
        if context.hasChanges { //doesn't have changes yet
            do {
                try context.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        fetchAllDogs()
        collectionView?.reloadData()
    }
    
    func deleteDog(_ controller: EditDogViewController, didFinishDeletingDog atIndex: Int) {
        let delDog = dogs.remove(at: atIndex)
        context.delete(delDog)
        dismiss(animated: true, completion: nil)
        fetchAllDogs()
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchAllDogs() {
        let dogRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        do {
            let results = try context.fetch(dogRequest)
            dogs = results as! [Dog]
            for dog in dogs {
                print("Dog: \(dog.name) \(dog.photo)")
            }
        } catch {
            print("\(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddDog" {
            // show segue
            let destination = segue.destination as! AddDogViewController
            destination.delegate = self
        } else {
            // modal segue
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EditDogViewController
            controller.editDelegate = self
            
            if (sender as? UIImage) != nil {
                let cell = self.collectionView?.indexPathsForSelectedItems
                controller.dogToEdit = dogs[(cell?[0][1])!]
                controller.dogToEditIndexPath = cell?[0][1]
                print(controller.dogToEditIndexPath)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dogs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DogCell
        print(dogs[indexPath.row].photo)
        let dogPath = dogs[indexPath.row].photo
        
        // defining content to display in the cell
        cell.dogImage.image = imageFromUrlString(double: dogPath)
        cell.dogNameLabel.text = dogs[indexPath.row].name?.uppercased()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditDog", sender: self)
        // need this if statement or it won't pass info in the segue:
        if let cell = self.collectionView?.cellForItem(at: indexPath) as? DogCell {
            let imageToPass = cell.dogImage.image
            performSegue(withIdentifier: "EditDog", sender: imageToPass)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 3.0
        return CGSize(width: picDimension, height: picDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 8.0
        return UIEdgeInsetsMake(20, leftRightInset, 20, leftRightInset)
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
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
