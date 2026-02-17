import Foundation
import PDFKit
import SwiftUI

class PDFGenerator {
    static func generateInvoicePDF(invoice: Invoice, companyProfile: CompanyProfile) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "ElectricBill Pro",
            kCGPDFContextAuthor: companyProfile.companyName,
            kCGPDFContextTitle: "Factură \(invoice.invoiceNumber)"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            var yPosition: CGFloat = 50
            let margin: CGFloat = 50
            let contentWidth = pageRect.width - (margin * 2)
            
            // Header - Company Info
            let headerFont = UIFont.boldSystemFont(ofSize: 18)
            let regularFont = UIFont.systemFont(ofSize: 11)
            let boldFont = UIFont.boldSystemFont(ofSize: 11)
            
            drawText(companyProfile.companyName, at: CGPoint(x: margin, y: yPosition), 
                    font: headerFont, in: context)
            yPosition += 25
            
            drawText("CUI: \(companyProfile.cui)", at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 15
            drawText("Nr. Reg. Com.: \(companyProfile.regCom)", at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 15
            drawText("Adresă: \(companyProfile.address)", at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 15
            drawText("Tel: \(companyProfile.phone) | Email: \(companyProfile.email)", 
                    at: CGPoint(x: margin, y: yPosition), font: regularFont, in: context)
            yPosition += 15
            drawText("IBAN: \(companyProfile.iban)", at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 30
            
            // Invoice Title
            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            drawText("FACTURĂ", at: CGPoint(x: margin, y: yPosition), font: titleFont, in: context)
            yPosition += 25
            
            drawText("Număr: \(invoice.invoiceNumber)", at: CGPoint(x: margin, y: yPosition), 
                    font: boldFont, in: context)
            drawText("Data: \(invoice.dateIssued.formatted())", 
                    at: CGPoint(x: pageRect.width - margin - 150, y: yPosition), 
                    font: boldFont, in: context)
            yPosition += 25
            
            // Client Info
            drawText("Client:", at: CGPoint(x: margin, y: yPosition), font: boldFont, in: context)
            yPosition += 15
            drawText(invoice.clientName, at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 15
            if let cui = invoice.clientCui, !cui.isEmpty {
                drawText("CUI: \(cui)", at: CGPoint(x: margin, y: yPosition), 
                        font: regularFont, in: context)
                yPosition += 15
            }
            drawText("Adresă: \(invoice.clientAddress)", at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 15
            drawText("Tel: \(invoice.clientPhone)", at: CGPoint(x: margin, y: yPosition), 
                    font: regularFont, in: context)
            yPosition += 25
            
            // Materials Table
            if !invoice.materials.isEmpty {
                drawText("MATERIALE", at: CGPoint(x: margin, y: yPosition), 
                        font: boldFont, in: context)
                yPosition += 20
                
                // Table header
                drawTableHeader(at: yPosition, margin: margin, contentWidth: contentWidth, 
                              in: context, font: boldFont)
                yPosition += 20
                
                // Table rows
                for (index, material) in invoice.materials.enumerated() {
                    yPosition = drawMaterialRow(index: index + 1, material: material, 
                                               at: yPosition, margin: margin, 
                                               contentWidth: contentWidth, currency: companyProfile.currency,
                                               in: context, font: regularFont)
                }
                
                yPosition += 10
                drawText("Subtotal Materiale: \(invoice.subtotalMaterials.toCurrency(currency: companyProfile.currency))", 
                        at: CGPoint(x: pageRect.width - margin - 150, y: yPosition), 
                        font: boldFont, in: context)
                yPosition += 25
            }
            
            // Labor Table
            if !invoice.laborItems.isEmpty {
                drawText("MANOPERĂ", at: CGPoint(x: margin, y: yPosition), 
                        font: boldFont, in: context)
                yPosition += 20
                
                // Table header
                drawTableHeader(at: yPosition, margin: margin, contentWidth: contentWidth, 
                              in: context, font: boldFont)
                yPosition += 20
                
                // Table rows
                for (index, labor) in invoice.laborItems.enumerated() {
                    yPosition = drawLaborRow(index: index + 1, labor: labor, 
                                           at: yPosition, margin: margin, 
                                           contentWidth: contentWidth, currency: companyProfile.currency,
                                           in: context, font: regularFont)
                }
                
                yPosition += 10
                drawText("Subtotal Manoperă: \(invoice.subtotalLabor.toCurrency(currency: companyProfile.currency))", 
                        at: CGPoint(x: pageRect.width - margin - 150, y: yPosition), 
                        font: boldFont, in: context)
                yPosition += 25
            }
            
            // Totals
            drawText("Total fără TVA: \(invoice.totalWithoutVAT.toCurrency(currency: companyProfile.currency))", 
                    at: CGPoint(x: pageRect.width - margin - 200, y: yPosition), 
                    font: boldFont, in: context)
            yPosition += 20
            drawText("TVA \(String(format: "%.0f", invoice.vatRate))%: \(invoice.vatAmount.toCurrency(currency: companyProfile.currency))", 
                    at: CGPoint(x: pageRect.width - margin - 200, y: yPosition), 
                    font: boldFont, in: context)
            yPosition += 20
            drawText("TOTAL CU TVA: \(invoice.totalWithVAT.toCurrency(currency: companyProfile.currency))", 
                    at: CGPoint(x: pageRect.width - margin - 200, y: yPosition), 
                    font: titleFont, in: context)
            
            // Notes
            if !invoice.notes.isEmpty {
                yPosition += 30
                drawText("Observații:", at: CGPoint(x: margin, y: yPosition), 
                        font: boldFont, in: context)
                yPosition += 15
                drawText(invoice.notes, at: CGPoint(x: margin, y: yPosition), 
                        font: regularFont, in: context)
            }
        }
        
        return data
    }
    
    private static func drawText(_ text: String, at point: CGPoint, font: UIFont, 
                                 in context: UIGraphicsPDFRendererContext) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        text.draw(at: point, withAttributes: attributes)
    }
    
    private static func drawTableHeader(at yPosition: CGFloat, margin: CGFloat, 
                                       contentWidth: CGFloat, 
                                       in context: UIGraphicsPDFRendererContext, 
                                       font: UIFont) {
        let col1Width = contentWidth * 0.1
        let col2Width = contentWidth * 0.45
        let col3Width = contentWidth * 0.1
        let col4Width = contentWidth * 0.15
        let col5Width = contentWidth * 0.2
        
        drawText("Nr.", at: CGPoint(x: margin, y: yPosition), font: font, in: context)
        drawText("Denumire", at: CGPoint(x: margin + col1Width, y: yPosition), 
                font: font, in: context)
        drawText("UM", at: CGPoint(x: margin + col1Width + col2Width, y: yPosition), 
                font: font, in: context)
        drawText("Cant.", at: CGPoint(x: margin + col1Width + col2Width + col3Width, y: yPosition), 
                font: font, in: context)
        drawText("Preț unitar", at: CGPoint(x: margin + col1Width + col2Width + col3Width + col4Width, y: yPosition), 
                font: font, in: context)
    }
    
    private static func drawMaterialRow(index: Int, material: InvoiceMaterialItem, 
                                       at yPosition: CGFloat, margin: CGFloat, 
                                       contentWidth: CGFloat, currency: String,
                                       in context: UIGraphicsPDFRendererContext, 
                                       font: UIFont) -> CGFloat {
        let col1Width = contentWidth * 0.1
        let col2Width = contentWidth * 0.45
        let col3Width = contentWidth * 0.1
        let col4Width = contentWidth * 0.15
        
        drawText("\(index)", at: CGPoint(x: margin, y: yPosition), font: font, in: context)
        drawText(material.materialName, at: CGPoint(x: margin + col1Width, y: yPosition), 
                font: font, in: context)
        drawText(material.unit, at: CGPoint(x: margin + col1Width + col2Width, y: yPosition), 
                font: font, in: context)
        drawText(String(format: "%.2f", material.quantity), 
                at: CGPoint(x: margin + col1Width + col2Width + col3Width, y: yPosition), 
                font: font, in: context)
        drawText(material.unitPrice.toCurrency(currency: currency), 
                at: CGPoint(x: margin + col1Width + col2Width + col3Width + col4Width, y: yPosition), 
                font: font, in: context)
        
        return yPosition + 20
    }
    
    private static func drawLaborRow(index: Int, labor: InvoiceLaborItem, 
                                    at yPosition: CGFloat, margin: CGFloat, 
                                    contentWidth: CGFloat, currency: String,
                                    in context: UIGraphicsPDFRendererContext, 
                                    font: UIFont) -> CGFloat {
        let col1Width = contentWidth * 0.1
        let col2Width = contentWidth * 0.45
        let col3Width = contentWidth * 0.1
        let col4Width = contentWidth * 0.15
        
        drawText("\(index)", at: CGPoint(x: margin, y: yPosition), font: font, in: context)
        drawText(labor.description, at: CGPoint(x: margin + col1Width, y: yPosition), 
                font: font, in: context)
        drawText(labor.unit, at: CGPoint(x: margin + col1Width + col2Width, y: yPosition), 
                font: font, in: context)
        drawText(String(format: "%.2f", labor.quantity), 
                at: CGPoint(x: margin + col1Width + col2Width + col3Width, y: yPosition), 
                font: font, in: context)
        drawText(labor.rate.toCurrency(currency: currency), 
                at: CGPoint(x: margin + col1Width + col2Width + col3Width + col4Width, y: yPosition), 
                font: font, in: context)
        
        return yPosition + 20
    }
}
