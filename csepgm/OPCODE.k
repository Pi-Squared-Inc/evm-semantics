requires "evm.md"
module OPCODE
    imports EVM

    rule [ADD-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <wordStack> ( ListItem(W0:Int) => ListItem(chop ( ( W0:Int +Int W1:Int ) )) )
                             ( ( ListItem(W1:Int) WS ) => WS )
                   </wordStack>
                 <program> PROGRAM_CELL:Bytes </program>
                 <pc> ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) ) </pc>
                 <gas> ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) ) </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 3 <=Int GAS_CELL:Int )
       andBool PROGRAM_CELL[PC_CELL] ==Int 1
      [priority(20)]    

    rule [SUB-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   ( ListItem( W0:Int => chop ( ( W0:Int -Int W1:Int ) ) ) ( ( ListItem(W1:Int) WS:List ) => WS:List ) )
                 </wordStack>
                 <program> PROGRAM_CELL:Bytes </program>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires 3 <=Int GAS_CELL:Int
       andBool PROGRAM_CELL[PC_CELL] ==Int 3
      [priority(20)]

    rule [PUSH-1-SUMMARY-1]:
           <ethereum>
             <evm>
               <callState>
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack>
                   ( WS:List => ( ListItem(#asWord ( #range ( PROGRAM_CELL:Bytes , ( PC_CELL:Int +Int 1 ) , 1:Int ) )) WS:List ) )
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( ( PC_CELL:Int +Int 1:Int ) +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( ( notBool size ( WS:List ) <Int 0 )
       andBool ( ( notBool 1023 <Int size ( WS:List ) )
       andBool ( 3 <=Int GAS_CELL:Int
               )))
       andBool PROGRAM_CELL[PC_CELL] ==Int 96

    rule [PUSH-2-SUMMARY-1]:
           <ethereum>
             <evm>
               <callState>
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack>
                   ( WS:List => ( ListItem(#asWord ( #range ( PROGRAM_CELL:Bytes , ( PC_CELL:Int +Int 1 ) , 2 ) )) WS:List ) )
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( ( PC_CELL:Int +Int 2:Int ) +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( ( notBool size ( WS:List ) <Int 0 )
       andBool ( ( notBool 1023 <Int size ( WS:List ) )
       andBool ( 3 <=Int GAS_CELL:Int
               )))
       andBool PROGRAM_CELL[PC_CELL] ==Int 97


    rule [SWAP-1-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <wordStack>
                   WS:List
                => WS:List[1 <- WS[0]][0 <- WS[1]]
                 </wordStack>
                 <program> PROGRAM_CELL:Bytes </program>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( size ( WS:List ) <=Int 1023
       andBool ( ( 2:Int ) <=Int size ( WS:List )
       andBool ( 3 <=Int GAS_CELL:Int
               )))
       andBool PROGRAM_CELL[PC_CELL] ==Int 144
      [priority(20)]

    rule [DUP-1-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack>
                   WS:List => (ListItem(WS[ 0 ]) WS)
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( 1:Int <=Int size ( WS:List )
       andBool ( size ( WS:List ) <=Int 1023
       andBool ( 3 <=Int GAS_CELL:Int
               )))
       andBool PROGRAM_CELL[PC_CELL] ==Int 128
      [priority(20)]

    rule [DUP-2-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack>
                   WS:List => (ListItem(WS[ 1 ]) WS)
                 </wordStack>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 3 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>

      requires ( 2:Int <=Int size ( WS:List )
       andBool ( size ( WS:List ) <=Int 1023
       andBool ( 3 <=Int GAS_CELL:Int
               )))
       andBool PROGRAM_CELL[PC_CELL] ==Int 129
      [priority(20)]


    rule [JUMPDEST-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <program> PROGRAM_CELL:Bytes </program>
                 <pc>
                   ( PC_CELL:Int => ( PC_CELL:Int +Int 1 ) )
                 </pc>
                 <gas>
                   ( GAS_CELL:Int => ( GAS_CELL:Int -Int 1 ) )
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 1 <=Int GAS_CELL:Int )
       andBool PROGRAM_CELL[PC_CELL] ==Int 91
      [priority(20)]

    rule [JUMPI-TRUE-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <pc> ( PC_CELL:Int => DEST ) </pc>
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack> ( ListItem(DEST) ListItem(I) WS => WS) </wordStack>
                 <gas> ( GAS_CELL:Int => ( GAS_CELL:Int -Int 10 ) ) </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 10 <=Int GAS_CELL:Int ) andBool I =/=Int 0
       andBool PROGRAM_CELL[PC_CELL] ==Int 87
      [priority(20)]

    rule [JUMPI-FALSE-SUMMARY-0]:
           <ethereum>
             <evm>
               <callState>
                 <pc> ( PC_CELL:Int => PC_CELL +Int 1) </pc>
                 <program> PROGRAM_CELL:Bytes </program>
                 <wordStack> ( ListItem(_) ListItem(I) WS => WS) </wordStack>
                 <gas> ( GAS_CELL:Int => ( GAS_CELL:Int -Int 1 ) ) </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
      requires ( 1 <=Int GAS_CELL:Int )  andBool I ==Int 0
       andBool PROGRAM_CELL[PC_CELL] ==Int 87
      [priority(20)]

endmodule
