//
//  WidgetStopCell.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/17/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class WidgetStopCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var favoriteStops: [Stop] = []
    var widgetStopType: WidgetStopType? = nil
    
    @IBOutlet weak var selectedStop: UITextField!
    @IBOutlet weak var stopLabel: UILabel!

    /// This gets called when the cell is loaded
    override func layoutSubviews() {
        loadWidgetStops()
        if self.favoriteStops.count == 0 {
            self.selectedStop.text = "Add favorite stops"
            if self.widgetStopType != nil {
                LocalData.removeWidgetStop(for: self.widgetStopType!)
            }
        } else {
            self.selectedStop.text = getSelectedStop()
            self.selectedStop.inputView = initializePicker()
            self.selectedStop.inputAccessoryView = initializePickerToolbar()
        }
    }
    
    /// This function loads the favorites stop
    public func loadWidgetStops() {
        self.favoriteStops = Parser.parseLocalFavoriteStops(data: LocalData.getFavoriteStops())
    }
    
    /// helper function that initializes the picker
    private func initializePicker() -> UIPickerView {
        let stopPicker = UIPickerView()
        stopPicker.dataSource = self
        stopPicker.delegate = self
        stopPicker.selectRow(getSelectedStopIndex(), inComponent: 0, animated: true)
        return stopPicker
    }
    
    /// Helper function that gets the index of the selected stop
    ///
    /// - Returns: Integer value of the index of the selected stop
    private func getSelectedStopIndex() -> Int {
        if self.favoriteStops.count > 0 {
            for stopIndex in 0...(self.favoriteStops.count - 1) {
                if self.favoriteStops[stopIndex].name == self.selectedStop.text {
                    return stopIndex
                }
            }
        }
        return 0
    }
    
    /// helper function that initializes the toolbar view toolbar
    private func initializePickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closePicker))
        toolbar.setItems([doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }
    
    /// Gets called when the 'Done' button is clicked
    ///
    /// - Parameter sender: the sender of the request
    func closePicker(sender: UIBarButtonItem) {
        self.selectedStop.resignFirstResponder()
    }
    
    /// Gets the selected stop from the text field
    ///
    /// - Returns: returns the selected stop name
    private func getSelectedStop() -> String {
        if widgetStopType != nil {
            let currentFavoriteStop = LocalData.getWidgetStop(for: self.widgetStopType!)
            if currentFavoriteStop == nil {
                LocalData.updateWidgetStop(for: self.widgetStopType!, stop: self.favoriteStops[0])
                return favoriteStops[0].name
            }
            return currentFavoriteStop!.name
        }
        return ""
    }
    
    /// gets called when the picker is loading to return the number of sections
    ///
    /// - Parameter pickerView: the picker view
    /// - Returns: the number of sections
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Returns the number of rows in a component
    ///
    /// - Parameters:
    ///   - pickerView: the picker view
    ///   - component: the component number
    /// - Returns: number of rows in that component
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.favoriteStops.count
    }
    
    /// Returns the title of the row
    ///
    /// - Parameters:
    ///   - pickerView: the picker view
    ///   - row: the row number
    ///   - component: the component number
    /// - Returns: the title of the row
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.favoriteStops[row].name as String?
    }
    
    /// Gets called when a row is selected
    ///
    /// - Parameters:
    ///   - pickerView: the picker view
    ///   - row: the row number
    ///   - component: the component number
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedStop.text = self.favoriteStops[row].name
        LocalData.updateWidgetStop(for: self.widgetStopType!, stop: self.favoriteStops[row])
    }
    
    /// Disable changing the text field by hand
    ///
    /// - Parameters:
    ///   - textField: the text field
    ///   - range: the range
    ///   - string: the string value
    /// - Returns: whether the characters could change
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
