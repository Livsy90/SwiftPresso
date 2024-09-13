import SwiftUI

struct TextView: View {

    @Environment(\.layoutDirection) private var layoutDirection
    @Binding private var attributedString: NSAttributedString
    @Binding private var postID: Int?
    @State private var calculatedHeight: CGFloat = 44
    @State private var isEmpty: Bool = false

    private var title: String
    private var onEditingChanged: (() -> Void)?
    private var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
    private var onCommit: (() -> Void)?

    private var placeholderFont: Font = .body
    private var placeholderAlignment: TextAlignment = .leading
    private var foregroundColor: UIColor = .label
    private var autocapitalization: UITextAutocapitalizationType = .sentences
    private var multilineTextAlignment: NSTextAlignment = .left
    private var font: UIFont = .preferredFont(forTextStyle: .body)
    private var returnKeyType: UIReturnKeyType?
    private var clearsOnInsertion: Bool = false
    private var autocorrection: UITextAutocorrectionType = .default
    private var truncationMode: NSLineBreakMode = .byTruncatingTail
    private var isSecure: Bool = false
    private var isEditable: Bool = true
    private var isSelectable: Bool = true
    private var isScrollingEnabled: Bool = false
    private var enablesReturnKeyAutomatically: Bool?
    private var autoDetectionTypes: UIDataDetectorTypes = []

    private var internalText: Binding<NSAttributedString> {
        Binding<NSAttributedString>(get: { self.attributedString }) {
            self.attributedString = $0
            self.isEmpty = $0.string.isEmpty
        }
    }

    init(
        _ title: String,
        postID: Binding<Int?>,
        attributedString: Binding<NSAttributedString>,
        shouldEditInRange: ((Range<String.Index>, String) -> Bool)? = nil,
        onEditingChanged: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.title = title

        _postID = postID
        _attributedString = attributedString
        _isEmpty = State(initialValue: self.attributedString.string.isEmpty)

        self.onCommit = onCommit
        self.shouldEditInRange = shouldEditInRange
        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        SwiftUITextView(
            internalText,
            postID: $postID,
            foregroundColor: foregroundColor,
            font: font,
            multilineTextAlignment: multilineTextAlignment,
            autocapitalization: autocapitalization,
            returnKeyType: returnKeyType,
            clearsOnInsertion: clearsOnInsertion,
            autocorrection: autocorrection,
            truncationMode: truncationMode,
            isSecure: isSecure,
            isEditable: isEditable,
            isSelectable: isSelectable,
            isScrollingEnabled: isScrollingEnabled,
            enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
            autoDetectionTypes: autoDetectionTypes,
            calculatedHeight: $calculatedHeight,
            shouldEditInRange: shouldEditInRange,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
            .frame(
                minHeight: isScrollingEnabled ? 0 : calculatedHeight,
                maxHeight: isScrollingEnabled ? .infinity : calculatedHeight
        )
            .background(placeholderView, alignment: .leading)
    }

    var placeholderView: some View {
        Group {
            if isEmpty {
                Text(title)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(placeholderAlignment)
                    .font(placeholderFont)
            }
        }
    }

}

extension TextView {

    func autoDetectDataTypes(_ types: UIDataDetectorTypes) -> TextView {
        var view = self
        view.autoDetectionTypes = types
        return view
    }

    func foregroundColor(_ color: UIColor) -> TextView {
        var view = self
        view.foregroundColor = color
        return view
    }

