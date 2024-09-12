import SwiftUI

struct PostView: View {
    
    @State var viewModel: PostViewModel
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        TextView(
            attributedText: $viewModel.attributedString,
            textStyle: .callout
        )
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .background {
            backgroundColor
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
}

#Preview {
    let post = PostModel(
        id: 1,
        date: .now,
        title: "Title",
        excerpt: "",
        imgURL: nil,
        link: nil,
        content: "Text",
        author: 0,
        tags: []
    )
    
    return PostView(
        viewModel: .init(post: post, width: 375),
        backgroundColor: SwiftPresso.Configuration.backgroundColor,
        textColor: SwiftPresso.Configuration.textColor
    )
}
