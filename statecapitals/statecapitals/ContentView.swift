//
//  ContentView.swift
//  statecapitals
//
//  Created by Ailyn Diaz on 2/27/24.
//  CSC iOS --> STATE CAPITALS

import SwiftUI

struct StateData {
    var name: String
    var capital: String
}

struct ContentView: View {
    // Dictionary to map state names to image names
    let stateImages: [String: String] = [
        "Alabama": "alabama_image",
        "Alaska": "alaska_image",
        "Arizona": "arizona_image",
        "Arkansas": "arkansas_image",
        "Colorado": "colorado_image",
        "New Mexico": "newmexico_image",
        "California": "california_image",
        "Florida": "florida_image",
        "Oregon": "oregon_image",
        "Nebraska": "nebraska_image",
        "New York": "newyork_image",
        "Texas": "texas_image",
    ]

    @State private var states = [
        StateData(name: "Alabama", capital: "Montgomery"),
        StateData(name: "Alaska", capital: "Juneau"),
        StateData(name: "Arizona", capital: "Phoenix"),
        StateData(name: "Arkansas", capital: "Little Rock"),
        StateData(name: "Colorado", capital: "Denver"),
        StateData(name: "New Mexico", capital: "Santa Fe"),
        StateData(name: "California", capital: "Sacramento"),
        StateData(name: "Florida", capital: "Tallahassee"),
        StateData(name: "Oregon", capital: "Salem"),
        StateData(name: "Nebraska", capital: "Lincoln"),
        StateData(name: "New York", capital: "Albany"),
        StateData(name: "Texas", capital: "Austin"),
    ]
    @State private var selectedStateIndex = Int.random(in: 0..<5)
    @State private var score = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var viewID = UUID() // Adds a unique identifier

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer() // Add spacer to push content down
                Text("GUESS THE CAPITAL")
                    .font(.custom("Arial Rounded MT Bold", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing) // Gradient background
                    )
                    .cornerRadius(10) // Rounded corners
                    .shadow(color: .black, radius: 5, x: 0, y: 5) //Shadow

                // Display State Image
                if let imageName = stateImages[states[selectedStateIndex].name] {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150) // Adjusts image size
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .shadow(radius: 10)
                        .padding()
                }

                // Display State Name
                Text(states[selectedStateIndex].name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.2, blue: 0.8),
                                Color(red: 0.12, green: 0.8, blue: 0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20) // Rounded corners
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)

                    .scaleEffect(1.05)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        }
                    }

                // Display Capital Options
                VStack(spacing: 10) {
                    let stateCapital = states[selectedStateIndex].capital
                    let otherCapitals = states.filter { $0.capital != stateCapital }.map { $0.capital }.shuffled()
                    let options = Array(otherCapitals.prefix(4) + [stateCapital]).shuffled() //5 tabs
                    ForEach(options, id: \.self) { capital in
                        Button(action: {
                            if let index = self.states.firstIndex(where: { $0.capital == capital }) {
                                self.checkAnswer(index)
                            }
                        }) {
                            Text(capital)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)


                // Display Current Score
                Text("Score: \(score)")
                    .font(.headline)
                    .foregroundColor(.white)

                // Reset Button
                Button(action: {
                    self.resetGame()
                }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)

                Spacer()
            }
            .id(viewID)
            .onAppear {
                self.viewID = UUID()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // check to see if answers are right
    func checkAnswer(_ index: Int) {
        if index < states.count && self.states[index].capital == self.states[self.selectedStateIndex].capital {
            score += 1
            showAlert = true
            alertMessage = "Good Job! Your score is \(self.score)."
        } else {
            showAlert = true
            alertMessage = "Your guess is incorrect. Try again."
        }
        selectedStateIndex = Int.random(in: 0..<states.count)
    }
    //resets
    func resetGame() {
        states.shuffle()
        selectedStateIndex = Int.random(in: 0..<states.count)
        score = 0
        viewID = UUID()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
