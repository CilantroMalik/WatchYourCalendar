//
//  ComplicationController.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import ClockKit

func createTimelineEntry(complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry? {
    if complication.identifier == "DayAndBlocks" {
        if complication.family == CLKComplicationFamily.modularSmall {
            let template = CLKComplicationTemplateModularSmallStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetOrder()))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else if complication.family == CLKComplicationFamily.graphicCircular {
            let template = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetOrder()))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        }
    } else if complication.identifier == "DayAndNextClass" {
        if complication.family == CLKComplicationFamily.utilitarianSmallFlat {
            let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKSimpleTextProvider(text: "Next: \(compGetNextBlock(date: date))"))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else if complication.family == CLKComplicationFamily.circularSmall {
            let template = CLKComplicationTemplateCircularSmallStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetNextBlock(date: date)))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        }
    } else if complication.identifier == "DayBlocksClass" {
        if complication.family == CLKComplicationFamily.modularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), body1TextProvider: CLKSimpleTextProvider(text: "Blocks: \(order[cycleDay]!.joined(separator: "-"))"), body2TextProvider: CLKSimpleTextProvider(text: compLongNextClass(date: date)))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else if complication.family == CLKComplicationFamily.graphicRectangular {
            let template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), body1TextProvider: CLKSimpleTextProvider(text: "Blocks: \(order[cycleDay]!.joined(separator: "-"))"), body2TextProvider: CLKSimpleTextProvider(text: compLongNextClass(date: date)))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        }
    } else if complication.identifier == "NextClassIn" {
        if complication.family == CLKComplicationFamily.graphicBezel {
            let preTemplate = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetOrder()))
            let template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: preTemplate, textProvider: CLKSimpleTextProvider(text: "\(compLongNextClass(date: date)) in \(compGetTimeUntil(date: date))"))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else if complication.family == CLKComplicationFamily.graphicCorner {
            let template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: CLKSimpleTextProvider(text: "\(compGetNextBlock(date: date)) in \(compGetTimeUntil(date: date))"), outerTextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else if complication.family == CLKComplicationFamily.utilitarianLarge {
            let template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "\(compLongNextClass(date: date)) in \(compGetTimeUntil(date: date))"))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        }
    } else if complication.identifier == "DayProgress" {
        if complication.family == CLKComplicationFamily.graphicCircular {
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: .fill, gaugeColor: .orange, fillFraction: compGetDayGayge(now: date)), centerTextProvider: CLKSimpleTextProvider(text: compGetNextBlock(date: date)))
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else if complication.family == CLKComplicationFamily.circularSmall {
            let template = CLKComplicationTemplateCircularSmallRingText(textProvider: CLKSimpleTextProvider(text: compGetNextBlock(date: date)), fillFraction: compGetDayGayge(now: date), ringStyle: .closed)
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        }
    }
    return nil
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "DayAndBlocks", displayName: "Day & Blocks", supportedFamilies: [CLKComplicationFamily.modularSmall, CLKComplicationFamily.graphicCircular]),
            CLKComplicationDescriptor(identifier: "DayAndNextClass", displayName: "Day & Next Class", supportedFamilies: [CLKComplicationFamily.utilitarianSmallFlat, CLKComplicationFamily.circularSmall]),
            CLKComplicationDescriptor(identifier: "DayBlocksClass", displayName: "Day, Blocks, & Next Class", supportedFamilies: [CLKComplicationFamily.modularLarge, CLKComplicationFamily.graphicRectangular]),
            CLKComplicationDescriptor(identifier: "NextClassIn", displayName: "Next Class Time", supportedFamilies: [CLKComplicationFamily.graphicBezel, CLKComplicationFamily.graphicCorner, CLKComplicationFamily.utilitarianLarge]),
            CLKComplicationDescriptor(identifier: "DayProgress", displayName: "Day rogress", supportedFamilies: [CLKComplicationFamily.graphicCircular, CLKComplicationFamily.circularSmall])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(createTimelineEntry(complication: complication, date: Date()))
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        var entries: [CLKComplicationTimelineEntry] = []
        var currentMinute = date.advanced(by: 60)
        while entries.count < limit {
            //print("populating entry for date \(currentMinute)")
            entries.append(createTimelineEntry(complication: complication, date: currentMinute)!)
            currentMinute = currentMinute.advanced(by: 60)
        }
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
