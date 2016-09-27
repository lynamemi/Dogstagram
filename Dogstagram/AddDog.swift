//
//  AddView.swift
//  Dogstagram
//
//  Created by Emily Lynam on 9/15/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation

protocol AddDog: class {
    func addDog(_ controller: AddDogViewController, didFinishAddingDog name: String, color: String, treat: String, photo: Double )
}
