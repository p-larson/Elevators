import SwiftUI
import Haptica
import MovingNumbersView

struct DailyGiftView: View {
    @Binding var isShowing: Bool
    @Binding var hasCollectedDailyGift: Bool
    
    @State private var reward: Int = 0
    @State private var taps = 0
    @State private var opened = false
    @State private var disappeared = false
    @State private var opacity = false
    @State private var hue = false
    @State private var label = false
    @State private var collect = false
    @State private var labelOpacity = false
    @State private var hidden = false
    @State private var showBox = false
    
    var body: some View {
        ZStack {
            //
            GameBackground()
                .hueRotation(.degrees(hue ? 360 : 0))
            // Label
            HStack(spacing: 0) {
                Text("$")
                    .font(.system(size: 24))
                MovingNumbersView(number: Double(reward), numberOfDecimalPlaces: 0) { string in
                    Text(string)
                        .fixedSize()
                }
                .mask(LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: .clear, location: 0),
                        Gradient.Stop(color: .black, location: 0.2),
                        Gradient.Stop(color: .black, location: 0.8),
                        Gradient.Stop(color: .clear, location: 1.0)]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .fixedSize()
                .foregroundColor(.white)
            }
            .foregroundColor(.white)
            .offset(y: label ? 0 : -96)
            .opacity(labelOpacity ? 1 : 0)
            .font(.custom("Futura", size: 32))
            // Collect Button
            VStack {
                Spacer()
                Text("See you tomorrow")
                Text("For your daily gift!")
                    .padding(.bottom, 8)
                GameButton {
                    Text("Collect Reward")
                        .foregroundColor(.white)
                        .font(.custom("Futura", size: 24))
                }
                .foregroundColor(.clear)
            }
            .foregroundColor(.white)
            .font(.custom("Futura", size: 16))
            .opacity(collect ? 1 : 0)
            .buttonPadding(value: 0)
            .onButtonPress {
                
                self.hasCollectedDailyGift = true
                
                let prize = self.reward
                let increment = prize / 5
                let final = GameData.cash + prize
                
                var i = 0
                
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                    i += 1; if i == 5 {
                        self.reward = 0
                        GameData.cash = final
                        timer.invalidate()
                        
                        withAnimation(Animation.easeInOut(duration: 0.3).delay(0.7)) {
                            self.hidden = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isShowing = false
                        }
                    } else {
                        self.reward -= increment
                        GameData.cash += increment
                    }
                }
            }
            
            ZStack {
                Text("🎁")
                    .brightness(1)
                    .scaleEffect(1.1)
                Text("🎁")
            }
            .font(.system(size: 96))
            .scaleEffect(opened ? 0 : 1)
            .scaleEffect(1 + CGFloat(self.taps) / 5 * 0.5)
            .opacity(opened ? 0 : 1)
            .scaleEffect(showBox ? 1 : 0)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            
            if self.taps == 0 {
                withAnimation(Animation.easeInOut(duration: 0.3)) {
                    self.labelOpacity = true
                }
            }
            
            if self.taps < 5 {
                self.reward += .random(in: 1...(self.taps + 1) * 10)
                
                withAnimation(Animation.interpolatingSpring(stiffness: 200, damping: 10)) {
                    self.taps += 1
                }
                
                Haptic.impact(.light).generate()
            }
            
            if self.taps == 5 && !self.opened {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.opened = true
                }
                
                Haptic.notification(.success).generate()
                // Show the Label
                withAnimation(Animation.easeInOut(duration: 1).delay(0.3)) {
                    self.label = true
                }
                
                withAnimation(Animation.easeInOut(duration: 1).delay(1.3)) {
                    self.collect = true
                }
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                self.showBox = true
            }
            
            
            withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                self.hue = true
            }
        }
        .opacity(hidden ? 0 : 1)
    }
}

struct DailyGiftView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            DailyGiftView(isShowing: .constant(false), hasCollectedDailyGift: .constant(false))
            CoinCounterView()
        }.statusBar(hidden: true)
    }
}
