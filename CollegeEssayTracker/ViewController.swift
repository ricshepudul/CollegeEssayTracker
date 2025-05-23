//
//  ViewController.swift
//  CollegeEssayTracker
//
//  Created by HPro2 on 10/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var editSchool: School!
    var deadline = Date()
    var name = ""
    var essays = 0
    var buttonTitle = "Add College"

    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var essaysLabel: UILabel!
    @IBAction func stepper(_ sender: UIStepper) {
        essays = Int(sender.value)
        essaysLabel.text = "Number of essays: " + String(essays)
    }
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        updateSchool()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        deadlineTextField.text = formatter.string(from: date)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 100)
        deadlineTextField.inputView = datePicker
        
    }
    
    @objc func toggleCheckboxSelection(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        deadlineTextField.text = formatter.string(from: sender.date)
        deadline = sender.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.setTitle(buttonTitle, for: .normal)
        if buttonTitle ==  "Save Changes" {
            nameTextField.text = editSchool.name
            essays = Int(editSchool.essays)
            stepper.value = Double(essays)
            essaysLabel.text = "Number of essays: " + String(essays)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            deadlineTextField.text = formatter.string(from: deadline)
            deadline = editSchool.deadline!
        }
    }


    func updateSchool() {
        if let name = nameTextField.text {
            if name != "" {
                if buttonTitle == "Add College" {
                    let school = School(context: context)
                    school.name = name
                    school.deadline = deadline
                    school.essays = Int64(essays)
                } else {
                    editSchool.name = name
                    editSchool.deadline = deadline
                    editSchool.essays = Int64(essays)
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                navigationController!.popViewController(animated: true)
            }
        }
    }

}
