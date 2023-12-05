ORG 100              / Multiplication by addition
Loop, Load    B       / Load Fib2 into AC
    Add       A          / Add Fib1 to Fib2
    Store     Sum       / Store the new number
    Load      B
    Store     A         / Move Fib2 to Fib1
    Load      Sum
    Store     B         / Move the new number to Fib2
    Load      Ctr        / Load the loop control variable
    Add       Neg1       / Decrement the loop control variable by one
    Store     Ctr        / Store the new value of the loop control variable
    Skip      1        / If control variable = 0, skip next instruction to terminate the loop
    Jump      Loop       / Otherwise, go to Loop
    Halt                 / Terminate program
A,    Dec     1          / Fib1, initially 1 because F(1) = 1
B,    Dec     1          / Fib2, initially 1 because F(2) = 1
Sum, Dec     0          / The next Fib number
Ctr,  Dec     9          / The loop control variable
Dec, Dec     -1         / Used to decrement by 1
