//
//  CenterVC.swift
//  FAPanels
//
//  Created by Fahid Attique on 17/06/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit

class CenterVC: UIViewController {
    //  MARK:- IBOutlets

    var leftAllowableEdge: UILabel?
    var centerPanelOnlyAnimDuration: UILabel?
    var leftPanelPositionSwitch: UISwitch?
    @IBOutlet var sidePanelsOpenAnimDuration: UILabel?

    //  MARK:- Class Properties
    fileprivate let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    //  MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftAllowableEdge?.text = "70"
        centerPanelOnlyAnimDuration?.text = "0.4"
        viewConfigurations()
    }

    // MARK: - Functions
    func viewConfigurations() {
        leftPanelPositionSwitch?.setOn(panel!.isLeftPanelOnFront, animated: false)

        //  Reseting the Panel Configs...
        panel!.configs = FAPanelConfigurations()
        panel!.configs.rightPanelWidth = 80
        panel!.configs.bounceOnRightPanelOpen = false
        
        panel!.delegate = self
    }

    // MARK: - IBActions
    @IBAction func showLeftVC(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
}

extension CenterVC: FAPanelStateDelegate {
    
    func centerPanelWillBecomeActive() {
        print("centerPanelWillBecomeActive called")
    }
    
    func centerPanelDidBecomeActive() {
        print("centerPanelDidBecomeActive called")
    }
    
    
    func leftPanelWillBecomeActive() {
        print("leftPanelWillBecomeActive called")
    }
    
    
    func leftPanelDidBecomeActive() {
        print("leftPanelDidBecomeActive called")
    }
    
    
    func rightPanelWillBecomeActive() {
        print("rightPanelWillBecomeActive called")
    }
    
    func rightPanelDidBecomeActive() {
        print("rightPanelDidBecomeActive called")
    }
    
}
