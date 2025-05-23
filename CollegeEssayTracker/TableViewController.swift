//
//  TableViewController.swift
//  CollegeEssayTracker
//
//  Created by HPro2 on 10/16/24.
//

import UIKit

class TableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var schools: [School] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        loadCoreData()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schools.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "School", for: indexPath) as! TableViewCell
        let school = schools[indexPath.row]
        cell.nameLabel.text = school.name
        cell.daysLabel.text = "Days Left: \(numberOfDays(from: Date(), to: school.deadline!))"
        for i in 0..<school.essays {
            let checkbox = UIButton(frame: CGRect(x: 50*Int(i), y: 0, width: 30, height: 30))
            //checkbox.backgroundColor = .gray
            checkbox.setImage(UIImage(named: "unchecked"), for: .normal)
            checkbox.setImage(UIImage(named: "checked"), for: .selected)
            checkbox.addTarget(self, action: #selector(toggleCheckboxSelection), for: .touchUpInside)
            cell.stackView.addSubview(checkbox)
        }
        return cell
    }
    
    @objc func toggleCheckboxSelection(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
            let selectedSchool = schools[indexPath.row]
            viewController.title = "Edit College"
            viewController.buttonTitle = "Save Changes"
            viewController.editSchool = selectedSchool
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSchool(indexPath: indexPath)
        }
    }
    

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
    
    func loadCoreData() {
        do {
            schools = try context.fetch(School.fetchRequest())
        } catch {
            print("Data not found")
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (action, view, completionHandler) in
            self?.deleteSchool(indexPath: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func numberOfDays(from: Date, to: Date) -> Int {
        let diffInDays = Calendar.current.dateComponents([.day], from: from, to: to).day!
        return diffInDays
    }
    
    func deleteSchool(indexPath: IndexPath) {
        let school = schools[indexPath.row]
        schools.remove(at: indexPath.row)
        context.delete(school)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
