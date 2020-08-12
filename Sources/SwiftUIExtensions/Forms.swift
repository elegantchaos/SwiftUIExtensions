// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/08/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol Labelled: Hashable {
    var label: String { get }
}

extension View {
    func setPickerStyle() -> some View {
        if #available(iOS 14, *) {
            return AnyView(self.pickerStyle(MenuPickerStyle()))
        } else {
            return AnyView(self.pickerStyle(DefaultPickerStyle()))
        }
    }
}

public class FormStyle: ObservableObject {
    let headerFont: Font
    
    init(headerFont: Font) {
        self.headerFont = headerFont
    }
}


public struct FormSection<Content>: View where Content: View {
    let header: String
    let footer: String
    let font: Font
    let content: () -> Content
    
    public init(header: String, footer: String, font: Font, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.footer = footer
        self.font = font
        self.content = content
    }
    
    public var body: some View {
        Section(
            header: Text(header).font(font),
            footer: Text(footer)
                .padding(.bottom, 20)
        ) {
            content()
        }
    }
}


public struct FormRow<Content>: View where Content: View {
    let label: String
    let content: () -> Content
    
    public var body: some View {
        HStack {
            AlignedLabel(label)
            content()
                .padding(4.0)
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .foregroundColor(Color(white: 0.3, opacity: 0.1))
                )
        }
    }
}

public struct FormPickerRow<Variable>: View where Variable: Labelled {
    let label: String
    let variable: Binding<Variable>
    let cases: [Variable]

    public init(label: String, variable: Binding<Variable>, cases: [Variable]) {
        self.label = label
        self.variable = variable
        self.cases = cases
    }
    
    public var body: some View {
        return FormRow(label: label) {
            Picker(variable.wrappedValue.label, selection: variable) {
                ForEach(cases, id: \.self) { rate in
                    Text(rate.label)
                }
            }
            .setPickerStyle()
        }
    }
}

public struct FormFieldRow: View {
    let label: String
    let variable: Binding<String>
    let contentType: UITextContentType
    let autocapitalization: UITextAutocapitalizationType
    let disableAutocorrection: Bool
    
    public init(label: String, variable: Binding<String>, contentType: UITextContentType, autocapitalization: UITextAutocapitalizationType = .none, disableAutocorrection: Bool = true) {
        self.label = label
        self.variable = variable
        self.contentType = contentType
        self.autocapitalization = autocapitalization
        self.disableAutocorrection = disableAutocorrection
    }

    public var body: some View {
        FormRow(label: label) {
            TextField("user", text: variable)
                .textContentType(contentType)
                .autocapitalization(autocapitalization)
                .disableAutocorrection(disableAutocorrection)
        }
    }
}
