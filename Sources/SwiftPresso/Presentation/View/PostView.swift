import SwiftUI

struct PostView: View {
    
    @State var viewModel: PostViewModel
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .padding()
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
                
                Spacer()
            }
            
            HStack {
                Text(viewModel.date?.formatted(date: .numeric, time: .omitted) ?? "")
                    .padding()
                    .foregroundStyle(textColor)
                    .font(.footnote)
                
                Spacer()
            }
            tv
                .padding()
        }
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .background {
            backgroundColor
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private var tv: some View {
        TextView(
            attributedText: $viewModel.attributedString,
            textStyle: .callout,
            textColor: .label
        )
    }
    
}

struct TextView: UIViewRepresentable {

    @Binding var attributedText: NSAttributedString
    let textStyle: UIFont.TextStyle
    let textColor: UIColor

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = false
        textView.textColor = .blue
        textView.backgroundColor = .clear
        textView.attributedText = attributedText

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
}

#Preview {
    let testString = "Text"
    let post = PostModel(id: 1, date: .now, title: "Title", excerpt: "", imgURL: nil, link: nil, content: "Content", author: 0, tags: [])
    return PostView(
        viewModel: .init(post: post, width: 375),
        backgroundColor: SwiftPresso.Configuration.backgroundColor,
        textColor: SwiftPresso.Configuration.textColor
    )
}
