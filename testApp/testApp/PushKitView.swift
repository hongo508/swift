//
//  PushKitView.swift
//  testApp
//
//  Created by 本郷匠 on 2020/01/18.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import PushKit

@available(iOS 13.0, *)
struct PushKitView: View {
    let center = UNUserNotificationCenter.current()
    
    var body: some View {
        VStack {
            Button(action: {
                self.center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
                    (success, error) in
                    if error != nil {
                        return
                    }
                    
                    if success {
                        print("通知許可")
                        let trigger: UNNotificationTrigger
                        let content = UNMutableNotificationContent()
                        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        content.title = "通知テスト"
                        content.body = "通知を送ってみた"
                        content.sound = UNNotificationSound.default
                        let request = UNNotificationRequest(identifier: "testid", content: content, trigger: trigger)
                        self.center.add(request)
                    } else {
                        print("通知拒否")
                    }
                })
            }, label: {
                Text("通知設定")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
            })
                .background(Color.blue)
                .cornerRadius(50)
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct PushKitView_Previews: PreviewProvider {
    static var previews: some View {
        PushKitView()
    }
}
#endif
