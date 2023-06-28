//
//  ContentView.swift
//  Slot Machine
//
//  Created by Patrick Masterson on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var reels = [0, 1, 2]
    @State private var showingInfoView = false
    @State private var highscore = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins = 100
    @State private var betAmount = 10
    @State private var isActiveBet10 = true
    @State private var isActiveBet20 = false
    @State private var showingModal = false
    
    @State private var animatingSymbol = false
    @State private var animatingModal = false
    
    // MARK: - Functions
    
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] {
            playerWins()
            
            if coins > highscore {
                newHighScore()
                
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func isGameOver() {
        if coins <= 0 {
            playSound(sound: "game-over", type: "mp3")
            // show modal
            showingModal = true
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimpup", type: "mp3")
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(
                gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]),
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 5) {
                // MARK: - Header
                LogoView()
                    .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                // MARK: - Slot Machine
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - Reel 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : 50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
                            .onAppear() {
                                animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        // MARK: - Reel 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : 100)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                                .onAppear() {
                                    animatingSymbol.toggle()
                                }
                        }
                        Spacer()
                        // MARK: - Reel 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                                .onAppear() {
                                    animatingSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    
                    // MARK: - Spin Button
                    Button(action: {
                        // set default state
                        withAnimation {
                            animatingSymbol = false
                        }
                        
                        spinReels()
                        
                        withAnimation {
                            animatingSymbol = true
                        }
                        
                        checkWinning()
                        
                        isGameOver()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                      
                }
                .layoutPriority(2)
                
                // MARK: - Footer
                Spacer()
                
                HStack {
                    HStack(alignment: .center, spacing: 10) {
                        // MARK: - Bet 20
                        Button(action: {
                            activateBet20()
                            isActiveBet20 = true
                            isActiveBet10 = false
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .modifier(CasinoChipsModifier())
                        
                        Spacer()
                        
                        // MARK: - bet 10
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            activateBet10()
                            isActiveBet20 = false
                            isActiveBet10 = true
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            // MARK: - Buttons
            .overlay(
                // reset
                Button(action: {
                    resetGame()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        
                }
                    .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                // Info
                Button(action: {
                    showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                        
                }
                    .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            if $showingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    // Modal
                    VStack(spacing: 0) {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        //Message
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck.  You lost all your coins. \nLet's play again")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                showingModal = false
                                animatingModal = false
                                activateBet10()
                                coins = 100
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: animatingModal)
                    .onAppear() {
                        animatingModal = true
                    }
                }
                
            }
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
