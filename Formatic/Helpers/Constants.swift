//
//  Constants.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/25/22.
//

import Foundation

struct Constants {
    static let appID = "1643318765"

    static let stackSpacingConstant: CGFloat = 8
    
    static let sortDescriptorDateCreated = "dateCreated"
    static let sortDescriptorTitle = "title"
    
    static let predicateTrue = "true"
    static let predicateFalse = "false"
    static let predicateFormEqualTo = "form == %@"
    static let predicateSectionEqualTo = "section == %@"
    static let predicateDropdownSectionWidgetEqualTo = "dropdownSectionWidget == %@"
    static let predicateCheckboxSectionWidgetEqualTo = "checkboxSectionWidget == %@"
    static let predicateMapWidgetEqualTo = "mapWidget == %@"
    static let predicateRecentlyDeletedEqualTo = "recentlyDeleted == %@"
    static let predicateRecentlyDeletedEqualToFalse = "recentlyDeleted == false"
    static let predicateRecentlyDeletedEqualToTrue = "recentlyDeleted == true"
    static let predicateTitleContainsAndRecentlyDeletedEqualTo = "title CONTAINS[cd] %@ AND \(Constants.predicateRecentlyDeletedEqualTo)"
    
    static let logoIconName = "doc.plaintext"
    static let fileIconName = "doc.text"
    static let formsIconName = "doc.on.doc"
    static let settingsIconName = "gearshape"
    static let trashIconName = "trash"
    static let copyIconName = "doc.on.doc"
    static let plusIconName = "plus"
    static let circleIconName = "circle"
    static let plusCircleIconName = "plus.circle"
    static let importFormIconName = "square.and.arrow.down"
    static let exportFormIconName = "square.and.arrow.up"
    static let exportMultipleFormsIconName = "square.and.arrow.up.on.square"
    static let docZipperIconName = "doc.zipper"
    static let docTextImageIconName = "doc.text.image"
    static let csvTableIconName = "tablecells"
    static let lockIconName = "lock"
    static let openLockIconName = "lock.open"
    static let editIconName = "slider.horizontal.3"
    static let checkmarkIconName = "checkmark"
    static let filledSquareCheckmarkIconName = "checkmark.square.fill"
    static let filledCircleCheckmarkIconName = "checkmark.circle.fill"
    static let squareIconName = "square"
    static let scopeIconName = "scope"
    static let photoFrameIconName = "photo.on.rectangle.angled"
    static let cameraIconName = "camera"
    static let mapPinIconName = "mappin.circle.fill"
    static let sortIconName = "line.3.horizontal.decrease.circle"
    static let expandListIconName = "chevron.right"
    static let moveSectionIconName = "arrow.up.arrow.down"
    static let forwardArrowIconName = "arrow.forward"
    static let moveWidgetIconName = "line.3.horizontal"
    static let dollarSignIconName = "dollarsign.circle"
    static let dollarSignFilledIconName = "dollarsign.circle.fill"
    static let tutorialIconName = "graduationcap.fill"
    static let supportFilledIconName = "questionmark.bubble.fill"
    static let supportIconName = "questionmark.bubble"
    static let starFilledIconName = "star.fill"
    
    static let logoAnimationFileName = "logoAnimation"
    static let formContainerFileName = "Form Container"
    
    static let analyticsCreateFormEvent = "createFormEvent"
    static let analyticsImportFormEvent = "analyticsImportFormEvent"
    static let analyticsCopyFormEvent = "analyticsCopyFormEvent"
    static let analyticsDeleteFormEvent = "analyticsDeleteFormEvent"
    static let analyticsCreateLockFormEvent = "analyticsLockFormEvent"
    static let analyticsUnlockFormEvent = "analyticsUnlockFormEvent"
    static let analyticsRemoveLockFormEvent = "analyticsRemoveLockFormEvent"
    static let analyticsCreateSectionEvent = "analyticsCreateSectionEvent"
    static let analyticsExportFormEvent = "analyticsExportFormEvent"
    static let analyticsExportPDFEvent = "analyticsExportPDFEvent"
    static let analyticsExportCSVEvent = "analyticsExportCSVEvent"
    static let analyticsCreateTextFieldWidgetEvent = "analyticsCreateTextFieldWidgetEvent"
    static let analyticsCreateNumberFieldWidgetEvent = "analyticsCreateNumberFieldWidgetEvent"
    static let analyticsCreateDateFieldWidgetEvent = "analyticsCreateDateFieldWidgetEvent"
    static let analyticsCreateSliderWidgetEvent = "analyticsCreateSliderWidgetEvent"
    static let analyticsCreateDropdownWidgetEvent = "analyticsCreateDropdownWidgetEvent"
    static let analyticsCreateCheckboxWidgetEvent = "analyticsCreateCheckboxWidgetEvent"
    static let analyticsCreateMapWidgetEvent = "analyticsCreateMapWidgetEvent"
    static let analyticsCreateCanvasWidgetEvenet = "analyticsCreateCanvasWidgetEvenet"
    static let analyticsCopyWidgetEvent = "analyticsCopyWidgetEvent"
    static let analyticsDeleteWidgetEvent = "analyticsDeleteWidgetEvent"
}
