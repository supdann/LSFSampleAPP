//
//  ScheduleOverview.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import UIKit

class ScheduleOverview: UIView {

    @IBOutlet weak var firstLayer: UIView!
    @IBOutlet weak var secondLayer: UIView!
    @IBOutlet weak var thirdLayer: UIView!
    
    @IBOutlet weak var d1: UILabel!
    @IBOutlet weak var d2: UILabel!
    @IBOutlet weak var d3: UILabel!
    @IBOutlet weak var d4: UILabel!
    @IBOutlet weak var d5: UILabel!
    @IBOutlet weak var d6: UILabel!
    @IBOutlet weak var d7: UILabel!
    @IBOutlet weak var d8: UILabel!
    @IBOutlet weak var d9: UILabel!
    @IBOutlet weak var d10: UILabel!
    @IBOutlet weak var d11: UILabel!
    @IBOutlet weak var d12: UILabel!
    @IBOutlet weak var d13: UILabel!
    @IBOutlet weak var d14: UILabel!
    @IBOutlet weak var d15: UILabel!
    @IBOutlet weak var d16: UILabel!
    @IBOutlet weak var d17: UILabel!
    @IBOutlet weak var d18: UILabel!
    @IBOutlet weak var d19: UILabel!
    @IBOutlet weak var d20: UILabel!
    @IBOutlet weak var d21: UILabel!
    @IBOutlet weak var d22: UILabel!
    @IBOutlet weak var d23: UILabel!
    @IBOutlet weak var d24: UILabel!
    @IBOutlet weak var d25: UILabel!
    @IBOutlet weak var d26: UILabel!
    @IBOutlet weak var d27: UILabel!
    @IBOutlet weak var d28: UILabel!
    
    var dViews = [UILabel]()
    
    // This includes the information about how the whole view should be painted
    var data: ScheduleIntervalLayer? { didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dViews = [d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28]
    }
    
    func setupView(){
        
        guard let data = self.data else {
            return
        }
        for interval in data.intervals1 {
            drawIntervalInLayer(interval: interval, yGap: 0.0, layer: self.firstLayer)
        }
        for interval in data.intervals2 {
            drawIntervalInLayer(interval: interval, yGap: 12.0, layer: self.secondLayer)
        }
        for interval in data.intervals3 {
            drawIntervalInLayer(interval: interval, yGap: 24.0, layer: self.thirdLayer)
        }
        for grayDay in data.grayDays {
            self.dViews[grayDay].backgroundColor = Constants.lsfGray
        }
        for orangeDay in data.orangeDays {
            self.dViews[orangeDay].backgroundColor = Constants.lsfOrange
        }
        
        for i in 0...27 {
            self.dViews[i].text = String(data.days[i])
        }
        applyStyleToDViews()
    }
    
    /// Use this method to draw a schedule interval into a layer
    ///
    /// - Parameters:
    ///   - interval: The Interval that needs to be drawn
    ///   - yGap: This ist the height of the layer
    ///   - layer: This defined the layer in which the interval should be drawn
    func drawIntervalInLayer(interval: ScheduleInterval, yGap: Double, layer: UIView){
        
        let gap = 12.0
        
        let view = UIView(frame: CGRect(origin:CGPoint(x: gap*Double(interval.start), y: yGap), size: CGSize(width: Double(interval.length)*gap, height: 12.0)))
        view.backgroundColor = interval.color
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        
        
        let label = UILabel(frame: CGRect(origin:CGPoint(x: 5, y: 0), size: CGSize(width: Double(interval.length)*gap - 10, height: 12.0)))
        label.text = interval.text
        label.font = UIFont.systemFont(ofSize: 8.0)
        if (interval.color == Constants.lsfBlue){
            label.textColor = UIColor.white
        }
        view.addSubview(label)
        firstLayer.addSubview(view)
    }
    
    /// This method loops throw all of the day views and apply the border style
    func applyStyleToDViews(){
        for view in self.dViews {
            view.layer.borderColor = UIColor.gray.cgColor
            view.layer.borderWidth = 0.5
        }
    }
}
