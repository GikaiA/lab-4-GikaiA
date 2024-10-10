//
//  CardView.swift
//  Flashcard
//
//  Created by Gikai Andrews on 10/9/24.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var onSwipedLeft: (() -> Void)?
    var onSwipedRight: (() -> Void)?

    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero
    private let swipeThreshold: Double = 200
    var body: some View {
        ZStack{
            //Card Background
            ZStack{
                //Back-Most card background
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(offset.width < 0 ? .red : .green)
            }
            //Front-most card background
            RoundedRectangle(cornerRadius: 25.0)
                .fill(isShowingQuestion ? .blue : .indigo)
                .shadow(color: .black, radius:4, x: -2, y: 2)
                .opacity(1 - abs(offset.width / swipeThreshold))
            VStack(spacing:20){
                //Card type (question vs answer)
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()
                
                //Separator
                Rectangle()
                    .frame(height: 1)
                
                //Card Text
                Text(isShowingQuestion ? card.question : card.answer)
            }
            .font(.title)
            .foregroundStyle(.white)
            .padding()
        }
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle()
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3)
        .rotationEffect(.degrees(offset.width / 20.0)) // <-- Add rotation when swiping
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
                   .onChanged { gesture in // <-- onChanged called for every gesture value change, like when the drag translation changes
                       let translation = gesture.translation // <-- Get the current translation value of the gesture. (CGSize with width and height)
                       print(translation) // <-- Print the translation value
                       offset = translation
                   } .onEnded { gesture in  // <-- onEnded called when gesture ends
                       
                       if gesture.translation.width > swipeThreshold { // <-- Compare the gesture ended translation value to the swipeThreshold
                           print("👉 Swiped right")
                           onSwipedRight?()

                       } else if gesture.translation.width < -swipeThreshold {
                           print("👈 Swiped left")
                           onSwipedLeft?()

                       } else {
                           print("🚫 Swipe canceled")
                           withAnimation(.bouncy){
                            offset = .zero
                           }
                       }
                   }
    )}
   
}

#Preview {
    CardView(card: Card(question: "Located at the Southern end of Pugent Sound,what is the capitol of Washington?", answer: "Olympia"))
}

struct Card: Equatable{
    let question: String
    let answer: String
    static let mockedCards = [
            Card(question: "Located at the southern end of Puget Sound, what is the capitol of Washington?", answer: "Olympia"),
            Card(question: "Which city serves as the capital of Texas?", answer: "Austin"),
            Card(question: "What is the capital of New York?", answer: "Albany"),
            Card(question: "Which city is the capital of Florida?", answer: "Tallahassee"),
            Card(question: "What is the capital of Colorado?", answer: "Denver")
        ]
}

//
