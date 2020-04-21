//
//  ScheduledTimer.swift
//  TouchletCore
//
//  Created by Elias on 18/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class MPAnalyticsTimingManager{
    private var timeInterval: TimeInterval
    private var timer: Timer?
    
    weak var delegate: MPAnalyticsTimingDispatcherDelegate?
    
    public static let shared = MPAnalyticsTimingManager()
            
    private init(timeInterval: TimeInterval = 60) {
        self.timeInterval = timeInterval
    }
    
    public func beginTracking(timingVariable: String, tracker: MPGoogleAnalyticsTracker = .shared){
        timer = Timer(timeInterval: timeInterval, repeats: true, block: {
            let time = Int($0.fireDate.timeIntervalSince1970)
            tracker.trackTiming(with: MPTimingParams(category: "online", variable: timingVariable, time: time))
            self.delegate?.mpAnalyticsTimingDispatcher(timingDispached: self)
            
        })
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    public func endTracking(){
        timer?.invalidate()
        delegate?.mpAnalyticsTimingDispatcher(timingEnded: self)
    }
}

protocol MPAnalyticsTimingDispatcherDelegate: AnyObject{
    func mpAnalyticsTimingDispatcher(timingEnded dispacher: MPAnalyticsTimingManager)
    
    func mpAnalyticsTimingDispatcher(timingDispached dispacher: MPAnalyticsTimingManager)
}
