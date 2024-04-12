//
//  GlobalMonthPicker.swift
//  Pet adoption
//
//  Created by Sri Lakshmi on 4/12/24.
//

import UIKit

class GlobalMonthYearPicker: UIViewController {
    private let monthYearWheelPicker = MonthYearWheelPicker()
    var onDone: ((_ month: Date) -> Void)?
    var onCancel: (() -> Void)?

    // Set the maximum and minimum dates here
        var maxDate: Date {
            let currentDate = Date()
            return currentDate
        }
        
        var minDate: Date {
            let calendar = Calendar.current
            let fiveYearsAgo = calendar.date(byAdding: .year, value: -5, to: Date()) ?? Date()
            return fiveYearsAgo
        }
    
    
    
    let toolBar = UIToolbar()
    var doneButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()


        monthYearWheelPicker.maximumDate = maxDate
        monthYearWheelPicker.minimumDate = minDate
        
        monthYearWheelPicker.backgroundColor = .white
        view.addSubview(monthYearWheelPicker)

        // Add constraints to position and size the picker within the view controller's view
        monthYearWheelPicker.translatesAutoresizingMaskIntoConstraints = false
        monthYearWheelPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        monthYearWheelPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        monthYearWheelPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        monthYearWheelPicker.heightAnchor.constraint(equalToConstant: 300).isActive = true

        
        // Create and set up the done button
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        doneButton.tintColor = .black
        let attributedDoneTitle = NSAttributedString(
            string: "Done",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.appColor // You can set your desired color here
            ]
        )
        let doneCustomButton = UIButton()
        doneCustomButton.setAttributedTitle(attributedDoneTitle, for: .normal)
        doneCustomButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.customView = doneCustomButton
        
        // Create and set up the cancel button
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        cancelButton.tintColor = .black
        
        // Set up the toolbar items
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        view.addSubview(toolBar)
   
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeAreaBottom = view.safeAreaInsets.bottom - 44
        monthYearWheelPicker.frame = CGRect(x: 0, y: view.frame.height - 280 - safeAreaBottom, width: view.frame.width, height: 280)
        toolBar.frame = CGRect(x: 0, y: view.frame.height - 280 - 44 - safeAreaBottom, width: view.frame.width, height: 44)
        toolBar.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        monthYearWheelPicker.backgroundColor = .clear
        monthYearWheelPicker.backgroundColor = .white
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
   
    }
    
    
    @objc private func cancelTapped() {
        self.dismiss(animated: true)
    }

    @objc private func doneTapped() {
        let year = monthYearWheelPicker.year
        let month = monthYearWheelPicker.month
        print(year)
        print(month)
        
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 2
        
        onDone?(calendar.date(from: dateComponents)!)
        self.dismiss(animated: true)
    }
}

 
/// A control for the inputting of month and year values in a view that uses a spinning-wheel or slot-machine metaphor.
open class MonthYearWheelPicker: UIPickerView {
    
    public var calendar = Calendar(identifier: .gregorian)
    public var _maximumDate: Date?
    public var _minimumDate: Date?
    public var _date: Date?
    public var months = [String]()
    public var years = [Int]()
    public var target: AnyObject?
    public var action: Selector?
    
    open var maximumDate: Date {
        set {
            _maximumDate = formattedDate(from: newValue)
            updateAvailableYears(animated: false)
        }
        get {
            return _maximumDate ?? formattedDate(from: calendar.date(byAdding: .year, value: 15, to: Date()) ?? Date())
        }
    }
    
    /// The minimum date that a picker can show.
    ///
    /// Use this property to configure the minimum date that is selected in the picker interface. The default is the current month and year.
    open var minimumDate: Date {
        set {
            _minimumDate = formattedDate(from: newValue)
            updateAvailableYears(animated: false)
        }
        get {
            return _minimumDate ?? formattedDate(from: Date())
        }
    }
    
     
    open var date: Date {
        set {
            setDate(newValue, animated: true)
        }
        get {
            return _date ?? formattedDate(from: Date())
        }
    }
    
