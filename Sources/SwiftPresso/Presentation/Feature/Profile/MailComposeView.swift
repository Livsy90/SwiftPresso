import SwiftUI
import MessageUI

public struct MailComposeView: UIViewControllerRepresentable {
    
    let subject: String
    let toRecipients: [String]
    let body: String
    
    @Environment(\.dismiss) private var dismiss
    
    public static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    public init(subject: String, toRecipients: [String], body: String) {
        self.subject = subject
        self.toRecipients = toRecipients
        self.body = body
    }
    
    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setSubject(subject)
        controller.setToRecipients(toRecipients)
        controller.setMessageBody(body, isHTML: false)
        controller.mailComposeDelegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator {
            dismiss()
        }
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private var dismiss: () -> Void
        
        init(dismiss: @escaping () -> Void) {
            self.dismiss = dismiss
        }
        
        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            dismiss()
        }
    }
}
