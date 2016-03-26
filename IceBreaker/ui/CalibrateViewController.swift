//
//  CalibrateViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/14/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit
import Charts

class CalibrateViewController: UIViewController, UITextFieldDelegate, ProtocolDelegate, BLEDataProcessDelegate {

    @IBOutlet weak var txtSensorMax: UITextField!
    @IBOutlet weak var gvMeasureValue: LMGaugeView!
    @IBOutlet weak var cvMeasureValues: LineChartView!

    #if PIN19
    var SENSOR_PIN: UInt8 = 19
    #elseif PIN18
    var SENSOR_PIN: UInt8 = 18
    #endif
    
    var ble: BLE! = nil
    
    var rblProtocol: RBLProtocol! = nil
    var syncTimer: NSTimer! = nil
    var totalPinCount: UInt8 = 0
    var pinMode: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinCap: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinDigital: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinAnalog: [UInt16] = [UInt16](count: 128, repeatedValue: 1000)
    var pinPwm: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinServo: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    
    let dataInputInterval = 0.5     // 초단위.
    var dataInputTimer: NSTimer! = nil

    var measuresSize = 10
    var measures: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        initRBP()
    }

    override func viewDidAppear(animated: Bool) {
        self.view.makeToastActivity(message: "Initializing...")
        syncTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("onSyncTimer:"), userInfo: nil, repeats: false)
        rblProtocol.queryProtocolVersion()
    }
    
    override func viewWillDisappear(animated: Bool) {
        uninitRBP()
        if dataInputTimer != nil {
            dataInputTimer.invalidate()
        }
        if syncTimer != nil {
            syncTimer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtSensorMax.resignFirstResponder()
    }
    
    @IBAction func onSaveBtn_Click(sender: AnyObject) {
        if txtSensorMax.text == nil || txtSensorMax.text!.isEmpty {
            self.view.makeToast(message: "Please input sensor max!")
            return
        }
        
        let sensorMax = Int(txtSensorMax.text!)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(sensorMax!, forKey: "sensor_max")
        userDefaults.synchronize()
        self.view.makeToast(message: "Saved sensor max value!")
    }
    
    func onDataInputTimer(timer: NSTimer) {
        let sensorValue = pinAnalog[Int(SENSOR_PIN)];

        measures.append(Int(sensorValue))
        if measures.count > measuresSize {
            measures.removeFirst()
        }
        gvMeasureValue.value = CGFloat(sensorValue)
        showMeasureValues()
    }
    
    func onSyncTimer(timer: NSTimer) {
        self.view.hideToastActivity()
        self.view.makeToast(message: "No response from the BLE Controller sketch.")
        if ble.activePeripheral != nil {
            ble.CM.cancelPeripheralConnection(ble.activePeripheral)
        }
    }
    

    func initUI() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let sensorMax = userDefaults.integerForKey("sensor_max")
        txtSensorMax.text = "\(sensorMax)"
        gvMeasureValue.valueFont = UIFont.systemFontOfSize(60.0)
        
        cvMeasureValues.descriptionText = ""
        cvMeasureValues.noDataTextDescription = "No measure!"
        cvMeasureValues.dragEnabled = false
        cvMeasureValues.setScaleEnabled(false)
        cvMeasureValues.pinchZoomEnabled = true
        cvMeasureValues.drawGridBackgroundEnabled = false
        let leftAxis = cvMeasureValues.leftAxis
        leftAxis.customAxisMin = 0
        leftAxis.customAxisMax = 1000
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.drawZeroLineEnabled = true
        cvMeasureValues.rightAxis.enabled = false
        cvMeasureValues.viewPortHandler.setMaximumScaleY(2.0)
        cvMeasureValues.viewPortHandler.setMaximumScaleX(2.0)
        cvMeasureValues.legend.form = .Line
        showMeasureValues()
    }
    
    func showMeasureValues() {
        let xValsCount: Int = measuresSize
        var xVals: [String] = [String]()
        for var i = 0; i < xValsCount; i++ {
            xVals.append("\(i)")
        }
        
        var yVals: [ChartDataEntry] = [ChartDataEntry]()
        for var i = 0; i < xValsCount; i++ {
            if i < measures.count {
                yVals.append(ChartDataEntry(value: Double(measures[i]), xIndex: i))
            }
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: yVals, label: "Sensor values")
        lineChartDataSet.lineDashLengths = [5.0, 2.5]
        lineChartDataSet.highlightLineDashLengths = [5.0, 2.5]
        lineChartDataSet.setColor(UIColor.blackColor())
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.drawFilledEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        
        let lineChartData = LineChartData(xVals: xVals, dataSet: lineChartDataSet)
        cvMeasureValues.data = lineChartData
    }
    
    func initRBP() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        ble = appDelegate.ble
        
        rblProtocol = RBLProtocol()
        rblProtocol.delegate = self
        rblProtocol.ble = ble
        
        BLEDataProcessor.getInstance().processor = self
        startDataInput()
    }
    
    func uninitRBP() {
        BLEDataProcessor.getInstance().processor = nil
    }
    
    func startDataInput() {
        if dataInputTimer != nil {
            dataInputTimer.invalidate()
        }
        dataInputTimer = NSTimer.scheduledTimerWithTimeInterval(dataInputInterval, target: self, selector: Selector("onDataInputTimer:"), userInfo: nil, repeats: true)
        showMeasureValues()
    }
    
    func processData(data: UnsafeMutablePointer<UInt8>, length: Int32) {
        rblProtocol.parseData(data, length: length)
    }
    
    func bleDisconnected() {
        self.view.makeToast(message: "Disconnected from the sensor device!")
    }
    
    func protocolDidReceiveProtocolVersion(major: UInt8, _ minor: UInt8, _ bugfix: UInt8) -> Void {
        self.view.hideToastActivity()
        syncTimer.invalidate()
        
        let bufStr = "BLE"
        let buf: [UInt8] = [UInt8](bufStr.utf8)
        
        rblProtocol.sendCustomData(UnsafeMutablePointer<UInt8>(buf), length: 3)
        rblProtocol.queryTotalPinCount()
    }
    
    func protocolDidReceiveTotalPinCount(count: UInt8) {
        totalPinCount = count
        rblProtocol.setPinMode(SENSOR_PIN, mode: UInt8(ANALOG))
        rblProtocol.queryPinAll()
    }
    
    func protocolDidReceivePinCapability(pin: UInt8, _ value: UInt8) {
        pinCap[Int(pin)] = value
    }
    
    func protocolDidReceivePinData(pin: UInt8, _ mode: UInt8, _ value: UInt8) {
        let _mode: UInt8 = mode & 0x0F
        pinMode[Int(pin)] = _mode
        if _mode == UInt8(INPUT) || _mode == UInt8(OUTPUT) {
            pinDigital[Int(pin)] = value
        } else if _mode == UInt8(ANALOG) {
            pinAnalog[Int(pin)] = ((UInt16(mode) >> 4) << 8) + UInt16(value)
        } else if _mode == UInt8(PWM) {
            pinPwm[Int(pin)] = value
        } else if _mode == UInt8(SERVO) {
            pinServo[Int(pin)] = value
        }
    }
    
    func protocolDidReceivePinMode(pin: UInt8, _ mode: UInt8) {
        pinMode[Int(pin)] = mode
    }
    
    func protocolDidReceiveCustomData(data: UnsafeMutablePointer<UInt8>, _ length: UInt8) {
        // Custom data.
    }
    
}
