//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Joshua Kuehn on 12/14/15.
//  Copyright © 2015 Kuehn LLC. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    
    //This method allows the presenting VC to remain in view below the modally presented controller
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}