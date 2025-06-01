//
//  OpportunityFeedView_Previews.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/31/25.
//

import SwiftUI

@available(iOS 17.0, *)
#Preview {
    OpportunityFeedView()
}



struct OpportunityFeedView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17, *) {
            OpportunityFeedView()
        } else {
            // Fallback on earlier versions
        }
    }
}

