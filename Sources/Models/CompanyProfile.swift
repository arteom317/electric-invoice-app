import Foundation
import SwiftData

@Model
final class CompanyProfile {
    var id: UUID
    var companyName: String
    var cui: String
    var regCom: String
    var address: String
    var phone: String
    var email: String
    var iban: String
    var vatRate: Double // Procent TVA
    var currency: String // RON, EUR
    var logoData: Data?
    
    init(id: UUID = UUID(), companyName: String = "", cui: String = "", regCom: String = "", 
         address: String = "", phone: String = "", email: String = "", iban: String = "",
         vatRate: Double = 19.0, currency: String = "RON", logoData: Data? = nil) {
        self.id = id
        self.companyName = companyName
        self.cui = cui
        self.regCom = regCom
        self.address = address
        self.phone = phone
        self.email = email
        self.iban = iban
        self.vatRate = vatRate
        self.currency = currency
        self.logoData = logoData
    }
}
