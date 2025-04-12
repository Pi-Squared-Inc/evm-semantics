requires "evm.md"

module SUM_TO_N
    imports EVM

    rule [STNSTART]:  <k>        #execute               </k>
           <ethereum>
             <evm>
               <callState>
                 <wordStack> .List => (ListItem(65535) ListItem(0)) </wordStack>
                 <pc>   0  => 5 </pc>
                 <gas> GAS_CELL:Int => (GAS_CELL:Int -Int 6)
                 </gas>
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 6  <=Int GAS_CELL:Int


    rule [STNEND]:  <k>        #execute               </k>
           <ethereum>
             <evm>
               <callState>
                 // ------- Dynamic -----------------------------------------------------------------------------
                 <wordStack> (ListItem(N) ListItem(SUM)) => (ListItem(0) ListItem(chop(SUM +Int N))) </wordStack>
                 <pc>        5                           => 17                                       </pc>
                 <gas>       GAS_CELL:Int                => (GAS_CELL:Int -Int 38)                   </gas>
                 // ---------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 38 <=Int GAS_CELL:Int
       andBool 0 ==Int chop(N -Int 1)


    rule [STNCONT]:  <k>        #execute               </k>
           <ethereum>
             <evm>
               <callState>
                 // ------- Dynamic -------------------------------------------------------------------------------------------
                 <wordStack> (ListItem(N) ListItem(SUM)) => (ListItem(chop(N -Int 1)) ListItem(chop(SUM +Int N))) </wordStack>
                 <pc>        5                           => 5                                                     </pc>
                 <gas>       GAS_CELL:Int                => (GAS_CELL:Int -Int 38)                                </gas>
                 // -----------------------------------------------------------------------------------------------------------
                 ...
               </callState>
               ...
             </evm>
             ...
           </ethereum>
       requires 38 <=Int GAS_CELL:Int
       andBool 0 =/=Int chop(N -Int 1)

endmodule
