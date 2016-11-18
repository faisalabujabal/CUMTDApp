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

    override func layoutSubviews() {
        loadWidgetStops()
        if self.favoriteStops.count == 0 {
            self.selectedStop.text = "Add favorite stops"
        } else {
            self.selectedStop.text = getSelectedStop()
            self.selectedStop.inputView = initializePicker()
            self.selectedStop.inputAccessoryView = initializePickerToolbar()
        }
    }
    
    public func loadWidgetStops() {
        self.favoriteStops = Parser.parseLocalFavoriteStops(data: LocalData.getFavoriteStops())
    }
    
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
    
    func closePicker(sender: UIBarButtonItem) {
        self.selectedStop.resignFirstResponder()
    }
    
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
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.favoriteStops.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.favoriteStops[row].name as String?
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedStop.text = self.favoriteStops[row].name
        LocalData.updateWidgetStop(for: self.widgetStopType!, stop: self.favoriteStops[row])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
