//
//  PianoVC.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class PianoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //get notification
        registerLocal()
        scheduleLocal()
    }
    
    //notification
    let center = UNUserNotificationCenter.current()
    
    //register notification
    func registerLocal() {
        center.removeAllPendingNotificationRequests()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        }
    }
    
    //schedule notification
    func scheduleLocal() {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "description"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 16
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest (identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
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
