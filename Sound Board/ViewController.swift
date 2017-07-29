//
//  ViewController.swift
//  Sound Board
//
//  Created by Trent Stevens on 29/07/17.
//  Copyright © 2017 Trent Stevens. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var soundTableView: UITableView!
    
    var sounds : [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundTableView.delegate = self
        soundTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
        try sounds = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(Sound.fetchRequest())
        } catch{}
        soundTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }

}

