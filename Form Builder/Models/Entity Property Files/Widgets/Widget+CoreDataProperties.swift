//
//  Widget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData


extension Widget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Widget> {
        return NSFetchRequest<Widget>(entityName: "Widget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var section: Section?
    
    /// Widget convenience init
    convenience init (title: String?, entity: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: entity, in: DataController.shared.container.viewContext) ?? NSEntityDescription(), insertInto: DataController.shared.container.viewContext)
        self.id = UUID()
        self.title = title
        self.type = entity
    }
}

extension Widget : Identifiable {

}

enum WidgetType: String {
    case textFieldWidget = "TextFieldWidget"
    case numberFieldWidget = "NumberFieldWidget"
    case textEditorWidget = "TextEditorWidget"
    case dropdownSectionWidget = "DropdownSectionWidget"
    case checkboxSectionWidget = "CheckboxSectionWidget"
    case mapWidget = "MapWidget"
    case photoLibraryWidget = "PhotoLibraryWidget"
    case canvasWidget = "CanvasWidget"
    case unknown = "unknown"
}
