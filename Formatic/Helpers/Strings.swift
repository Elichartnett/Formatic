//
//  Strings.swift
//  Formatic
//
//  Created by Eli Hartnett on 10/13/22.
//

import Foundation

struct Strings {
    
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
    static let formPasswordDoesNotMatchErrorMessage = String(localized: "formPasswordDoesNotMatchErrorMessage")
    static let importCanvasErrorMessage = String(localized: "importCanvasErrorMessage")
    static let noSearchResultsMessage = String(localized: "noSearchResultsMessage")
    static let noFormDataErrorMessage = String(localized: "noFormDataErrorMessage")
    
    static let formLabel = String(localized: "formLabel")
    static let formsLabel = String(localized: "formsLabel")
    static let formTitleLabel = String(localized: "formTitleLabel")
    static let formUntitledLabel = String(localized: "untitledLabel")
    static let sectionTitleLabel = String(localized: "sectionTitleLabel")
    static let titleLabel = String(localized: "titleLabel")
    static let newFormLabel = String(localized: "newFormLabel")
    static let newSectionLabel = String(localized: "newSectionLabel")
    static let newWidgetLabel = String(localized: "newWidgetLabel")
    
    static let deleteLabel = String(localized: "deleteLabel")
    static let copyLabel = String(localized: "copyLabel")
    static let resetLabel = String(localized: "resetLabel")
    static let recoverLabel = String(localized: "recoverLabel")
    static let importLabel = String(localized: "importLabel")
    static let importCount = String(localized: "importCount")
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
    static let sortLabel = String(localized: "sortLabel")
    static let moveLabel = String(localized: "moveLabel")
    
    static let settingsLabel = String(localized: "settingsLabel")
    static let numberForms = String(localized: "numberForms")
    static let formaticFeedbackLabel = "Formatic Feedback"
    static let emailAddress = "eli@elihartnett.com"
    static let failedToOpenEmailURLErrorMessage = String(localized: "failedToOpenEmailURLErrorMessage") + emailAddress + "."
    static let failedToCreateEmailURLErrorMessage = String(localized: "failedToCreateEmailURLErrorMessage") + emailAddress + "."
    static let failedToSendEmailErrorMessage = String(localized: "failedToSendEmailErrorMessage") + emailAddress + "."
    static let writeAReviewLabel = String(localized: "writeAReviewLabel")
    static let copyAddressLabel = String(localized: "copyAddressLabel")
    static let versionLabel = String(localized: "versionLabel")
    static let submitFeedbackLabel = String(localized: "submitFeedback")
    static let recentlyDeletedFormsLabel = String(localized: "recentlyDeletedFormsLabel")
    static let tryAgainLabel = String(localized: "tryAgainLabel")
    
    static let inAppPurchasesLabel = String(localized: "inAppPurchasesLabel")
    static let failedToLoadPurchasesErrorMessage = String(localized: "failedToLoadPurchasesErrorMessage")
    static let failedToPurchaseErrorMessage = String(localized: "failedToPurchaseErrorMessage")
    static let restorePurchasesLabel = String(localized: "restorePurchasesLabel")
    static let purchasesRestored = String(localized: "purchasesRestored")
    static let formaticFileLabel = String(localized: "formaticFileLabel")
    static let failedToCreateMapAnnotationErrorMessage = String(localized: "failedToCreateMapAnnotationErrorMessage")
    static let lockFormsLabel = String(localized: "lockFormsLabel")
    static let importExportFormaticLabel = String(localized: "importExportFormaticLabel")
    static let exportPdfLabel = String(localized: "exportPdfLabel")
    static let exportCsvLabel = String(localized: "exportCsvLabel")
    static let proLabel = String(localized: "proLabel")
    
    static let textFieldLabel = String(localized: "textFieldLabel")
    static let textLabel = String(localized: "textLabel")
    
    static let numberFieldLabel = String(localized: "numberFieldLabel")
    static let numberLabel = String(localized: "numberLabel")
    
    static let dateFieldLabel = String(localized: "dateFieldLabel")
    static let valueLabel = String(localized: "valueLabel")
    static let lowerBoundLabel = String(localized: "lowerBoundLabel")
    static let upperBoundLabel = String(localized: "upperBoundLabel")
    static let stepLabel = String(localized: "stepLabel")
    
    static let sliderLabel = String(localized: "sliderLabel")
    
    static let dropdownMenuLabel = String(localized: "dropdownMenuLabel")
    static let numberOfDropdownOptionsLabel = String(localized: "numberOfDropdownOptionsLabel")
    
    static let checkboxMenuLabel = String(localized: "checkboxMenuLabel")
    static let checkedLabel = String(localized: "checked")
    static let uncheckedLabel = String(localized: "unchecked")
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
    
    static let tutorial = String(localized: "tutorial")
    static let tutorialWelcomeLabel = String(localized: "Welcome to Formatic")
    static let tutorialIntroLabel = String(localized: "tutorialIntroLabel")
    static let tutorialSkipLabel = String(localized: "tutorialSkipLabel")
    static let tutorialNextLabel = String(localized: "tutorialNextLabel")
    static let tutorialCompleteLabel = String(localized: "tutorialCompleteLabel")

    static let tutorialIconsLabel = String(localized: "tutorialIconsLabel")
    static let tutorialCreateLabel = String(localized: "tutorialCreateLabel")
    static let tutorialImportLabel = String(localized: "tutorialImportLabel")
    static let tutorialExportLabel = String(localized: "tutorialExportLabel")
    static let tutorialLockLabel = String(localized: "tutorialLockLabel")
    static let tutorialSortLabel = String(localized: "tutorialSortLabel")
    static let tutorialEditLabel = String(localized: "tutorialEditLabel")
    static let tutorialSectionOrderLabel = String(localized: "tutorialSectionOrderLabel")
    static let tutorialFieldOrderLabel = String(localized: "tutorialFieldOrderLabel")
    static let tutorialTipsLabel = String(localized: "tutorialTipsLabel")
    static let tutorialTip1Label = String(localized: "tutorialTip1Label")
    static let tutorialTip2Label = String(localized: "tutorialTip2Label")
    static let tutorialTip3Label = String(localized: "tutorialTip3Label")
    static let tutorialTip4Label = String(localized: "tutorialTip4Label")
    static let tutorialTip5Label = String(localized: "tutorialTip5Label")
    static let tutorialTip6Label = String(localized: "tutorialTip6Label")
}
