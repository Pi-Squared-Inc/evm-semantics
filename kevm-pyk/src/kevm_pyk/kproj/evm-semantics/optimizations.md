KEVM Optimizations
==================

These optimizations work on the LLVM and Haskell backend and are generated by the script `./optimizer/optimizations.sh`.

```k
requires "evm.md"
requires "lemmas/int-simplification.k"

module EVM-OPTIMIZATIONS-LEMMAS
  imports EVM

    rule #sizeWordStack(WS           , N) => #sizeWordStack(WS, 0) +Int N requires N =/=Int 0                [simplification]
    rule #sizeWordStack(WS [ I := _ ], N) => #sizeWordStack(WS, N)        requires I <Int #sizeWordStack(WS) [simplification]
    rule 0 <=Int #sizeWordStack(_ , 0)    => true                                                            [simplification]
    rule #sizeWordStack(_ , 0) <Int N     => false                        requires N <=Int 0                 [simplification]

endmodule

module EVM-OPTIMIZATIONS
  imports EVM
  imports EVM-OPTIMIZATIONS-LEMMAS
  imports INT-SIMPLIFICATION

  rule
    <kevm>
      <k>
        ( #next[ PUSHZERO ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( WS => pushList(0, WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( ( GAVAIL -Gas Gbase < SCHED > ) ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gbase < SCHED > <=Gas GAVAIL )
     andBool ( size(WS) <=Int 1023 )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ PUSH(N) ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <program>
              PGM
            </program>
            <wordStack>
              ( WS => pushList(#asWord( #range(PGM, PCOUNT +Int 1, N) ), WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( ( PCOUNT +Int N ) +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     andBool ( size( WS ) <=Int 1023 )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ DUP(N) ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( WS => pushList(WS [ ( N +Int -1 ) ], WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires #stackNeeded(DUP(N)) <=Int size(WS)
     andBool ( Gverylow < SCHED > <=Gas GAVAIL )
     andBool ( size( WS ) <=Int 1023 )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ SWAP(N) ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) WS => pushList(WS [ ( N +Int -1 ) ], ( WS [ ( N +Int -1 ) <- W0 ] )) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires #stackNeeded(SWAP(N)) <=Int size(WS) +Int 1
     andBool ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ ADD ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) ListItem(W1) WS => pushList(chop( ( W0 +Int W1 ) ), WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ SUB ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) ListItem(W1) WS => pushList(chop( ( W0 -Int W1 ) ), WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ AND ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) ListItem(W1) WS => pushList(W0 &Int W1, WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ LT ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) ListItem(W1) WS => pushList(bool2Word( W0 <Int W1 ), WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next[ GT ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) ListItem(W1) WS => pushList(bool2Word( W1 <Int W0 ), WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next [ ISZERO ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <wordStack>
              ( ListItem(W0) WS => pushList(bool2Word( W0 ==Int 0 ), WS) )
            </wordStack>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gverylow < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gverylow < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next [ JUMPDEST ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <pc>
              ( PCOUNT => ( PCOUNT +Int 1 ) )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gjumpdest < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gjumpdest < SCHED > <=Gas GAVAIL )
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next [ JUMP ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <jumpDests>
              DESTS
            </jumpDests>
            <wordStack>
              ( ListItem(W0) WS => WS )
            </wordStack>
            <pc>
              ( PCOUNT => W0 )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Gmid < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Gmid < SCHED > <=Gas GAVAIL )
     andBool W0 in DESTS
     [priority(40)]

  rule
    <kevm>
      <k>
        ( #next [ JUMPI ] => .K ) ...
      </k>
      <schedule>
        SCHED
      </schedule>
      <ethereum>
        <evm>
          <callState>
            <jumpDests>
              DESTS
            </jumpDests>
            <wordStack>
              ( ListItem(W0) ListItem(W1) WS => WS )
            </wordStack>
            <pc>
              ( PCOUNT => #if W1 =/=Int 0 #then W0 #else PCOUNT +Int 1 #fi )
            </pc>
            <gas>
              ( GAVAIL => ( GAVAIL -Gas Ghigh < SCHED > ) )
            </gas>
            ...
          </callState>
          ...
        </evm>
        ...
      </ethereum>
      ...
    </kevm>
    requires ( Ghigh < SCHED > <=Gas GAVAIL )
     andBool W0 in DESTS
     [priority(40)]


// {OPTIMIZATIONS}


endmodule
```
