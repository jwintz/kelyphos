// KelyphosShellConfiguration.swift - Generic config struct for panel types

import SwiftUI

/// Configuration for KelyphosShellView, specifying panel tabs and the detail view.
public struct KelyphosShellConfiguration<
    NavTab: KelyphosPanel,
    InspTab: KelyphosPanel,
    UtilTab: KelyphosPanel,
    Detail: View
> {
    public var navigatorTabs: [NavTab]
    public var inspectorTabs: [InspTab]
    public var utilityTabs: [UtilTab]
    public var detail: () -> Detail

    public init(
        navigatorTabs: [NavTab],
        inspectorTabs: [InspTab],
        utilityTabs: [UtilTab] = [],
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.navigatorTabs = navigatorTabs
        self.inspectorTabs = inspectorTabs
        self.utilityTabs = utilityTabs
        self.detail = detail
    }
}
