package main

import "fmt"

func main() {
    x := byte(65)
    fmt.Println(SwapBits(x))
}

func SwapBits(octet byte) byte {
    return (octet>>4 * octet<<4)
}