    func autocapitalization(_ style: UITextAutocapitalizationType) -> TextView {
        var view = self
        view.autocapitalization = style
        return view
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> TextView {
        var view = self
        view.placeholderAlignment = alignment
        switch alignment {
        case .leading:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.multilineTextAlignment = .center
        }
        return view
    }

    func font(_ font: UIFont) -> TextView {
        var view = self
        view.font = font
        return view
    }

    func placeholderFont(_ font: Font) -> TextView {
        var view = self
        view.placeholderFont = font
        return view
    }

    func clearOnInsertion(_ value: Bool) -> TextView {
        var view = self
        view.clearsOnInsertion = value
        return view
    }

    func disableAutocorrection(_ disable: Bool?) -> TextView {
        var view = self
        if let disable = disable {
            view.autocorrection = disable ? .no : .yes
        } else {
            view.autocorrection = .default
        }
        return view
    }

    func isEditable(_ isEditable: Bool) -> TextView {
        var view = self
        view.isEditable = isEditable
        return view
    }

    func isSelectable(_ isSelectable: Bool) -> TextView {
        var view = self
        view.isSelectable = isSelectable
        return view
    }

    func enableScrolling(_ isScrollingEnabled: Bool) -> TextView {
        var view = self
        view.isScrollingEnabled = isScrollingEnabled
        return view
    }

    func returnKey(_ style: UIReturnKeyType?) -> TextView {
        var view = self
        view.returnKeyType = style
        return view
    }

    func automaticallyEnablesReturn(_ value: Bool?) -> TextView {
        var view = self
        view.enablesReturnKeyAutomatically = value
        return view
    }

    func truncationMode(_ mode: Text.TruncationMode) -> TextView {
        var view = self
        switch mode {
        case .head: view.truncationMode = .byTruncatingHead
        case .tail: view.truncationMode = .byTruncatingTail
        case .middle: view.truncationMode = .byTruncatingMiddle
        @unknown default:
            fatalError("Unknown text truncation mode")
        }
        return view
    }

}

private struct SwiftUITextView: UIViewRepresentable {

    @Binding private var postID: Int?
    @Binding private var attributedString: NSAttributedString
    @Binding private var calculatedHeight: CGFloat

    private var onEditingChanged: (() -> Void)?
    private var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
    private var onCommit: (() -> Void)?

    private let foregroundColor: UIColor
    private let autocapitalization: UITextAutocapitalizationType
    private let multilineTextAlignment: NSTextAlignment
    private let font: UIFont
    private let returnKeyType: UIReturnKeyType?
    private let clearsOnInsertion: Bool
    private let autocorrection: UITextAutocorrectionType
    private let truncationMode: NSLineBreakMode
    private let isSecure: Bool
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool
    private let enablesReturnKeyAutomatically: Bool?
    private var autoDetectionTypes: UIDataDetectorTypes = []

    init(
        _ attributedString: Binding<NSAttributedString>,
        postID: Binding<Int?>,
        foregroundColor: UIColor,
        font: UIFont,
        multilineTextAlignment: NSTextAlignment,
        autocapitalization: UITextAutocapitalizationType,
        returnKeyType: UIReturnKeyType?,
        clearsOnInsertion: Bool,
        autocorrection: UITextAutocorrectionType,
        truncationMode: NSLineBreakMode,
        isSecure: Bool,
        isEditable: Bool,
        isSelectable: Bool,
        isScrollingEnabled: Bool,
        enablesReturnKeyAutomatically: Bool?,
        autoDetectionTypes: UIDataDetectorTypes,
        calculatedHeight: Binding<CGFloat>,
        shouldEditInRange: ((Range<String.Index>, String) -> Bool)?,
        onEditingChanged: (() -> Void)?,
        onCommit: (() -> Void)?
    ) {
        _attributedString = attributedString
        _calculatedHeight = calculatedHeight
        _postID = postID

        self.onCommit = onCommit
        self.shouldEditInRange = shouldEditInRange
        self.onEditingChanged = onEditingChanged

        self.foregroundColor = foregroundColor
        self.font = font
        self.multilineTextAlignment = multilineTextAlignment
        self.autocapitalization = autocapitalization
        self.returnKeyType = returnKeyType
        self.clearsOnInsertion = clearsOnInsertion
        self.autocorrection = autocorrection
        self.truncationMode = truncationMode
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.autoDetectionTypes = autoDetectionTypes

        makeCoordinator()
    }

    func makeUIView(context: Context) -> UIKitTextView {
        let view = UIKitTextView()
        view.delegate = context.coordinator
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.backgroundColor = UIColor.clear
        view.adjustsFontForContentSizeCategory = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }

    func updateUIView(_ view: UIKitTextView, context: Context) {
        view.attributedText = attributedString
        view.font = font
        view.textAlignment = multilineTextAlignment
        view.textColor = foregroundColor
        view.autocapitalizationType = autocapitalization
        view.autocorrectionType = autocorrection
        view.isEditable = isEditable
        view.isSelectable = isSelectable
        view.isScrollEnabled = isScrollingEnabled
        view.dataDetectorTypes = autoDetectionTypes

        if let value = enablesReturnKeyAutomatically {
            view.enablesReturnKeyAutomatically = value
        } else {
            view.enablesReturnKeyAutomatically = onCommit == nil ? false : true
        }

        if let returnKeyType = returnKeyType {
            view.returnKeyType = returnKeyType
        } else {
            view.returnKeyType = onCommit == nil ? .default : .done
        }

        SwiftUITextView.recalculateHeight(view: view, result: $calculatedHeight)
    }

