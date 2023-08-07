//
//  GreatingViewController.swift
//  MDSAudioBook
//
//  Created by vitali on 07.08.2023.
//

import UIKit

class GreatingViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.textColor = .white
        }
    }
    @IBOutlet weak var greatingView: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 4, animations: { () -> Void in
            self.nameLabel.frame.origin.y -= self.view.frame.height / 2 + 50

        },completion: {_ in
            self.moveMainTableVC()
        })
    }

    func moveMainTableVC(){
        performSegue(withIdentifier: "moveVC", sender: nil)
    }

}
