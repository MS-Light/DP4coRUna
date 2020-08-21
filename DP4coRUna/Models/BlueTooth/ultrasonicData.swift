//
//  ultrasonicData.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/21/20.
//

import Foundation

struct ultrasonicData {
    static var localTime: Double = 0
    static var localTimeValid: Bool = false
    
    static var remoteTime: Double = 0
    static var remoteTimeValid: Bool = false
    
    static var leaderTxSamples: [Float32] = [0]
    static var followerTxSamples: [Float32] = [0]
    
    static var sendTime: Double = 0
    static var recvRemoteTime: Double = 0
    
    static var localSNR: Double = 0
    static var remoteSNR: Double = 0
    
    static var localDoppler: Double = 0
    static var remoteDoppler: Double = 0
}
