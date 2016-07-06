//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bozhidar Gyorev on 7/6/16.
//  Copyright © 2016 GlaxoSmithKline. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }
}