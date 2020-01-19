//
//  HealthKitView.swift
//  testApp
//
//  Created by 本郷匠 on 2020/01/18.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import HealthKit

let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!

@available(iOS 13.0, *)
struct HealthKitView: View {
    @State var textLabel = ""
    let healthStore = HKHealthStore()
    let readTypes = Set([
        stepCount,
        heartRate
    ])
    
    var body: some View {
        VStack {
            Text(textLabel)
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                if HKHealthStore.isHealthDataAvailable() {
                    self.healthStore.requestAuthorization(toShare: nil, read: self.readTypes, completion: {
                        (success, error) in
                        if success {
                            var step = 0.0
                            let now = Date()
                            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)
                            let query = HKStatisticsQuery(quantityType: stepCount,
                                                          quantitySamplePredicate: HKQuery.predicateForSamples(withStart: yesterday, end: now),
                                                          options: .cumulativeSum,
                                                          completionHandler: {
                                                            (query, result, error) in
                                                            step = (result?.sumQuantity()?.doubleValue(for: HKUnit.count()))!
                                                            self.textLabel = "\(Int(step).withComma)歩"
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
                    .padding()
            })
                .background(Color.blue)
                .cornerRadius(50)
        }
    }
}

extension Int {
    var withComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let commaString = formatter.string(from: self as NSNumber)
        return commaString ?? "\(self)"
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct HealthKitView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitView()
    }
}
#endif
