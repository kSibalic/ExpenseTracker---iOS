//
//  LockView.swift
//  ExpenseTracker
//
//  Created by Karlo Šibalić on 11.03.2025..
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    
    @ViewBuilder var content: Content
    
    @State private var pin: String = ""
    @State private var animtedField: Bool = false
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
    
    let context = LAContext()
    
    @Environment(\.scenePhase) private var phase
    
    var forgotPIN: () -> () = {  }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Please enable biometric authentication in Settings to unlock the view!")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            } else {
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter PIN")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        NumberPadView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            
            if newValue == .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
    
    private func unlockView() {
        Task {
            if isBiometricAvailable && lockType != .number {
                if let result = try? await
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlocked the View"), result {
                    print("Unlocked")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    @ViewBuilder
    private func NumberPadView() -> some View {
        VStack(spacing: 15) {
            Text("Enter PIN")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading, content: {
                    if lockType == .both && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            noBiometricAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                })
            
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animtedField, content: {
                content, value in
                content
                    .offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(10, duration: 0.07)
                    CubicKeyframe(-10, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
                
            })
            .padding(.top, 15)
            .overlay(alignment: .bottom, content: {
                Button("Forgot PIN?", action: forgotPIN)
                    .foregroundStyle(.white)
                    .offset(y: 40)
            })
            .frame(maxHeight: .infinity)
            
            GeometryReader {_ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            if pin.count < 6 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                    }
                    
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    
                    Button(action: {
                        if pin.count < 6 {
                            pin.append("0")
                        }
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 6 {
                    if lockPin == pin {
                        print("Unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        print("Wrong PIN")
                        pin = ""
                        animtedField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
        
    
    enum LockType: String {
        case biometric = "Biometric Auth"
        case number = "Number Lock"
        case both = "Prefered is biometric, if not available -> go to number lock"
    }
}

#Preview {
    LockView(lockType: .both, lockPin: "123456", isEnabled: true) {
        VStack(spacing: 15) {
            Image(systemName: "faceid")
                .font(.system(size: 42))
            Text("Lock View")
        }
    }
}
