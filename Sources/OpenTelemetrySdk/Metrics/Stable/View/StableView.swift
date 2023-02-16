/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetryApi

public class StableView {
    public private(set) var name : String?
    public private(set) var description : String?
    public private(set) var aggregation : Aggregation
//    public private(set) var attributesProcessor : AttributesProcessor
    init(name: String?, description: String?, aggregation: Aggregation) { // attributesProcessor: AttributesProcessor) {
        self.name = name
        self.description = description
        self.aggregation = aggregation
//        self.attributesProcessor = attributesProcessor
    }

    static func builder() -> ViewBuilder {
        return ViewBuilder()
    }

}
