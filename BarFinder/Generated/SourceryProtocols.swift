//
//  SourceryProtocols.swift
//  
//
//  Created by Nikola Milovanovic on 4/14/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//




/// Protocols used by Sourcery to auto generate code

/// Protocol for auto generating Lenses, it can only by applicable on structs
protocol AutoLens {}

/// Protocol for auto generating array of all possible values for enums, it can only by applicable on enums
protocol AutoCases {}

/// Protocol for auto generating mocks, it can only by applicable on protocols
protocol AutoMocable {}
