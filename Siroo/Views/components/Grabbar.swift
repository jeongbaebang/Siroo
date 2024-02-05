//
//  Grabbar.swift
//  Siroo
//
//  Created by jeongbae bang on 2/1/24.
//

import SwiftUI

struct Grabbar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .foregroundColor(.gray)
            .padding(.top, 5)
    }
}

#Preview {
    Grabbar()
}
