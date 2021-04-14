// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/08/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol Labelled: Hashable {
    var label: String { get }
}

@available(iOS 14, macOS 11.0, tvOS 14, *) public extension View {
    func bestFormPickerStyle() -> some View {
        #if targetEnvironment(macCatalyst)
                return self
                    .labelsHidden()
                    .pickerStyle(MenuPickerStyle())
        #elseif !os(tvOS)
            return self
                .pickerStyle(MenuPickerStyle())
        #else
            return self
                .pickerStyle(InlinePickerStyle())
        #endif
    }
}

public class FormStyle: ObservableObject {
    public let headerFont: Font
     public let headerOpacity: Double
     public let footerFont: Font
     public let footerOpacity: Double
     public let labelFont: Font
     public let labelOpacity: Double
     public let contentFont: Font
     public let contentOpacity: Double
     public let rowPadding: CGFloat
   
    public init(
         headerFont: Font = .headline, headerOpacity: Double = 1.0,
         footerFont: Font = .body, footerOpacity: Double = 1.0,
         labelFont: Font = .body, labelOpacity: Double = 0.8,
         contentFont: Font = .body, contentOpacity: Double = 1.0,
         rowPadding: CGFloat = 4.0
    ) {
         self.headerFont = headerFont
         self.headerOpacity = headerOpacity
         self.footerFont = footerFont
         self.footerOpacity = footerOpacity
         self.labelFont = labelFont
         self.labelOpacity = labelOpacity
         self.contentFont = contentFont
         self.contentOpacity = contentOpacity
         self.rowPadding = rowPadding
     }
}


public struct FormSection<Header,Footer,Content>: View where Content: View, Header: View, Footer: View {
    @EnvironmentObject var style: FormStyle

    let header: () -> Header
    let footer: () -> Footer
    let content: () -> Content

    public init(@ViewBuilder header: @escaping () -> Header, @ViewBuilder footer: @escaping () -> Footer, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }

    public init(header: String, footer: String, @ViewBuilder content: @escaping () -> Content) where Header == Text, Footer == FormDefaultFooter {
        self.header = { return Text(header) }
        self.footer = { return FormDefaultFooter(text: footer) }
        self.content = content
    }
    
    public var body: some View {
        Section(
            header:
                header()
                .font(style.headerFont),
            
            footer:
                footer()
                .font(style.footerFont),
            
            content: content
        )
    }
}

public struct FormDefaultHeader: View {
    @EnvironmentObject var style: FormStyle

    let text: String
    
    public var body: some View {
        Text(text)
            .font(style.headerFont)
    }
}

public struct FormDefaultFooter: View {
    @EnvironmentObject var style: FormStyle

    let text: String
    
    public var body: some View {
        HStack {
            Spacer()
            Text(text)
            .multilineTextAlignment(.trailing)
        }
    }
}

public struct FormRow<Content, Style>: View where Content: View, Style: ViewModifier {
    @EnvironmentObject var formStyle: FormStyle

    let label: String
    let style: Style
    let alignment: VerticalAlignment
    let content: () -> Content
    
    public init(label: String, alignment: VerticalAlignment = .firstTextBaseline, style: Style, @ViewBuilder content: @escaping () -> Content) {
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
        }
    }
}

extension FormPickerRow where Style == ClearFormRowStyle {
    public init(label: String, variable: Binding<Variable>, cases: [Variable]) {
        self.label = label
        self.variable = variable
        self.cases = cases
        self.style = ClearFormRowStyle()
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
                    .modifier(style)
                    .modifier(ClearButton(text: variable))
            } else {
                TextField(placeholder, text: variable)
                    .modifier(style)
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

extension FormToggleRow where Style == ClearFormRowStyle {
    public init(label: String, variable: Binding<Bool>) {
        self.label = label
        self.variable = variable
        self.style = ClearFormRowStyle()
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

    public init(contentType: UITextContentType? = nil, autocapitalization: UITextAutocapitalizationType = .none, disableAutocorrection: Bool = true, keyboardType: UIKeyboardType = .default) {
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
            .textFieldStyle(RoundedBorderTextFieldStyle())
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
