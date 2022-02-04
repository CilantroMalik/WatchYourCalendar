//
//  ComplicationController.swift
//  CalendarTest WatchKit Extension
//
//  Created by Jack de Haan on 1/27/22.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "DayAndBlocks", displayName: "Day & Blocks", supportedFamilies: [CLKComplicationFamily.modularSmall, CLKComplicationFamily.graphicCircular]),
            CLKComplicationDescriptor(identifier: "DayAndNextClass", displayName: "Day & Next Class", supportedFamilies: [CLKComplicationFamily.utilitarianSmallFlat, CLKComplicationFamily.circularSmall]),
            CLKComplicationDescriptor(identifier: "DayBlocksClass", displayName: "Day, Blocks, & Next Class", supportedFamilies: [CLKComplicationFamily.modularLarge, CLKComplicationFamily.graphicRectangular]),
            CLKComplicationDescriptor(identifier: "NextClassIn", displayName: "Next class time", supportedFamilies: [CLKComplicationFamily.graphicBezel, CLKComplicationFamily.graphicCorner, CLKComplicationFamily.utilitarianLarge])
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
        
        
        if complication.identifier == "DayAndBlocks" {
            if complication.family == CLKComplicationFamily.modularSmall {
                let template = CLKComplicationTemplateModularSmallStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetOrder()))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            } else if complication.family == CLKComplicationFamily.graphicCircular {
                let template = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetOrder()))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            }
        } else if complication.identifier == "DayAndNextClass" {
            if complication.family == CLKComplicationFamily.utilitarianSmallFlat {
                let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKSimpleTextProvider(text: "Next: \(compGetNextBlock())"))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            } else if complication.family == CLKComplicationFamily.circularSmall {
                let template = CLKComplicationTemplateCircularSmallStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetNextBlock()))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            }
        } else if complication.identifier == "DayBlocksClass" {
            if complication.family == CLKComplicationFamily.modularLarge {
                let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), body1TextProvider: CLKSimpleTextProvider(text: "Blocks: \(order[cycleDay]!.joined(separator: "-"))"), body2TextProvider: CLKSimpleTextProvider(text: compLongNextClass()))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            } else if complication.family == CLKComplicationFamily.graphicRectangular {
                let template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), body1TextProvider: CLKSimpleTextProvider(text: "Blocks: \(order[cycleDay]!.joined(separator: "-"))"), body2TextProvider: CLKSimpleTextProvider(text: compLongNextClass()))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            }
        } else if complication.identifier == "NextClassIn" {
            if complication.family == CLKComplicationFamily.graphicBezel {
                let preTemplate = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"), line2TextProvider: CLKSimpleTextProvider(text: compGetOrder()))
                let template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: preTemplate, textProvider: CLKSimpleTextProvider(text: "\(compLongNextClass()) in \(compGetTimeUntil())"))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            } else if complication.family == CLKComplicationFamily.graphicCorner {
                let template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: CLKSimpleTextProvider(text: "\(compGetNextBlock()) in \(compGetTimeUntil())"), outerTextProvider: CLKSimpleTextProvider(text: "DAY \(cycleDay)"))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            } else if complication.family == CLKComplicationFamily.utilitarianLarge {
                let template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "\(compLongNextClass()) in \(compGetTimeUntil())"))
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            }
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
