//
//  Main.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit

class Main: UIViewController {
    
    // MARK: - props
    @IBOutlet weak var viewSnake: Snake!
    @IBOutlet weak var lblScore: UILabel!
    
    // MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSnake.scoreChanged = { [weak self] (score: Int) in
            self?.lblScore.text = String(format: "Score: %d", score)
        }
    }
}
