//
//  Strings.swift
//  Formatic
//
//  Created by Eli Hartnett on 10/13/22.
//

import Foundation

struct Strings {
    static let sortMethodUserDefaultsKey = "sortMethod"
    
    static let baseCSVColumns = String(localized: "baseCSVColumns")
    static let mapCSVColumns = String(localized: "mapCSVColumns")
    static let getStartedMessage = String(localized: "getStartedMessage")
    static let dateCreatedLabel = String(localized: "dateCreatedLabel")
    static let alphabeticalyLabel = String(localized: "alphabeticalLabel")
    static let defaultAlertButtonDismissMessage = String(localized: "defaultAlertButtonDismissMessage")
    
    static let loadFormsErrorMessage = String(localized: "loadFormsErrorMessage")
    static let saveFormErrorMessage = String(localized: "saveFormErrorMessage")
    static let deleteFormErrorMessage = String(localized: "deleteFormErrorMessage")
    static let copyFormErrorMessage = String(localized: "copyFormErrorMessage")
    static let importFormErrorMessage = String(localized: "importFormErrorMessage")
    static let exportFormErrorMessage = String(localized: "exportFormErrorMessage")
    static let emptyFormTitleErrorMessage = String(localized: "emptyFormTitleErrorMessage")
    static let formTitleValidationErrorMessage = String(localized: "formTitleValidationErrorMessage")
    static let formTitleAlreadyInUseErrorMessage = String(localized: "formTitleAlreadyInUseErrorMessage")
    static let formTitleInRecentlyDeletedErrorMessage = String(localized: "formTitleInRecentlyDeletedErrorMessage")
    static let formPasswordDoesNotMatchErrorMessage = String(localized: "formPasswordDoesNotMatchErrorMessage")
    static let importCanvasErrorMessage = String(localized: "importCanvasErrorMessage")
    static let updateCanvasWidgetViewPreviewErrorMessage = String(localized: "updateCanvasWidgetViewPreviewErrorMessage")
    static let noSearchResultsMessage = String(localized: "noSearchResultsMessage")
    static let noFormDataErrorMessage = String(localized: "noFormDataErrorMessage")
    
    static let formLabel = String(localized: "formLabel")
    static let formTitleLabel = String(localized: "formTitleLabel")
    static let sectionTitleLabel = String(localized: "sectionTitleLabel")
    static let titleLabel = String(localized: "titleLabel")
    static let newSectionLabel = String(localized: "newSectionLabel")
    static let newFormLabel = String(localized: "newFormLabel")
    
    static let deleteLabel = String(localized: "deleteLabel")
    static let copyLabel = String(localized: "copyLabel")
    static let recoverLabel = String(localized: "recoverLabel")
    static let importLabel = String(localized: "importLabel")
    static let doneLabel = String(localized: "doneLabel")
    static let editLabel = String(localized: "editLabel")
    static let submitLabel = String(localized: "submitLabel")
    static let exportLabel = String(localized: "exportLabel")
    static let generatePDFLabel = String(localized: "generatePDFLabel")
    static let generateCSVLabel = String(localized: "generateCSVLabel")
    
    static let passwordLabel = String(localized: "passwordLabel")
    static let setupLockLabel = String(localized: "setupLockLabel")
    static let removeLockLabel = String(localized: "removeLockLabel")
    static let lockedLabel = String(localized: "lockedLabel")
    static let unlockLabel = String(localized: "unlockLabel")
    static let unlockedLabel = String(localized: "unlockedLabel")
    static let optionalFormPasswordLabel = String(localized: "optionalFormPasswordLabel")
    static let retypeFormPasswordLabel = String(localized: "retypeFormPasswordLabel")
    static let sortMethodLabel = String(localized: "sortMethodLabel")
    