    @discardableResult
    func makeCoordinator() -> Coordinator {
        Coordinator(
            postID: $postID,
            attributedString: $attributedString,
            calculatedHeight: $calculatedHeight,
            shouldEditInRange: shouldEditInRange,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.width, height: .greatestFiniteMagnitude))

        guard result.wrappedValue != newSize.height else { return }
        DispatchQueue.main.async {
            result.wrappedValue = newSize.height
        }
    }

}

private extension SwiftUITextView {

    final class Coordinator: NSObject, UITextViewDelegate {

        var onCommit: (() -> Void)?
        var onEditingChanged: (() -> Void)?
        var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
        
        @Binding private var postID: Int?
        private var originalText: NSAttributedString = .init()
        private var attributedString: Binding<NSAttributedString>
        private var calculatedHeight: Binding<CGFloat>

        init(
            postID: Binding<Int?>,
            attributedString: Binding<NSAttributedString>,
            calculatedHeight: Binding<CGFloat>,
            shouldEditInRange: ((Range<String.Index>, String) -> Bool)?,
            onEditingChanged: (() -> Void)?,
            onCommit: (() -> Void)?
        ) {
            _postID = postID
            self.attributedString = attributedString
            self.calculatedHeight = calculatedHeight
            self.shouldEditInRange = shouldEditInRange
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            originalText = attributedString.wrappedValue
        }

        func textViewDidChange(_ textView: UITextView) {
            attributedString.wrappedValue = textView.attributedText
            SwiftUITextView.recalculateHeight(view: textView, result: calculatedHeight)
            onEditingChanged?()
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if onCommit != nil, text == "\n" {
                onCommit?()
                originalText = textView.attributedText
                textView.resignFirstResponder()
                return false
            }

            return true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if onCommit != nil {
                attributedString.wrappedValue = originalText
            }
        }
        
        func textView(_ textView: UITextView, menuConfigurationFor textItem: UITextItem, defaultMenu: UIMenu) -> UITextItem.MenuConfiguration? {
            if case .link(let url) = textItem.content {
                let components = url.pathComponents
                if let idComponent = components.last, let id = Int(idComponent)  {
                    postID = id
                   return nil
                }
            }

            return .init(menu: defaultMenu)
        }

    }

}

private final class UIKitTextView: UITextView {
    
    override var keyCommands: [UIKeyCommand]? {
        return (super.keyCommands ?? []) + [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:)))
        ]
    }
    
    var didTappedOnAreaBesidesAttachment: (() -> Void)? = nil
    var didTappedOnAttachment: ((UIImage) -> Void)? = nil
    
    private var isTouchMoved = false
    private var tappedImage: UIImage?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        isTouchMoved = true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
           tapGestureRecognizer.numberOfTapsRequired == 2 {
            let index = indexOfTap(recognizer: tapGestureRecognizer)
            if let _ = attributedText?.attribute(
                NSAttributedString.Key.attachment,
                at: index,
                effectiveRange: nil
            ) as? NSTextAttachment {
                return false
            }
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapOnAttachment(touches.first!.location(in: self)) {
            guard let image = tappedImage else { return }
            didTappedOnAttachment?(image)
            return
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !isTouchMoved &&
            !isTapOnAttachment(touches.first!.location(in: self)) &&
            selectedRange.length == 0 {
            didTappedOnAreaBesidesAttachment?()
        }
        
        isTouchMoved = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        isTouchMoved = false
    }
    
    
    @objc
    private func escape(_ sender: Any) {
        resignFirstResponder()
    }
    
    private func isTapOnAttachment(_ point: CGPoint) -> Bool {
        let range = NSRange(
            location: 0,
            length: attributedText.length
        )
        var found = false
        attributedText.enumerateAttribute(
            .attachment,
            in: range,
            options: []
        ) { (value, effectiveRange, stop) in
            guard let attachment = value as? NSTextAttachment else {
                return
            }
            
            tappedImage = attachment.image
            let rect = layoutManager.boundingRect(
                forGlyphRange: effectiveRange,
                in: textContainer
            )
            if rect.contains(point) {
                found = true
                stop.pointee = true
            }
        }
        
        return found
    }
}
