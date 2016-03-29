//
//  MeasureViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit
import AVFoundation
import Charts

class MeasureViewController: UIViewController, ProtocolDelegate, BLEDataProcessDelegate {

    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var gvMeasureValue: LMGaugeView!
    @IBOutlet weak var cvMeasureValues: LineChartView!
    @IBOutlet weak var lblSeconds: UILabel!
    
    #if PIN19
    var SENSOR_PIN: UInt8 = 19
    #elseif PIN18
    var SENSOR_PIN: UInt8 = 18
    #endif
    
    var SENSOR_MAX_VALUE: UInt16 = 600
    
    var memberIndex = 0
    var ble: BLE! = nil

    var rblProtocol: RBLProtocol! = nil
    var syncTimer: NSTimer! = nil
    var totalPinCount: UInt8 = 0
    var pinMode: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinCap: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinDigital: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinAnalog: [UInt16] = [UInt16](count: 128, repeatedValue: 600)
    var pinPwm: [UInt8] = [UInt8](count: 128, repeatedValue: 0)
    var pinServo: [UInt8] = [UInt8](count: 128, repeatedValue: 0)

    let countDownLimit = 10         // 초단위.
    let dataInputInterval = 0.5     // 초단위.
    var dataInputTimer: NSTimer! = nil
    var countDownTimer: NSTimer! = nil
    var countDownValue = 0
    
    var audioPlayer: AVAudioPlayer! = nil
    
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
    
    @IBAction func onStartBtn_Click(sender: AnyObject) {
        //
        // Beep 출력 시작.
        //
        audioPlayer.numberOfLoops = -1
        //audioPlayer.play()
        
        //
        // Countdown 시작.
        //
        if countDownTimer != nil {
            countDownTimer.invalidate()
        }
        countDownValue = countDownLimit
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("onCountDownTimer:"), userInfo: nil, repeats: true)
        btnStart.setTitle("Retest", forState: .Normal)
        lblSeconds.text = "\(countDownValue)"
        
        //
        // 자료 입력 시작.
        //
        if dataInputTimer != nil {
            dataInputTimer.invalidate()
        }
        dataInputTimer = NSTimer.scheduledTimerWithTimeInterval(dataInputInterval, target: self, selector: Selector("onDataInputTimer:"), userInfo: nil, repeats: true)
        Members.getInstance().members[memberIndex].measures.removeAll()
        showMeasureValues()
    }
    
    @IBAction func onRetestBtn_Click(sender: AnyObject) {
    }
    
    @IBAction func onCloseBtn_Click(sender: AnyObject) {
        uninitRBP()
        if dataInputTimer != nil {
            dataInputTimer.invalidate()
        }
        if countDownTimer != nil {
            countDownTimer.invalidate()
        }
        if syncTimer != nil {
            syncTimer.invalidate()
        }
        audioPlayer.stop()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func onNextBtn_Click(sender: AnyObject) {
        memberIndex = (memberIndex + 1) % Members.getInstance().count
        initUI()
    }
    
    func onCountDownTimer(timer: NSTimer) {
        countDownValue--
        lblSeconds.text = "\(countDownValue)"
        if countDownValue == 0 {
            //
            // 10초동안의 자료 측정이 완성된 후.
            //
            countDownTimer.invalidate()
            countDownTimer = nil
            
            btnStart.setTitle("Start", forState: .Normal)
            
            //
            // 측정자료 입력은 중지.
            //
            if dataInputTimer != nil {
                dataInputTimer.invalidate()
            }
        }
    }
    
    func onDataInputTimer(timer: NSTimer) {
        //
        // 측정자료 샘플링.
        //
        // [0..SENSOR_MAX_VALUE] -> [0..100]
        let sensorValue = pinAnalog[Int(SENSOR_PIN)];
        var measureValue = Int(SENSOR_MAX_VALUE - sensorValue) * 100 / Int(SENSOR_MAX_VALUE)
        if measureValue < 0 {
            measureValue = 0
        }
        
        //
        // Beep 음량 조정.
        //
        audioPlayer.volume = Float(measureValue) / Float(SENSOR_MAX_VALUE)
        
        //let measureValue = rand() % 100
        Members.getInstance().members[memberIndex].measures.append(Int(measureValue))
        gvMeasureValue.value = CGFloat(measureValue)
        showMeasureValues()
    }
    
    func onSyncTimer(timer: NSTimer) {
        self.view.hideToastActivity()
        self.view.makeToast(message: "No response from the BLE Controller sketch.")
        if ble.activePeripheral != nil {
            ble.CM.cancelPeripheralConnection(ble.activePeripheral)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1000000000)), dispatch_get_main_queue(), { () -> Void in
            self.onCloseBtn_Click(self.btnName)
        })
    }
    
    
    func initUI() {
        let beep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:beep)
            audioPlayer.prepareToPlay()
        }catch {
            print("Error getting the audio file")
        }
        
        if memberIndex == Members.getInstance().count - 1 {
            btnName.setTitle("Group GSR", forState: .Normal)
        } else {
            btnName.setTitle(Members.getInstance().members[memberIndex].name, forState: .Normal)
        }
        cvMeasureValues.descriptionText = ""
        cvMeasureValues.noDataTextDescription = "No measure!"
        cvMeasureValues.dragEnabled = false
        cvMeasureValues.setScaleEnabled(false)
        cvMeasureValues.pinchZoomEnabled = true
        cvMeasureValues.drawGridBackgroundEnabled = false
        let leftAxis = cvMeasureValues.leftAxis
        leftAxis.customAxisMin = 0
        leftAxis.customAxisMax = 100
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.drawZeroLineEnabled = true
        cvMeasureValues.rightAxis.enabled = false
        cvMeasureValues.viewPortHandler.setMaximumScaleY(2.0)
        cvMeasureValues.viewPortHandler.setMaximumScaleX(2.0)
        cvMeasureValues.legend.form = .Line
        
        gvMeasureValue.value = 0
        showMeasureValues()
    }
    
    func showMeasureValues() {
        let xValsCount: Int = Int(Double(countDownLimit) / dataInputInterval)
        var xVals: [String] = [String]()
        for var i = 0; i < xValsCount; i++ {
            xVals.append("\(i)")
        }
        
        var yVals: [ChartDataEntry] = [ChartDataEntry]()
        for var i = 0; i < xValsCount; i++ {
            if i < Members.getInstance().members[memberIndex].measures.count {
                yVals.append(ChartDataEntry(value: Double(Members.getInstance().members[memberIndex].measures[i]), xIndex: i))
            }
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: yVals, label: "Measure values")
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
        rblProtocol = RBLProtocol()
        rblProtocol.delegate = self
        rblProtocol.ble = ble
        
        BLEDataProcessor.getInstance().processor = self
        
        let userDefauls = NSUserDefaults.standardUserDefaults()
        if userDefauls.valueForKey("sensor_max") != nil {
            SENSOR_MAX_VALUE = UInt16(userDefauls.integerForKey("sensor_max"))
        }
    }
    
    func uninitRBP() {
        BLEDataProcessor.getInstance().processor = nil
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
