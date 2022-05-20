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
            throw FormError.encodeFormToJsonDataError
        }
    }
    
    func decodeJsonDataToForm(data: Data) throws -> Form {
        let decoder = JSONDecoder()
        do {
            let form = try decoder.decode(Form.self, from: data)
            return form
        }
        catch {
            throw FormError.decodeJsonDataToFormError
        }
    }
    
    func importForm(url: URL) throws {
        do {
            let data = try urlToData(url: url)
            do {
                let newForm = try decodeJsonDataToForm(data: data)
                do {
                    let forms = try getForms()
                    if forms.contains(where: { form in
                        form.title == newForm.title && form.id != newForm.id
                    })
                    {
                        resolveDuplicateFormName(newForm: newForm, forms: forms)
                    }
                    DataController.saveMOC()
                }
                catch {
                    throw FormError.fetchError
                }
            }
            catch {
                throw FormError.decodeJsonDataToFormError
            }
        }
        catch {
            throw FormError.urlToDataError
        }
        DataController.saveMOC()
    }
    
    func getForms() throws -> [Form] {
        let formsRequest: NSFetchRequest<Form> = Form.fetchRequest()
        do {
            let forms = try DataController.shared.container.viewContext.fetch(formsRequest)
            return forms
        }
        catch {
            throw FormError.fetchError
        }
    }
    
    func urlToData(url: URL) throws -> Data {
        var data = Data()
        do {
            data = try Data(contentsOf: url)
            return data
        }
        catch {
            throw FormError.urlToDataError
        }
    }
    
    func resolveDuplicateFormName(newForm: Form, forms: [Form]) {
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
    
    func deleteFormWithIndexSet(indexSet: IndexSet) throws {
        do {
            let forms = try getForms()
            for index in indexSet {
                let form = forms[index]
                DataController.shared.container.viewContext.delete(form)
                
                for index in index..<forms.count {
                    forms[index].position = forms[index].position - 1
                }
            }
            DataController.saveMOC()
        }
        catch {
            throw FormError.fetchError
        }
    }
}
