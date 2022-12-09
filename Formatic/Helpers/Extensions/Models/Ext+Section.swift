//
//  Extension+Section.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension Section: Codable, Identifiable, Csv, Copyable {
    
    convenience init(id: UUID = UUID(), position: Int, title: String?) {
        self.init(context: DataControllerModel.shared.container.viewContext)
        self.id = id
        self.position = Int16(position)
        self.title = title
    }
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case widgets
    }
    
    public func encode(to encoder: Encoder) throws {
        var sectionContainer = encoder.container(keyedBy: CodingKeys.self)
        try sectionContainer.encode(position, forKey: .position)
        try sectionContainer.encode(title, forKey: .title)
        try sectionContainer.encode(widgets, forKey: .widgets)
    }
    
    func sortedWidgetsArray() -> [Widget] {
        return widgets?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) ?? []
    }
    
    func numberOfWidgets() -> Int {
        return widgets?.count ?? 0
    }
    
    func delete() {
            if let sections = self.form?.sections?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) {
            for index in Int(self.position)..<sections.count {
                sections[index].position -= 1
            }
        }
        DataControllerModel.shared.container.viewContext.delete(self)
    }
    
    func updateWidgetPositions(indexSet: IndexSet, destination: Int) {
        var widgets = self.sortedWidgetsArray()

        widgets.move(fromOffsets: indexSet, toOffset: destination)
        
        for (index, widget) in widgets.enumerated() {
            DispatchQueue.main.async {
                widget.position = Int16(index)
            }
        }
    }
    
    func toCsv() -> String {
        var csvString = ""
        let allWidgets = (widgets ?? []).sorted { lhs, rhs in
            lhs.position < rhs.position
        }
        
        for item in allWidgets {
            let widgetType: WidgetType = WidgetType.init(rawValue: item.type!)!
            
            switch widgetType {
            case .dropdownSectionWidget:
                if let dropdownSectionWidget = item as? DropdownSectionWidget {
                    csvString += dropdownSectionWidget.toCsv()
                }
            case .textFieldWidget:
                if let textFieldWidget = item as? TextFieldWidget {
                    csvString += textFieldWidget.toCsv()
                }
                
            case .dateFieldWidget:
                if let dateFieldWidget = item as? DateFieldWidget {
                    csvString += dateFieldWidget.toCsv()
                }
                
            case .sliderWidget:
                if let sliderWidget = item as? SliderWidget {
                    csvString += sliderWidget.toCsv()
                }
                
            case .checkboxSectionWidget:
                if let checkboxSectionWidget = item as? CheckboxSectionWidget {
                    csvString += checkboxSectionWidget.toCsv()
                }
            case .mapWidget:
                if let mapWidget = item as? MapWidget {
                    csvString += mapWidget.toCsv()
                }
            case .numberFieldWidget:
                if let numberFieldWidget = item as? NumberFieldWidget {
                    csvString += numberFieldWidget.toCsv()
                }
            case .dropdownWidget:
                // Handled in DropdownSectionWidget
                break
            case .checkboxWidget:
                // Handled in CheckboxSectionWidget
                break
            case .canvasWidget:
                if let canvasWidget = item as? CanvasWidget {
                    csvString += canvasWidget.toCsv()
                }
            }
            csvString += "\n"
        }

        if csvString != "" {
            csvString.remove(at: csvString.index(before: csvString.endIndex))
        }
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = Section(position: Int(position), title: title)
        let widgetArray = self.sortedWidgetsArray()
        
        for widget in widgetArray {
            let widgetType = WidgetType(rawValue: widget.type!)
            switch widgetType {
            case .textFieldWidget:
                if let widget = widget as? TextFieldWidget {
                    let widgetCopy = widget.createCopy() as! TextFieldWidget
                    copy.addToWidgets(widgetCopy)
                }
            case .numberFieldWidget:
                if let widget = widget as? NumberFieldWidget {
                    let widgetCopy = widget.createCopy() as! NumberFieldWidget
                    copy.addToWidgets(widgetCopy)
                }
            case .dropdownSectionWidget:
                if let widget = widget as? DropdownSectionWidget {
                    let widgetCopy = widget.createCopy() as! DropdownSectionWidget
                    copy.addToWidgets(widgetCopy)
                }
            case .dropdownWidget:
                break
            case .checkboxSectionWidget:
                if let widget = widget as? CheckboxSectionWidget {
                    let widgetCopy = widget.createCopy() as! CheckboxSectionWidget
                    copy.addToWidgets(widgetCopy)
                }
            case .checkboxWidget:
                break
            case .mapWidget:
                if let widget = widget as? MapWidget {
                    let widgetCopy = widget.createCopy() as! MapWidget
                    copy.addToWidgets(widgetCopy)
                }
            case .canvasWidget:
                if let widget = widget as? CanvasWidget {
                    let widgetCopy = widget.createCopy() as! CanvasWidget
                    copy.addToWidgets(widgetCopy)
                }
            default:
                break
            }
        }
        return copy
    }
}