    static let settingsLabel = String(localized: "settingsLabel")
    static let formaticFeedbackLabel = "Formatic Feedback"
    static let emailAddress = "eli@elihartnett.com"
    static let failedToOpenEmailURLErrorMessage = String(localized: "failedToOpenEmailURLErrorMessage") + emailAddress + "."
    static let failedToCreateEmailURLErrorMessage = String(localized: "failedToCreateEmailURLErrorMessage") + emailAddress + "."
    static let failedToSendEmailErrorMessage = String(localized: "failedToSendEmailErrorMessage") + emailAddress + "."
    static let copyAddressLabel = String(localized: "copyAddressLabel")
    static let versionLabel = String(localized: "versionLabel")
    static let submitFeedbackLabel = String(localized: "submitFeedback")
    static let recentlyDeletedFormsLabel = String(localized: "recentlyDeletedFormsLabel")
    
    static let textFieldLabel = String(localized: "textFieldLabel")
    static let textLabel = String(localized: "textLabel")
    
    static let numberFieldLabel = String(localized: "numberFieldLabel")
    static let numberLabel = String(localized: "numberLabel")
        
    static let dropdownMenuLabel = String(localized: "dropdownMenuLabel")
    static let numberOfDropdownOptionsLabel = String(localized: "numberOfDropdownOptionsLabel")
    
    static let checkboxMenuLabel = String(localized: "checkboxMenuLabel")
    static let noSelectionLabel = String(localized: "noSelectionLabel")
    static let numberOfCheckboxesLabel = String(localized: "numberOfCheckboxesLabel")
    static let descriptionLabel = String(localized: "descriptionLabel")
    static let trueLabel = String(localized: "trueLabel")
    static let falseLabel = String(localized: "falseLabel")
    
    static let mapLabel = String(localized: "mapLabel")
    static let coordinateTypePickerLabel = String(localized: "coordinateTypePickerLabel")
    static let latitudeLabel = String(localized: "latitudeLabel")
    static let longitudeLabel = String(localized: "longitudeLabel")
    static let eastingLabel = String(localized: "eastingLabel")
    static let northingLabel = String(localized: "northingLabel")
    static let zoneLabel = String(localized: "zoneLabel")
    static let hemisphereLabel = String(localized: "hemisphereLabel")
    static let northernLabel = String(localized: "northernLabel")
    static let southernLabel = String(localized: "southernLabel")
    static let addPinLabel = String(localized: "addPinLabel")
    
    static let canvasLabel = String(localized: "canvasLabel")
    static let selectPhotoLabel = String(localized: "selectPhotoLabel")
    static let takePhotoLabel = String(localized: "takePhotoLabel")
    
    static let formsIconName = "doc.on.doc"
    static let settingsIconName = "gearshape"
    static let trashIconName = "trash"
    static let copyIconName = "doc.on.doc"
    static let plusIconName = "plus"
    static let plusCircleIconName = "plus.circle"
    static let importFormIconName = "square.and.arrow.down"
    static let exportFormIconName = "square.and.arrow.up"
    static let docZipperIconName = "doc.zipper"
    static let docTextImageIconName = "doc.text.image"
    static let csvTableIconName = "tablecells"
    static let lockIconName = "lock"
    static let openLockIconName = "lock.open"
    static let editIconName = "slider.horizontal.3"
    static let checkmarkIconName = "checkmark"
    static let filledCheckmarkIconName = "checkmark.square.fill"
    static let squareIconName = "square"
    static let scopeIconName = "scope"
    static let photoFrameIconName = "photo.on.rectangle.angled"
    static let cameraIconName = "camera"
    static let mapPinIconName = "mappin.circle.fill"
    static let sortIconName = "line.3.horizontal.decrease.circle"
    static let expandListIconName = "chevron.right"
    
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
    static let analyticsCreateDropdownWidgetEvent = "analyticsCreateDropdownWidgetEvent"
    static let analyticsCreateCheckboxWidgetEvent = "analyticsCreateCheckboxWidgetEvent"
    static let analyticsCreateMapWidgetEvent = "analyticsCreateMapWidgetEvent"
    static let analyticsCreateCanvasWidgetEvenet = "analyticsCreateCanvasWidgetEvenet"
    static let analyticsCopyWidgetEvent = "analyticsCopyWidgetEvent"
    static let analyticsDeleteWidgetEvent = "analyticsDeleteWidgetEvent"
}
