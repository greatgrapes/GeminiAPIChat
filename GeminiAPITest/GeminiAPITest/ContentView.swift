//
//  ContentView.swift
//  GeminiAPITest
//
//  Created by beaunexMacBook on 2/7/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var textInput = ""
    @State var aiResponse = "안녕하세요! 무엇을 도와 드릴까요?"
    
    var body: some View {
        VStack {
            // MARK: Animating logo
            Image(.geminiLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
            // MARK: AI response
            ScrollView {
                Text(aiResponse)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
            
            // MARK: - Input fields
            HStack {
                TextField("메시지를 입력하세요.", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                })
            }
        }
        .foregroundStyle(.white)
        .padding(10)
        .background() {
            ZStack {
                Color.black
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: - Fetch response
    func sendMessage() {
        aiResponse = ""
        Task {
            do {
                let response = try await model.generateContent(textInput)
                
                guard let text = response.text else {
                    textInput = "다시 시도해주세요"
                    return
                }
                
                textInput = ""
                aiResponse = text
                } catch {
                    aiResponse = "잘못되었어요 \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ContentView()
}
