//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation
import OpenTelemetryApi


public class ReservoirCell {
    let clock : Clock
    var attributes = [String: AttributeValue]()
    var spanContext : SpanContext? = nil
    var recordTime : UInt64 = 0
    
    var doubleValue : Double = 0
    var longValue:  Int = 0
    
    init(clock: Clock) {
        self.clock = clock
    }
    
    func recordLongValue(value: Int, attributes: [String:AttributeValue]) {
        longValue = value
        offerMeasurement(attributes: attributes)
    }
    
    func recordDoubleValue(value: Double, attributes: [String:AttributeValue]) {
        doubleValue = value
        offerMeasurement(attributes: attributes)
    }
    
    private func offerMeasurement(attributes: [String:AttributeValue]) {
        self.attributes = attributes
        recordTime = clock.nanoTime
        if let context = OpenTelemetry.instance.contextProvider.activeSpan?.context, context.isValid {
            self.spanContext = context
        }
    }
    
    func getAndResetLong(pointAttributes:  [String: AttributeValue]) ->  ImmutableLongExemplarData {
        let result = ImmutableLongExemplarData(filteredAttributes: filtered(attributes, pointAttributes), recordTimeNanos: recordTime, spanContext: spanContext, value: longValue)
        reset()
        return result
    }
    
    func getAndResetDouble(pointAttributes: [String:AttributeValue]) -> DoubleExemplarData {
        let result = ImmutableDoubleExemplarData(filteredAttributes: filtered(attributes,pointAttributes), recordTimeNanos: recordTime, spanContext: spanContext, value: doubleValue)
        reset()
        return result
    }
    
    
    func reset() {
        attributes = [String: AttributeValue]()
        longValue = 0
        doubleValue = 0
        spanContext = nil
        recordTime = 0
    }
    
    func filtered(_ original : [String: AttributeValue], _ metricPoint : [String: AttributeValue]) -> [String: AttributeValue] {
        if metricPoint.isEmpty {
            return original
        }
        return original.filter { key, _ in
            if let _ = metricPoint[key] {
                return false
            }
            return true
        }
    }
}