    /// The month displayed by the picker.
    ///
    /// Use this property to get the current month in the Gregorian calendar starting from `1` for _January_ through to `12` for _December_.
    open var month: Int {
        return calendar.component(.month, from: date)
    }
    
    /// The year displayed by the picker.
    ///
    /// Use this property to get the current year in the Gregorian calendar.
    open var year: Int {
        return calendar.component(.year, from: date)
    }
    
    /// A completion handler to receive the month and year when the picker value is changed.
    open var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        removeTarget()
        guard controlEvents == .valueChanged else {
            return
        }
        self.target = target as? AnyObject
        self.action = action
    }
    
    /// Stops the delivery of events to the previously set target object.
    public func removeTarget() {
        self.target = nil
        self.action = nil
    }
   
    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        removeTarget()
    }
 
    public func setDate(_ date: Date, animated: Bool) {
        let date = formattedDate(from: date)
        _date = date
        if date > maximumDate {
            setDate(maximumDate, animated: true)
            return
        }
        if date < minimumDate {
            setDate(minimumDate, animated: true)
            return
        }
        updatePickers(animated: animated)
    }
    
    
    // MARK: public methods
    
    public func updatePickers(animated: Bool) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        DispatchQueue.main.async {
            self.selectRow(month - 1, inComponent: 0, animated: animated)
            if let firstYearIndex = self.years.firstIndex(of: year) {
                self.selectRow(firstYearIndex, inComponent: 1, animated: animated)
            }
        }
    }
    
    public func pickerViewDidSelectRow() {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        guard let date = DateComponents(calendar: calendar, year: year, month: month, day: 1, hour: 0, minute: 0, second: 0).date else {
            fatalError("Could not generate date from components")
        }
        self.date = date
        
        if let block = onDateSelected {
            block(month, year)
        }
        
        if let target = target, let action = action {
            _ = target.perform(action, with: self)
        }
    }
    
    public func formattedDate(from date: Date) -> Date {
        return DateComponents(calendar: calendar, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1, hour: 0, minute: 0, second: 0).date ?? Date()
    }
    
    public func updateAvailableYears(animated: Bool) {
        var years = [Int]()
        
        let startYear = calendar.component(.year, from: minimumDate)
        let endYear = max(calendar.component(.year, from: maximumDate), startYear)
        
        while years.last != endYear {
            years.append((years.last ?? startYear - 1) + 1)
        }
        self.years = years
        
        updatePickers(animated: animated)
    }
    
    public func commonSetup() {
        delegate = self
        dataSource = self
        
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        updateAvailableYears(animated: false)
    }
}

extension MonthYearWheelPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewDidSelectRow()
        if component == 1 {
            pickerView.reloadComponent(0)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var text: String?
        
        switch component {
        case 0:
            text = months[row % 12] // Use modulo operator to loop through months
        case 1:
            if years.indices.contains(row) {
                text = "\(years[row])"
            }
        default:
            return nil
        }
        
        guard let text = text else { return nil }

        var attributes = [NSAttributedString.Key: Any]()
        if #available(iOS 13.0, *) {
            attributes[.foregroundColor] = UIColor.label
        } else {
            attributes[.foregroundColor] = UIColor.black
        }
        
        if component == 0 {
            let month = row % 12 + 1
            let year = years[selectedRow(inComponent: 1)]
            if let date = DateComponents(calendar: calendar, year: year, month: month, day: 1, hour: 0, minute: 0, second: 0).date, date < minimumDate || date > maximumDate {
                if #available(iOS 13.0, *) {
                    attributes[.foregroundColor] = UIColor.secondaryLabel
                } else {
                    attributes[.foregroundColor] = UIColor.gray
                }
            }
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }

    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


