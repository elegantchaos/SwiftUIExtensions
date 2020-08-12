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
    let footerFont: Font
    let labelFont: Font
    
    public init(headerFont: Font = .headline, footerFont: Font = .footnote, labelFont: Font = .body) {
        self.headerFont = headerFont
        self.footerFont = footerFont
        self.labelFont = labelFont
    }
}


public struct FormSection<Content>: View where Content: View {
    @EnvironmentObject var style: FormStyle

    let header: String
    let footer: String
    let content: () -> Content
    
    public init(header: String, footer: String, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
    
    public var body: some View {
        Section(
            header: Text(header).font(style.headerFont),
            footer: Text(footer).font(style.footerFont)
                .padding(.bottom, 20)
        ) {
            content()
        }
    }
}

public struct FormRow<Content, Style>: View where Content: View, Style: ViewModifier {
    let label: String
    let style: Style
    let alignment: VerticalAlignment
    let content: () -> Content
    
    public init(label: String, alignment: VerticalAlignment = .center, style: Style, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.style = style
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        HStack(alignment: alignment) {
            AlignedLabel(label)
            content()
                .modifier(style)
        }
    }
}

public struct FormPickerRow<Variable, Style>: View where Variable: Labelled, Style: ViewModifier {
    let label: String
    let variable: Binding<Variable>
    let cases: [Variable]
    let style: Style
    
    public init(label: String, variable: Binding<Variable>, cases: [Variable], style: Style) {
        self.label = label
        self.variable = variable
        self.cases = cases
        self.style = style
    }
    
    public var body: some View {
        return FormRow(label: label, style: style) {
            Picker(variable.wrappedValue.label, selection: variable) {
                ForEach(cases, id: \.self) { rate in
                    Text(rate.label)
                }
            }
            .setPickerStyle()
        }
    }
}

public struct StyledFormFieldRow<Style>: View where Style: ViewModifier {
    let label: String
    let proto: String
    let variable: Binding<String>
    let clearButton: Bool
    let style: Style
    
    public init(label: String, proto: String? = nil, variable: Binding<String>, style: Style, clearButton: Bool = false) {
        self.label = label
        self.variable = variable
        self.style = style
        self.proto = proto ?? label
        self.clearButton = clearButton
    }

    public var body: some View {
        FormRow(label: label, style: style) {
            if clearButton {
                TextField(proto, text: variable)
                    .modifier(ClearButton(text: variable))
            } else {
                TextField(proto, text: variable)
            }
        }
    }
}

public struct FormToggleRow<Style>: View where Style: ViewModifier {
    let label: String
    let variable: Binding<Bool>
    let style: Style
    
    public init(label: String, variable: Binding<Bool>, style: Style) {
        self.label = label
        self.variable = variable
        self.style = style
    }
    public var body: some View {
        FormRow(label: label, style: style) {
            HStack {
                Toggle("", isOn: variable)
                    .labelsHidden()
                    .background(Color.green)
                Spacer()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
            }
            .frame(maxWidth: .infinity)
            .background(Color.red)

        }
    }
}

public struct DefaultFormFieldStyle : ViewModifier {
    public init(contentType: UITextContentType? = nil, autocapitalization: UITextAutocapitalizationType = .none, disableAutocorrection: Bool = true, keyboardType: UIKeyboardType = .default, clearButton: Bool = false) {
        self.contentType = contentType
        self.autocapitalization = autocapitalization
        self.disableAutocorrection = disableAutocorrection
        self.keyboardType = keyboardType
    }
    
    let contentType: UITextContentType?
    let autocapitalization: UITextAutocapitalizationType
    let disableAutocorrection: Bool
    let keyboardType: UIKeyboardType

    
    public func body(content: Content) -> some View {
        content
            .textContentType(contentType)
            .autocapitalization(autocapitalization)
            .disableAutocorrection(disableAutocorrection)
            .keyboardType(keyboardType)
            .padding(4.0)
            .background(
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundColor(Color(white: 0.3, opacity: 0.1))
            )
    }
}

public struct ClearFormRowStyle: ViewModifier {
    public init() {
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(4.0)
    }
}
