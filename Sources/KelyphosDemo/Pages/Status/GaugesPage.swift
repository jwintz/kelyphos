// GaugesPage.swift - Gauge styles

import SwiftUI

struct GaugesPage: View {
    @State private var cpuUsage = 0.65
    @State private var temperature = 72.0

    var body: some View {
        ShowcasePageChrome(item: ShowcaseCatalog.item("gauges")!) {
            VStack(alignment: .leading, spacing: 20) {
                GlassSection(title: "Linear Gauge") {
                    VStack(alignment: .leading, spacing: 12) {
                        Gauge(value: cpuUsage) {
                            Text("CPU Usage")
                        } currentValueLabel: {
                            Text("\(Int(cpuUsage * 100))%")
                        }
                        .gaugeStyle(.linearCapacity)

                        Slider(value: $cpuUsage, in: 0...1)
                    }
                }

                GlassSection(title: "Accessory Gauges") {
                    HStack(spacing: 24) {
                        Gauge(value: cpuUsage) {
                            Text("CPU")
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .frame(width: 60)

                        Gauge(value: 0.4) {
                            Text("Memory")
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .frame(width: 60)

                        Gauge(value: 0.8) {
                            Text("Disk")
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .frame(width: 60)
                    }
                }

                GlassSection(title: "Gauge with Range") {
                    Gauge(value: temperature, in: 0...100) {
                        Text("Temperature")
                    } currentValueLabel: {
                        Text("\(Int(temperature))°F")
                    } minimumValueLabel: {
                        Text("0°")
                    } maximumValueLabel: {
                        Text("100°")
                    }
                    .gaugeStyle(.linearCapacity)
                }
            }
        }
    }
}
