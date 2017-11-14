//
//  OutingModel.swift
//  Outings
//
//  Created by Ryan Hennings on 11/9/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit // need for UIimage

class Outing {
    private var _mapImage: UIImage!
    private var _username: String!
    private var _date: String!
    private var _info: String!
    
    var mapImage: UIImage { return _mapImage }
    var username: String { return _username }
    var date: String { return _date }
    var info: String { return _info }
    
    
    init(mapImage: UIImage, username: String, date: String, info: String) {
        self._mapImage = mapImage
        self._username = username
        self._date = date
        self._info = info
    }
}
