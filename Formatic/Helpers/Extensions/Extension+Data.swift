//
//  Extension+Data.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import FirebaseAnalytics

extension Data {
    func decodeToForm() throws {
        let decoder = JSONDecoder()
        do {
            let _ = try decoder.decode(Form.self, from: self)
            Analytics.logEvent(Constants.analyticsImportFormEvent, parameters: nil)
        }
        catch {
            throw FormError.decodeJsonDataToFormError
        }
    }
}
