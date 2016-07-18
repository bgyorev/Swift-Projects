//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Bozhidar Gyorev on 7/6/16.
//  Copyright © 2016 GlaxoSmithKline. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = pokemon.name
        var image = UIImage(named: "\(pokemon.pokedexID)")
        mainImage.image = image
        currentEvoImage.image = image
        
        pokemon.downloadPokemonDetails {
            //this will be called after download is done
            
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.defenseLabel.text = self.pokemon.defense
        self.attackLabel.text = self.pokemon.attack
        self.heightLabel.text = self.pokemon.height
        self.weightLabel.text = self.pokemon.weight
        self.typeLabel.text = self.pokemon.type
        self.descriptionLabel.text = self.pokemon.description
        self.pokedexLabel.text = "\(self.pokemon.pokedexID)"
        
        if self.pokemon.nextEvolutionID == "" {
            self.evolutionLabel.text = "No Evolutions"
            nextEvoImage.hidden = true
        } else {
            nextEvoImage.hidden = false
            nextEvoImage.image = UIImage(named: self.pokemon.nextEvolutionID)
            var str = "Next Evolution: \(self.pokemon.nextEvolutionText)"
            
            if self.pokemon.nextEvolutionLVL != "" {
                str += " - LVL \(self.pokemon.nextEvolutionLVL)"
            }
            
            self.evolutionLabel.text = str
        }
        
        
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
