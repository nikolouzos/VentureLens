import Foundation
@testable import Mixpanel

public class MixpanelHelpers {
    public static func waitForTrackingQueue(_ mixpanel: MixpanelInstance) {
        mixpanel.trackingQueue.sync() {
            mixpanel.networkQueue.sync() {
                return
            }
        }
        
        mixpanel.trackingQueue.sync() {
            mixpanel.networkQueue.sync() {
                return
            }
        }
    }
}
