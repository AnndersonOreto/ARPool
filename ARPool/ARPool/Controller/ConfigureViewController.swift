//
//  ConfigureViewController.swift
//  ARPool
//
//  Created by Marcus Vinicius Vieira Badiale on 31/05/19.
//  Copyright © 2019 Annderson Packeiser Oreto. All rights reserved.
//

import UIKit

class ConfigureViewController: UIViewController {

    @IBOutlet weak var switchOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchOutlet.isOn = UserDefaults.standard.bool(forKey: "switchState")
    }

    @IBAction func dismissActionButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TypeOfColorSwitch(_ sender: UISwitch) {
        if sender.isOn == true{
            color = .colorBlindGame
            print("ativado")
        }else{
            color = .defaultGame
            print("desativado")
        }
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
    }
}
