setPriority(min, max) {
    send !p
    Random, OutputVar, %min%, %max%
    send %OutputVar%
    send {enter}
}