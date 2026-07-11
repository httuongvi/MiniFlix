//
//  DrillDay3.swift
//  MiniFlix
//
//  Created by Tuong Vi on 11/7/26.
//
import SwiftUI

struct DrillDay3: View {
    @State private var count: Int = 0
    var body: some View {
        Text("Đếm số: \(count)")
            .font(.largeTitle)
        
        AddButtonView(count: $count)
        SubtractButtonView(count: $count)
    }
}

struct AddButtonView: View {
    @Binding var count: Int
    var body: some View {
        Button{
            count += 1
        } label: {
            Text("+")
                .font(.largeTitle)
                .frame(width: 150, height: 50)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
        }
    }
}

struct SubtractButtonView: View {
    @Binding var count: Int
    var body: some View {
        Button{
            if(count > 0){
                count -= 1
            }
        } label: {
            Text("-")
                .font(.largeTitle)
                .frame(width: 150, height: 50)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
        }
    }
}


#Preview {
    DrillDay3()
}
