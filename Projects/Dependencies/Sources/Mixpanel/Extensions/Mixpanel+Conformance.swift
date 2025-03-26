import Foundation
import Mixpanel

// MARK: - Extensions to make Mixpanel classes conform to our protocols

private func convertToMixpanelProperties(_ properties: [String: Any]?) -> Properties? {
    guard let properties = properties else { return nil }

    var mixpanelProperties: Properties = [:]

    for (key, value) in properties {
        if let stringValue = value as? String {
            mixpanelProperties[key] = stringValue
        } else if let numberValue = value as? NSNumber {
            mixpanelProperties[key] = numberValue
        } else if let boolValue = value as? Bool {
            mixpanelProperties[key] = boolValue
        } else if let dateValue = value as? Date {
            mixpanelProperties[key] = dateValue
        } else if let urlValue = value as? URL {
            mixpanelProperties[key] = urlValue
        } else if let arrayValue = value as? [Any] {
            let convertedArray = arrayValue.compactMap { element -> MixpanelType? in
                if let str = element as? String { return str }
                if let num = element as? NSNumber { return num }
                if let bool = element as? Bool { return bool }
                if let date = element as? Date { return date }
                if let url = element as? URL { return url }
                return nil
            }
            if !convertedArray.isEmpty {
                mixpanelProperties[key] = convertedArray
            }
        } else if value is NSNull {
            mixpanelProperties[key] = NSNull()
        }
    }

    return mixpanelProperties.isEmpty ? nil : mixpanelProperties
}

extension MixpanelInstance: Analytics {
    public func optOut() {
        optOutTracking()
    }

    public func optIn(uid: String?) {
        optInTracking(distinctId: uid)
    }

    public func identify(uid: String, properties: [String: Any]?) {
        identify(distinctId: uid)
        if let properties = convertToMixpanelProperties(properties) {
            people.set(properties: properties)
        }
    }

    public func reset() {
        reset(completion: nil)
    }

    public func track(event: AnalyticsEvent) {
        let (name, properties) = event.nameAndProperties
        track(event: name.rawValue, properties: convertToMixpanelProperties(properties))
    }

    public func startTimingEvent(event: AnalyticsEventName) {
        time(event: event.rawValue)
    }

    public func trackTimedEvent(event: AnalyticsEventName, additionalProperties: [String: Any]?) {
        var properties = additionalProperties ?? [:]
        properties[AnalyticsProperties.viewDuration] = eventElapsedTime(event: event.rawValue)
        track(event: event.rawValue, properties: convertToMixpanelProperties(properties))
    }
}
