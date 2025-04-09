```k
requires "evm.md"
requires "lemmas/summarization-simplification.k"

module CSE
    imports EVM
    imports SUMMARIZATION-SIMPLIFICATION

  // ########################
  // Buffer Reasoning
  // From: tests/specs/benchmarks/verification.k
  // ########################

    rule #sizeWordStack(WS, N)  <Int SIZE => #sizeWordStack(WS, 0) +Int N  <Int SIZE  requires N =/=Int 0 [simplification]
    rule #sizeWordStack(WS, N) <=Int SIZE => #sizeWordStack(WS, 0) +Int N <=Int SIZE  requires N =/=Int 0 [simplification]

    rule SIZELIMIT <Int #sizeWordStack(WS, N) +Int DELTA  => SIZELIMIT <Int (#sizeWordStack(WS, 0) +Int N) +Int DELTA  requires N =/=Int 0 [simplification]
    rule SIZELIMIT <Int #sizeWordStack(WS, N)             => SIZELIMIT <Int  #sizeWordStack(WS, 0) +Int N              requires N =/=Int 0 [simplification]
endmodule
```
