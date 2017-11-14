//
//  CustomCLLocation.swift
//  Outings
//
//  Created by Ryan Hennings on 11/13/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import Foundation
import CoreLocation

public class CustomCLLocation: CLLocation {
    var locationDesription: String = ""
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

