//
//  EditDog.swift
//  Dogstagram
//
//  Created by Emily Lynam on 9/16/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation

protocol EditDog: class {
    func editDog(_ controller: EditDogViewController, didFinishEditingDog name: String, color: String, treat: String, photo: Double )
    func deleteDog(_ controller: EditDogViewController, didFinishDeletingDog atIndex: Int)
}
