//
//  AddScheduleTableViewController.swift
//  W13
//
//  Created by SWUCOMPUTER on 2018. 5. 29..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AddScheduleTableViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var textCountry: UITextField!
    @IBOutlet var textStartDate: UILabel!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var textEndDate: UILabel!
    
    var country: String?
    var startDate: Date?
    var endDate: Date?
    var datePickerHidden = true
    var startDatePickerHidden = true
    var endDatePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        textCountry.delegate = self
        textCountry.becomeFirstResponder()
        valueChanged(startDatePicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueChanged(_ sender: UIDatePicker!) {
        
        let startDateFormatter = DateFormatter()
        let endDateFormatter = DateFormatter()
        
        startDate = startDatePicker.date
        endDate = endDatePicker.date
        
        //Check if startDatePicker and endDatePicker is same day
        let sameDay = Calendar.current.isDate(startDate!, inSameDayAs: endDate!)

        if sameDay == true {
            endDateFormatter.dateFormat = "h시 mm분 a"
        } else {
            endDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        }
        
        // Check if end date is earlier than start date
        let compareDate = startDate!.compare(endDate!)
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: endDateFormatter.string(from: endDate!))
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        textStartDate.text = startDateFormatter.string(from: startDate!)
        if compareDate == .orderedDescending {
            textEndDate.attributedText = attributeString
        } else {
            textEndDate.text = endDateFormatter.string(from: endDate!)
        }
    }
        

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
                cell.selectedBackgroundView?.alpha = CGFloat(0)
            },completion: nil)
        }
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 {
            startDatePickerHidden = !startDatePickerHidden
            if !endDatePickerHidden {
                endDatePickerHidden = true
            }
        } else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 3 {
            endDatePickerHidden = !endDatePickerHidden
            if !startDatePickerHidden {
                startDatePickerHidden = true
            }
        }
        
        toggleDatepicker()
    }
    
    func toggleDatepicker() {
        
        if !self.startDatePickerHidden {
            self.textStartDate.textColor = UIColor.red
            self.textCountry.resignFirstResponder()
        } else {
            self.textStartDate.textColor = UIColor.black
        }
        
        if !self.endDatePickerHidden {
            self.textEndDate.textColor = UIColor.red
            self.textCountry.resignFirstResponder()
        } else {
            self.textEndDate.textColor = UIColor.black
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveEvent" {
            country = textCountry.text
            startDate = startDatePicker.date
            endDate = endDatePicker.date
        }
    }
    */

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

}
