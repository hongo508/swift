//
//  HealthKitView.swift
//  HealthKit-test
//
//  Created by 本郷匠 on 2020/01/14.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import HealthKit

@available(iOS 13.0, *)
struct HealthKitView: View {
    @State var text = ""
    let healthStore = HKHealthStore()
    let readTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    var body: some View {
        VStack{
            Text(text)
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                if HKHealthStore.isHealthDataAvailable() { self.healthStore.requestAuthorization(toShare: nil, read: self.readTypes, completion: {
                    (success, error) in
                    if success {
                        print("success")
                        var step = 0.0
                        let now = Date()
                        let query = HKStatisticsQuery(
                            quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            quantitySamplePredicate: HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -1, to: now), end: now),
                            options: .cumulativeSum,
                            completionHandler: {
                                (query, result, error) in
                                step = (result?.sumQuantity()?.doubleValue(for: HKUnit.count()))!
                                self.text = "\(Int(step))歩"
                        })
                        self.healthStore.execute(query)
                    } else {
                        print("error")
                    }
                })
                }
            }, label: {
                Text("歩数取得")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            )
                .padding()
                .background(Color.blue)
        }
    }
}

@available(iOS 13.0, *)
struct HealthKitView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitView()
    }
}
