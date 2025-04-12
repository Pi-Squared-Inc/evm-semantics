requires "../cse.md"

// Run using:
// kprove kevm-pyk/src/kevm_pyk/kproj/evm-semantics/summaries/block-summary.k --definition /home/njr/.cache/kdist-e374d3c/evm-semantics/summary --md-selector k -I /home/njr/workspace/kevm-pyk/src/kevm_pyk/kproj/evm-semantics -I /home/njr/workspace/kevm-pyk/src/kevm_pyk/kproj/plugin --depth 100

/*
        PUSH1 0                   // s = 0
        PUSH1 10,000              // n = 10000
  loop: JUMPDEST
        SWAP; DUP 2; ADD; SWAP    // s = s+n
        PUSH 1; SUB               // n = n-1
        DUP;
        PUSH loop
        JUMPI
 */

module SUM
    imports CSE

    claim
           <k>        #execute               </k>
           <schedule> SCHEDULE_CELL:Schedule </schedule>
           <ethereum>
             <evm>
               <callState>
                 //  0:       PUSH(1) 0                 // s = 0
                 //  2:       PUSH(2) 10,000            // n = 10000
                 //  5: loop: JUMPDEST
                 //  6:       SWAP; DUP 2; ADD; SWAP    // s = s+n
                 // 10:       PUSH(1) 1; SUB            // n = n-1
                 // 13:       DUP;
                 // 14:       PUSH loop
                 // 16:       JUMPI
                 //             00  .   .   .   .   05  .   .   .   .   10  .   .   .   .   15  .   .
                 <program>   b"\x60\x00\x61\x27\x10\x5b\x90\x81\x01\x90\x60\x01\x03\x80\x60\x05\x57\x00" </program>
                 <jumpDests> b"\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>
                 // ------- Dynamic -----------------------------------------------------------------------------
                 <wordStack> .List        => (ListItem(10000) ListItem(0)) </wordStack>
                 <pc>        0            => 05                            </pc>
                 <gas>       GAS_CELL:Int => (GAS_CELL:Int -Int 6)         </gas>
                 // ---------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 6  <=Int GAS_CELL:Int
       andBool SCHEDULE_CELL ==K CANCUN


    claim  <k>        #execute               </k>
           <schedule> SCHEDULE_CELL:Schedule </schedule>
           <ethereum>
             <evm>
               <callState>
                 //  0:       PUSH(1) 0                 // s = 0
                 //  2:       PUSH(2) 10,000            // n = 10000
                 //  5: loop: JUMPDEST
                 //  6:       SWAP; DUP 2; ADD; SWAP    // s = s+n
                 // 10:       PUSH(1) 1; SUB            // n = n-1
                 // 13:       DUP;
                 // 14:       PUSH loop
                 // 16:       JUMPI
                 //             00  .   .   .   .   05  .   .   .   .   10  .   .   .   .   15  .   .
                 <program>   b"\x60\x00\x61\x27\x10\x5b\x90\x81\x01\x90\x60\x01\x03\x80\x60\x05\x57\x00" </program>
                 <jumpDests> b"\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>

                 // ------- Dynamic -----------------------------------------------------------------------------
                 <wordStack> (ListItem(N) ListItem(SUM)) => (ListItem(0) ListItem(chop(SUM +Int N))) </wordStack>
                 <pc>        5                           => 17                                       </pc>
                 <gas>       GAS_CELL:Int                => (GAS_CELL:Int -Int 35)                   </gas>
                 // ---------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 35 <=Int GAS_CELL:Int
       andBool 0 ==Int chop(1 -Int N)
       andBool SCHEDULE_CELL ==K CANCUN


    claim  <k>        #execute               </k>
           <schedule> SCHEDULE_CELL:Schedule </schedule>
           <ethereum>
             <evm>
               <callState>
                 //  0:       PUSH(1) 0                 // s = 0
                 //  2:       PUSH(2) 10,000            // n = 10000
                 //  5: loop: JUMPDEST
                 //  6:       SWAP; DUP 2; ADD; SWAP    // s = s+n
                 // 10:       PUSH(1) 1; SUB            // n = n-1
                 // 13:       DUP;
                 // 14:       PUSH loop
                 // 16:       JUMPI
                 //             00  .   .   .   .   05  .   .   .   .   10  .   .   .   .   15  .   .
                 <program>   b"\x60\x00\x61\x27\x10\x5b\x90\x81\x01\x90\x60\x01\x03\x80\x60\x05\x57\x00" </program>
                 <jumpDests> b"\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" </jumpDests>

                 // ------- Dynamic -------------------------------------------------------------------------------------------
                 <wordStack> (ListItem(N) ListItem(SUM)) => (ListItem(chop(1 -Int N)) ListItem(chop(SUM +Int N))) </wordStack>
                 // TODO: Cannot use pc=5, because of error:
                 // "The configuration's term unifies with the destination's term, but the implication check between the conditions has failed."
                 <pc>        6                           => 5                                                     </pc>
                 <gas>       GAS_CELL:Int                => (GAS_CELL:Int -Int 34)                                </gas>
                 // -----------------------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 34 <=Int GAS_CELL:Int
       andBool 0 =/=Int chop(1 -Int N)
       andBool SCHEDULE_CELL ==K CANCUN

endmodule
