import SwiftUI

struct PostView: View {
    
    let viewModel: PostViewModel
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        ScrollView {
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
                
                Spacer()
            }
            
            Text(viewModel.attributedContent)
                .padding()
                .foregroundStyle(textColor)
        }
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .background {
            backgroundColor
        }
        .overlay {
            ProgressView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .onAppear {
            viewModel.onAppear()
        }
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
