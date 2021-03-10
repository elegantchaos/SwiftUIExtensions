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
        #if !os(tvOS)
        if #available(iOS 14, macOS 11.0, tvOS 14, *) {
            return AnyView(self.pickerStyle(MenuPickerStyle()))
        }
        #endif
        
        return AnyView(self.pickerStyle(DefaultPickerStyle()))
    }
}

public class FormStyle: ObservableObject {
    public let headerFont: Font
    public let footerFont: Font
    public let labelFont: Font
    public let contentFont: Font
    public let rowPadding: CGFloat
    
    public init(headerFont: Font = .headline, footerFont: Font = .body, labelFont: Font = .body, contentFont: Font = .body, rowPadding: CGFloat = 4.0) {
        self.headerFont = headerFont
        self.footerFont = footerFont
        self.labelFont = labelFont
        self.contentFont = contentFont
        self.rowPadding = rowPadding
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
    @EnvironmentObject var formStyle: FormStyle

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
                .font(formStyle.labelFont)
            content()
                .font(formStyle.contentFont)
                .modifier(style)
        }
    }
}

public extension FormRow where Style == ClearFormRowStyle {
    init(label: String, alignment: VerticalAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.init(label: label, alignment: alignment, style: ClearFormRowStyle(), content: content)
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

public struct FormFieldRow<Style>: View where Style: ViewModifier {
    let label: String
    let placeholder: String
    let variable: Binding<String>
    let clearButton: Bool
    let style: Style
    
    public init(label: String, placeholder: String? = nil, variable: Binding<String>, style: Style, clearButton: Bool = false) {
        self.label = label
        self.variable = variable
        self.style = style
        self.placeholder = placeholder ?? label
        self.clearButton = clearButton
    }

    public var body: some View {
        FormRow(label: label, style: style) {
            if clearButton {
                TextField(placeholder, text: variable)
                    .modifier(ClearButton(text: variable))
            } else {
                TextField(placeholder, text: variable)
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
            Toggle("", isOn: variable)
                .labelsHidden()
        }
    }
}

#if canImport(UIKit)

@available(macOS 11.0, *) public extension FormFieldRow where Style == DefaultFormFieldStyle {
    // initialiser allowing you to miss out the style
    init(label: String, placeholder: String? = nil, variable: Binding<String>, clearButton: Bool = false) {
        self.init(label: label, placeholder: placeholder, variable: variable, style: DefaultFormFieldStyle(), clearButton: clearButton)
    }
}

@available(macOS 11.0, *) public struct DefaultFormFieldStyle : ViewModifier {
    @EnvironmentObject var style: FormStyle
    
    let contentType: UITextContentType?
    let autocapitalization: UITextAutocapitalizationType
    let disableAutocorrection: Bool
    let keyboardType: UIKeyboardType

    public init(contentType: UITextContentType? = nil, autocapitalization: UITextAutocapitalizationType = .none, disableAutocorrection: Bool = true, keyboardType: UIKeyboardType = .default, clearButton: Bool = false) {
        self.contentType = contentType
        self.autocapitalization = autocapitalization
        self.disableAutocorrection = disableAutocorrection
        self.keyboardType = keyboardType
    }

    public func body(content: Content) -> some View {

        content
            .textContentType(contentType)
            .autocapitalization(autocapitalization)
            .disableAutocorrection(disableAutocorrection)
            .keyboardType(keyboardType)
            .padding(style.rowPadding)
            .background(
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundColor(Color(white: 0.3, opacity: 0.1))
            )
    }
}

#endif

public struct ClearFormRowStyle: ViewModifier {
    @EnvironmentObject var style: FormStyle
    public init() {
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(style.rowPadding)
    }
}
