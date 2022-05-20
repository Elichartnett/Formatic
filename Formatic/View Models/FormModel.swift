//
//  FormModel.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation
import SwiftUI
import CoreData

class FormModel: ObservableObject {
    
    func validNumber(number: String, range: ClosedRange<Double>? = nil) -> Bool {
        // Check if field only contains nubmers
        if let number = Double(number) {
            // Check if number is in range
            if let range = range {
                if number >= range.lowerBound && number <= range.upperBound {
                    return true
                }
                else {
                    return false
                }
            }
            // Number is valid, but there is no range
            else {
                return true
            }
        }
        else {
            // Have only typed negative sign
            if number == "-" {
                return true
            }
            // Not a valid number
            return false
        }
    }
    
    func encodeFormToJsonData(form: Form) throws -> Data {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(form)
            return data
        }
        catch {
            throw SharingFormError.encodeFormToJsonDataError
        }
    }
    
    func decodeJsonDataToForm(data: Data) throws -> Form {
        let decoder = JSONDecoder()
        do {
            let form = try decoder.decode(Form.self, from: data)
            return form
        }
        catch {
            throw SharingFormError.decodeJsonDataToFormError
        }
    }
    
    func importForm(url: URL) throws {
        do {
            let data = try urlToData(url: url)
            do {
                let newForm = try decodeJsonDataToForm(data: data)
                let formsRequest: NSFetchRequest<Form> = Form.fetchRequest()
                let forms = try DataController.shared.container.viewContext.fetch(formsRequest)
                if forms.contains(where: { form in
                    form.title == newForm.title
                })
                {
                    var newTitleFound = false
                    var index = 1
                    while !newTitleFound {
                        let newTitle = "\(newForm.title ?? "") (\(index))"
                        if !forms.contains(where: { form in
                            form.title == newTitle
                        }) {
                            newTitleFound = true
                            newForm.title = newTitle
                        }
                        else {
                            index += 1
                        }
                    }
                }
            }
            catch {
                throw SharingFormError.decodeJsonDataToFormError
            }
        }
        catch {
            throw SharingFormError.urlToDataError
        }
        DataController.saveMOC()
    }
    
    func urlToData(url: URL) throws -> Data {
        var data = Data()
        do {
            data = try Data(contentsOf: url)
            return data
        }
        catch {
            throw SharingFormError.urlToDataError
        }
    }
}
