//
// Created by Mengyu Li on 2020/7/23.
//

precedencegroup Forward {
	associativity: left
}

infix operator |>: Forward

func |> <T, U>(value: T, function: (T) -> U) -> U { function(value) }
