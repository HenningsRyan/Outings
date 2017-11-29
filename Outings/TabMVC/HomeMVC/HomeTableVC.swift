//
//  HomeTableVC.swift
//  Outings
//
//  Created by Ryan Hennings on 11/8/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit

class HomeTableVC: UITableViewController {

    var outings = [Outing]()
    
    var titlePassValue: String = ""
    var usernamePasssValue: String = ""
    var dataPassValue: String = ""
    var durationPassValue: String = ""
    var distancePassValue: String = ""
    var stepsPassValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
        
        setUpNavigationBarItems()
        
//        DataService.dataStorage.REF_OUTINGS.document("cFI9SIJpijocYqYiSjP9").addSnapshotListener { (documentSnapshot, error) in
//            guard let document = documentSnapshot else {
//                print("RYAN: Error fetching document: \(error!)")
//                return
//            }
//            print("RYAN: Current data: \(document.data())")
//        }
        
        DataService.dataStorage.REF_OUTINGS.addSnapshotListener { (query, error) in
            guard let documents = query?.documents else {
                print("RYAN: Error fetching documents: \(error!)")
                return
            }
            
            for document in documents {
                print("RYAN: \(document.documentID) => \(document.data())")
            }
        }
        
        // Print all document data in a collection
//        DataService.dataStorage.REF_OUTINGS.getDocuments { (querySnapshot, error) in
//            if let err = err {
//                print("RYAN: Error getting documents: \(error)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("RYAN: \(document.documentID) => \(document.data())")
//                }
//            }
//        }
 
 
        
        // Hard Coded data for demonstration
        self.tableView.backgroundColor = UIColor(hexString: "1AA1D1")
        tableView.separatorStyle = .none
        let o1 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Ryan Hennings", date: "11/21/17", info: "Mission Peak Hike!")
        let o2 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Sarah Hoover", date: "11/27/17", info: "Campbell Bar Crawl")
        let o3 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "John Daily", date: "11/29/17", info: "Neighborhood Walk")
        let o4 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Hayley McCollins", date: "12/02/17", info: "SF Parade")
        let o5 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Amanda Hugenkiss", date: "12/10/17", info: "Coffee Crawl")
        let o6 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Wayne Kerr", date: "12/13/17", info: "Mt. Everest Hike")
        let o7 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Matt Stonie", date: "01/08/18", info: "El Toro Night Walk")
        let o8 = Outing(mapImage: #imageLiteral(resourceName: "backImage"), username: "Taylor Renae", date: "01/21/18", info: "SJSU Lap")

        outings.append(o1)
        outings.append(o2)
        outings.append(o3)
        outings.append(o4)
        outings.append(o5)
        outings.append(o6)
        outings.append(o7)
        outings.append(o8)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let passValue = segue.destination as! OutingDetailTVC
        
        passValue.titleName = titlePassValue
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let outing = outings[indexPath.row]
        let outing = outings[indexPath.row]
        
        titlePassValue = outing.info
        usernamePasssValue = outing.username
        
        performSegue(withIdentifier: "toOutingDetail", sender: outings[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return outings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as? HomeViewCell {
            // Card/Cell Formatting
            cell.contentView.backgroundColor = UIColor(hexString: "1AA1D1")
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 120))
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 10.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.2
            whiteRoundedView.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 0.5])
            whiteRoundedView.layer.borderWidth = 1
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            // End Formatting
            
            let outing = outings[indexPath.row]
            
            cell.updateUI(outing: outing)
            
            return cell
        }
        // Outings Cast Failed
        else {
            return UITableViewCell()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpNavigationBarItems() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        let userIconButton = UIButton(type: .system)
        userIconButton.setImage(#imageLiteral(resourceName: "userExpand"), for: .normal)
        userIconButton.tintColor = UIColor.white
        //        userIconButton.tintColor = UIColor(red: 26, green: 161, blue: 209, alpha: 1)
        userIconButton.frame = CGRect(x: 0, y: 0, width: constants.iconSize, height: constants.iconSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userIconButton)
        userIconButton.addTarget(self, action: #selector(self.profilePressed), for: .touchUpInside)
        
        let mapAddButton = UIButton(type: .system)
        
        mapAddButton.setImage(#imageLiteral(resourceName: "locationLine"), for: .normal)
        mapAddButton.tintColor = UIColor.white
        mapAddButton.frame = CGRect(x: 0, y: 0, width: constants.iconSize, height: constants.iconSize)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mapAddButton)
        
        mapAddButton.addTarget(self, action: #selector(self.mapPressed), for: .touchUpInside)
        
        // Back Button Navigation (from next page)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @objc func mapPressed(sender: UIButton!) {
        self.hidesBottomBarWhenPushed = true
        self.performSegue(withIdentifier: "toNewOuting", sender: nil)
    }
    
    @objc func profilePressed() {
        self.hidesBottomBarWhenPushed = true
        self.performSegue(withIdentifier: "toProfile", sender: nil)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
