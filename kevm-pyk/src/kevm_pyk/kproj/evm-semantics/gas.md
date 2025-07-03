KEVM Gas
========

Here is a representation of `Gas`. This sort is used by `<gas>`, `<callGas>`, and `<gasUsed>` cells of the EVM configuration. As is in this file, `Gas` is a super-sort of `Int` with no differing behaviour. However the distinction at this level allows for an extension of infinite gas later, see `infinite-gas.md`.

```k
requires "schedule.md"

module GAS-SYNTAX
    imports MINT

    syntax MInt{256}
    syntax Gas ::= MInt{256}
    syntax MInt{256} ::= "gas2MInt256" "(" Gas ")" [function, total]

    syntax Gas ::= "minGas" "(" Gas "," Gas ")" [function, total]
                 > left:
                   Gas "*Gas" Gas [function, total]
                 | Gas "/Gas" Gas [function]
                 > left:
                   Gas "+Gas" Gas [function, total]
                 | Gas "-Gas" Gas [function, total]

    syntax Bool ::= Gas  "<Gas" Gas [function, total]
                  | Gas "<=Gas" Gas [function, total]
endmodule

module GAS
    imports BOOL
    imports GAS-SYNTAX
    imports GAS-SIMPLIFICATION
    imports GAS-FEES

    rule I1:MInt{256} *Gas I2:MInt{256} => I1 *MInt  I2
    rule I1:MInt{256} /Gas I2:MInt{256} => I1 /uMInt I2
    rule I1:MInt{256} +Gas I2:MInt{256} => I1 +MInt  I2
    rule I1:MInt{256} -Gas I2:MInt{256} => I1 -MInt  I2

    rule I1:MInt{256}  <Gas I2:MInt{256} => I1  <uMInt I2
    rule I1:MInt{256} <=Gas I2:MInt{256} => I1 <=uMInt I2

    rule minGas(I1:MInt{256}, I2:MInt{256}) => uMinMInt(I1, I2)
    rule gas2MInt256(G:MInt{256}) => G
endmodule
```

KEVM Infinite Gas
=================

Here we use the construct `#gas` to represent positive infinity, while tracking the gas formula through execution.
This allows (i) computing final gas used, and (ii) never stopping because of out-of-gas.
Note that the argument to `#gas(_)` is just metadata tracking the current gas usage, and is not meant to be compared to other values.
As such, any `#gas(G)` and `#gas(G')` are the _same_ positive infinite, regardless of the values `G` and `G'`.
In particular, this means that `#gas(_) <Gas #gas(_) => false`, and `#gas(_) <=Gas #gas(_) => true`, regardless of the values contained in the `#gas(_)`.

```k
//module INFINITE-GAS
//    imports GAS
//
//    syntax Gas ::= #gas(Int) [symbol(infGas), smtlib(infGas)]
// // ---------------------------------------------------------
//
//    rule #gas(G) +Gas G'       => #gas(G +Int G')
//    rule #gas(G) -Gas G'       => #gas(G -Int G')
//    rule #gas(G) *Gas G'       => #gas(G *Int G')
//    rule #gas(G) /Gas G'       => #gas(G /Int G')  requires G' =/=Int 0
//    rule      G  +Gas #gas(G') => #gas(G +Int G')
//    rule      G  -Gas #gas(G') => #gas(G -Int G')
//    rule      G  *Gas #gas(G') => #gas(G *Int G')
//    rule      G  /Gas #gas(G') => #gas(G /Int G')  requires G' =/=Int 0
//    rule #gas(G) +Gas #gas(G') => #gas(G +Int G')
//    rule #gas(G) -Gas #gas(G') => #gas(G -Int G')
//    rule #gas(G) *Gas #gas(G') => #gas(G *Int G')
//    rule #gas(G) /Gas #gas(G') => #gas(G /Int G')  requires G' =/=Int 0
//
//    rule _:Int    <Gas #gas(_) => true
//    rule #gas(_)  <Gas _       => false [simplification]
//    rule #gas(_) <=Gas _:Int   => false
//    rule _       <=Gas #gas(_) => true  [simplification]
//
//    rule minGas(#gas(G), #gas(G')) => #gas(minInt(G, G'))
//    rule minGas(G:Int  , #gas(G')) => #gas(minInt(G, G'))
//    rule minGas(#gas(G), G':Int)   => #gas(minInt(G, G'))
//
//    rule gas2Int(#gas(G)) => G
//
//    rule #allBut64th(#gas(G)) => #gas(#allBut64th(G))
//    rule Cgascap(SCHED, #gas(GCAP), #gas(GAVAIL), GEXTRA) => #gas(Cgascap(SCHED, GCAP, GAVAIL, GEXTRA)) [simplification]
//    rule Cgascap(SCHED, #gas(GCAP), GAVAIL:Int, GEXTRA)   => #gas(Cgascap(SCHED, GCAP, GAVAIL, GEXTRA)) [simplification]
//    rule Cgascap(SCHED, GCAP:Int, #gas(GAVAIL), GEXTRA)   => #gas(Cgascap(SCHED, GCAP, GAVAIL, GEXTRA)) [simplification]
//
//    rule #if B #then #gas(G) #else #gas(G') #fi => #gas(#if B #then G #else G' #fi) [simplification]
//endmodule
```

KEVM Gas Fees
=============

Here are some internal helper functions for calculating gas. Most of these functions are specified in the YellowPaper.

```k
module GAS-FEES
    imports GAS-SYNTAX
    imports SCHEDULE

    syntax Gas       ::= Cgascap            ( Schedule , Gas ,       Gas ,       MInt{256} ) [symbol(Cgascap_Gas), overload(Cgascap), function, total, smtlib(gas_Cgascap_Gas)]
    syntax MInt{256} ::= Cgascap            ( Schedule , MInt{256} , MInt{256} , MInt{256} ) [symbol(Cgascap_Int), overload(Cgascap), function, total, smtlib(gas_Cgascap_Int)]

    syntax MInt{256} ::= Csstore            ( Schedule , MInt{256} , MInt{256} , MInt{256} ) [symbol(Csstore),             function, total, smtlib(gas_Csstore)            ]
//                     | Rsstore            ( Schedule , MInt{256} , MInt{256} , MInt{256} ) [symbol(Rsstore),             function, total, smtlib(gas_Rsstore)            ]
                       | Cextra             ( Schedule , Bool , MInt{256} , Bool, Bool, Bool ) [symbol(Cextra),            function, total, smtlib(gas_Cextra)             ]
                       | Cnew               ( Schedule , Bool , MInt{256} )                  [symbol(Cnew),                function, total, smtlib(gas_Cnew)               ]
                       | Cxfer              ( Schedule , MInt{256} )                         [symbol(Cxfer),               function, total, smtlib(gas_Cxfer)              ]
                       | Cmem               ( Schedule , MInt{256} )                         [symbol(Cmem),                function, total, smtlib(gas_Cmem), memo         ]
                       | Caddraccess        ( Schedule , Bool )                              [symbol(Caddraccess),         function, total, smtlib(gas_Caddraccess)        ]
                       | Cstorageaccess     ( Schedule , Bool )                              [symbol(Cstorageaccess),      function, total, smtlib(gas_Cstorageaccess)     ]
                       | Csload             ( Schedule , Bool )                              [symbol(Csload),              function, total, smtlib(gas_Csload)             ]
                       | Cextcodesize       ( Schedule )                                     [symbol(Cextcodesize),        function, total, smtlib(gas_Cextcodesize)       ]
                       | Cextcodecopy       ( Schedule , MInt{256} )                         [symbol(Cextcodecopy),        function, total, smtlib(gas_Cextcodecopy)       ]
                       | Cextcodehash       ( Schedule )                                     [symbol(Cextcodehash),        function, total, smtlib(gas_Cextcodehash)       ]
                       | Cbalance           ( Schedule )                                     [symbol(Cbalance),            function, total, smtlib(gas_Cbalance)           ]
                       | Cmodexp            ( Schedule , Bytes , MInt{256} , MInt{256} , MInt{256} ) [symbol(Cmodexp),     function, total, smtlib(gas_Cmodexp)            ]
                       | Cinitcode          ( Schedule , MInt{256} )                         [symbol(Cinitcode),           function, total, smtlib(gas_Cinitcode)          ]
                       | Cbls12g1MsmDiscount( Schedule , MInt{256} )                         [symbol(Cbls12g1MsmDiscount), function, total, smtlib(gas_Cbls12g1MsmDiscount)]
                       | Cbls12g2MsmDiscount( Schedule , MInt{256} )                         [symbol(Cbls12g2MsmDiscount), function, total, smtlib(gas_Cbls12g2MsmDiscount)]
                       | Cdelegationaccess  ( Schedule, Bool, Bool )                         [symbol(Cdelegationaccess),   function, total, smtlib(gas_Cdelegationaccess)  ]

 // ------------------------------------------------------------------------------------------------------------------------------------------
    rule [Cgascap]:
         Cgascap(SCHED, GCAP:MInt{256}, GAVAIL:MInt{256}, GEXTRA)
      => #if GAVAIL <uMInt GEXTRA orBool Gstaticcalldepth << SCHED >> #then GCAP #else uMinMInt(#allBut64th(GAVAIL -MInt GEXTRA), GCAP) #fi
      [concrete]

    rule [Csstore.new]:
         Csstore(SCHED, NEW, CURR, ORIG)
      => #if CURR ==MInt NEW orBool ORIG =/=MInt CURR #then Gsload < SCHED > #else #if ORIG ==MInt 0p256 #then Gsstoreset < SCHED > #else Gsstorereset < SCHED > #fi #fi
      requires Ghasdirtysstore << SCHED >>
      [concrete]

    rule [Csstore.old]:
         Csstore(SCHED, NEW, CURR, _ORIG)
      => #if CURR ==MInt 0p256 andBool NEW =/=MInt 0p256 #then Gsstoreset < SCHED > #else Gsstorereset < SCHED > #fi
      requires notBool Ghasdirtysstore << SCHED >>
      [concrete]

    //rule [Rsstore.new]:
    //     Rsstore(SCHED, NEW, CURR, ORIG)
    //  => #if CURR =/=Int NEW andBool ORIG ==Int CURR andBool NEW ==Int 0 #then
    //         Rsstoreclear < SCHED >
    //     #else
    //         #if CURR =/=Int NEW andBool ORIG =/=Int CURR andBool ORIG =/=Int 0 #then
    //             #if CURR ==Int 0 #then 0 -Int Rsstoreclear < SCHED > #else #if NEW ==Int 0 #then Rsstoreclear < SCHED > #else 0 #fi #fi
    //         #else
    //             0
    //         #fi +Int
    //         #if CURR =/=Int NEW andBool ORIG ==Int NEW #then
    //             #if ORIG ==Int 0 #then Gsstoreset < SCHED > #else Gsstorereset < SCHED > #fi -Int Gsload < SCHED >
    //         #else
    //             0
    //         #fi
    //     #fi
    //  requires Ghasdirtysstore << SCHED >>
    //  [concrete]

    //rule [Rsstore.old]:
    //     Rsstore(SCHED, NEW, CURR, _ORIG)
    //  => #if CURR =/=Int 0 andBool NEW ==Int 0 #then Rsstoreclear < SCHED > #else 0 #fi
    //  requires notBool Ghasdirtysstore << SCHED >>
    //  [concrete]

    rule [Cextra.delegation]: Cextra(SCHED, ISEMPTY, VALUE, ISWARM ,  ISDELEGATION,  ISWARMDELEGATION) => Cdelegationaccess(SCHED, ISDELEGATION, ISWARMDELEGATION) +MInt Caddraccess(SCHED, ISWARM) +MInt Cnew(SCHED, ISEMPTY, VALUE) +MInt Cxfer(SCHED, VALUE) requires         Ghasaccesslist << SCHED >> andBool         Ghasdelegation << SCHED >>
    rule [Cextra.new]:        Cextra(SCHED, ISEMPTY, VALUE, ISWARM , _ISDELEGATION, _ISWARMDELEGATION) => Caddraccess(SCHED, ISWARM) +MInt Cnew(SCHED, ISEMPTY, VALUE) +MInt Cxfer(SCHED, VALUE)                                                               requires         Ghasaccesslist << SCHED >> andBool notBool Ghasdelegation << SCHED >>
    rule [Cextra.old]:        Cextra(SCHED, ISEMPTY, VALUE, _ISWARM, _ISDELEGATION, _ISWARMDELEGATION) => Gcall < SCHED > +MInt Cnew(SCHED, ISEMPTY, VALUE) +MInt Cxfer(SCHED, VALUE)                                                                                      requires notBool Ghasaccesslist << SCHED >>

    rule [Cnew]:
         Cnew(SCHED, ISEMPTY:Bool, VALUE)
      => #if ISEMPTY andBool (VALUE =/=MInt 0p256 orBool Gzerovaluenewaccountgas << SCHED >>) #then Gnewaccount < SCHED > #else 0p256 #fi

    rule [Cxfer.none]: Cxfer(_SCHED, 0p256) => 0p256
    rule [Cxfer.some]: Cxfer( SCHED, N) => Gcallvalue < SCHED > requires N =/=MInt 0p256

    rule [Cmem]: Cmem(SCHED, N) => (N *MInt Gmemory < SCHED >) +MInt ((N *MInt N) /uMInt Gquadcoeff < SCHED >) [concrete]

    rule [Cdelegationaccess]: Cdelegationaccess(SCHED, ISDELEGATION, ISWARM) => #if ISDELEGATION #then Caddraccess(SCHED, ISWARM) #else 0p256 #fi
    rule [Caddraccess]:    Caddraccess(SCHED, ISWARM)    => #if ISWARM #then Gwarmstorageread < SCHED > #else Gcoldaccountaccess < SCHED > #fi
    rule [Cstorageaccess]: Cstorageaccess(SCHED, ISWARM) => #if ISWARM #then Gwarmstorageread < SCHED > #else Gcoldsload < SCHED >         #fi

    rule [Csload.new]: Csload(SCHED, ISWARM)  => Cstorageaccess(SCHED, ISWARM) requires         Ghasaccesslist << SCHED >>
    rule [Csload.old]: Csload(SCHED, _ISWARM) => Gsload < SCHED >              requires notBool Ghasaccesslist << SCHED >>

    rule [Cextcodesize.new]: Cextcodesize(SCHED) => 0p256                  requires         Ghasaccesslist << SCHED >>
    rule [Cextcodesize.old]: Cextcodesize(SCHED) => Gextcodesize < SCHED > requires notBool Ghasaccesslist << SCHED >>

    rule [Cextcodehash.new]: Cextcodehash(SCHED) => 0p256              requires         Ghasaccesslist << SCHED >>
    rule [Cextcodehash.old]: Cextcodehash(SCHED) => Gbalance < SCHED > requires notBool Ghasaccesslist << SCHED >>

    rule [Cbalance.new]: Cbalance(SCHED) => 0p256              requires         Ghasaccesslist << SCHED >>
    rule [Cbalance.old]: Cbalance(SCHED) => Gbalance < SCHED > requires notBool Ghasaccesslist << SCHED >>

    rule [Cextcodecopy.new]: Cextcodecopy(SCHED, WIDTH) => Gcopy < SCHED > *MInt (WIDTH up/MInt256 32p256)                                requires         Ghasaccesslist << SCHED >> [concrete]
    rule [Cextcodecopy.old]: Cextcodecopy(SCHED, WIDTH) => Gextcodecopy < SCHED > +MInt (Gcopy < SCHED > *MInt (WIDTH up/MInt256 32p256)) requires notBool Ghasaccesslist << SCHED >> [concrete]

    rule [Cmodexp.old]: Cmodexp(SCHED, DATA, BASELEN, EXPLEN, MODLEN) => #multComplexity(uMaxMInt(BASELEN, MODLEN)) *MInt uMaxMInt(#adjustedExpLength(BASELEN, EXPLEN, DATA), 1p256) /uMInt Gquaddivisor < SCHED >
      requires notBool Ghasaccesslist << SCHED >>
      [concrete]

    rule [Cmodexp.new]: Cmodexp(SCHED, DATA, BASELEN, EXPLEN, MODLEN) => uMaxMInt(200p256, (#newMultComplexity(uMaxMInt(BASELEN, MODLEN)) *MInt uMaxMInt(#adjustedExpLength(BASELEN, EXPLEN, DATA), 1p256)) /uMInt Gquaddivisor < SCHED > )
      requires Ghasaccesslist << SCHED >>
      [concrete]

    rule [Cinitcode.new]: Cinitcode(SCHED, INITCODELEN) => Ginitcodewordcost < SCHED > *MInt ( INITCODELEN up/MInt256 32p256 ) requires         Ghasmaxinitcodesize << SCHED >> [concrete]
    rule [Cinitcode.old]: Cinitcode(SCHED, _)           => 0p256                                                               requires notBool Ghasmaxinitcodesize << SCHED >> [concrete]

    rule [Cbls12g1MsmDiscount.new]: Cbls12g1MsmDiscount(SCHED, N) => #Cbls12g1MsmDiscount( N ) requires         Ghasbls12msmdiscount << SCHED >> [concrete]
    rule [Cbls12g1MsmDiscount.old]: Cbls12g1MsmDiscount(SCHED, _) => 0p256                     requires notBool Ghasbls12msmdiscount << SCHED >> [concrete]

    rule [Cbls12g2MsmDiscount.new]: Cbls12g2MsmDiscount(SCHED, N) => #Cbls12g2MsmDiscount( N ) requires         Ghasbls12msmdiscount << SCHED >> [concrete]
    rule [Cbls12g2MsmDiscount.old]: Cbls12g2MsmDiscount(SCHED, _) => 0p256                     requires notBool Ghasbls12msmdiscount << SCHED >> [concrete]

    syntax MInt{256} ::= #Cbls12g1MsmDiscount( MInt{256} ) [function, total]
  // -----------------------------------------------------------------------
    rule #Cbls12g1MsmDiscount(0p256) => 1000p256
    rule #Cbls12g1MsmDiscount(1p256) => 1000p256
    rule #Cbls12g1MsmDiscount(2p256) => 949p256
    rule #Cbls12g1MsmDiscount(3p256) => 848p256
    rule #Cbls12g1MsmDiscount(4p256) => 797p256
    rule #Cbls12g1MsmDiscount(5p256) => 764p256
    rule #Cbls12g1MsmDiscount(6p256) => 750p256
    rule #Cbls12g1MsmDiscount(7p256) => 738p256
    rule #Cbls12g1MsmDiscount(8p256) => 728p256
    rule #Cbls12g1MsmDiscount(9p256) => 719p256
    rule #Cbls12g1MsmDiscount(10p256) => 712p256
    rule #Cbls12g1MsmDiscount(11p256) => 705p256
    rule #Cbls12g1MsmDiscount(12p256) => 698p256
    rule #Cbls12g1MsmDiscount(13p256) => 692p256
    rule #Cbls12g1MsmDiscount(14p256) => 687p256
    rule #Cbls12g1MsmDiscount(15p256) => 682p256
    rule #Cbls12g1MsmDiscount(16p256) => 677p256
    rule #Cbls12g1MsmDiscount(17p256) => 673p256
    rule #Cbls12g1MsmDiscount(18p256) => 669p256
    rule #Cbls12g1MsmDiscount(19p256) => 665p256
    rule #Cbls12g1MsmDiscount(20p256) => 661p256
    rule #Cbls12g1MsmDiscount(21p256) => 658p256
    rule #Cbls12g1MsmDiscount(22p256) => 654p256
    rule #Cbls12g1MsmDiscount(23p256) => 651p256
    rule #Cbls12g1MsmDiscount(24p256) => 648p256
    rule #Cbls12g1MsmDiscount(25p256) => 645p256
    rule #Cbls12g1MsmDiscount(26p256) => 642p256
    rule #Cbls12g1MsmDiscount(27p256) => 640p256
    rule #Cbls12g1MsmDiscount(28p256) => 637p256
    rule #Cbls12g1MsmDiscount(29p256) => 635p256
    rule #Cbls12g1MsmDiscount(30p256) => 632p256
    rule #Cbls12g1MsmDiscount(31p256) => 630p256
    rule #Cbls12g1MsmDiscount(32p256) => 627p256
    rule #Cbls12g1MsmDiscount(33p256) => 625p256
    rule #Cbls12g1MsmDiscount(34p256) => 623p256
    rule #Cbls12g1MsmDiscount(35p256) => 621p256
    rule #Cbls12g1MsmDiscount(36p256) => 619p256
    rule #Cbls12g1MsmDiscount(37p256) => 617p256
    rule #Cbls12g1MsmDiscount(38p256) => 615p256
    rule #Cbls12g1MsmDiscount(39p256) => 613p256
    rule #Cbls12g1MsmDiscount(40p256) => 611p256
    rule #Cbls12g1MsmDiscount(41p256) => 609p256
    rule #Cbls12g1MsmDiscount(42p256) => 608p256
    rule #Cbls12g1MsmDiscount(43p256) => 606p256
    rule #Cbls12g1MsmDiscount(44p256) => 604p256
    rule #Cbls12g1MsmDiscount(45p256) => 603p256
    rule #Cbls12g1MsmDiscount(46p256) => 601p256
    rule #Cbls12g1MsmDiscount(47p256) => 599p256
    rule #Cbls12g1MsmDiscount(48p256) => 598p256
    rule #Cbls12g1MsmDiscount(49p256) => 596p256
    rule #Cbls12g1MsmDiscount(50p256) => 595p256
    rule #Cbls12g1MsmDiscount(51p256) => 593p256
    rule #Cbls12g1MsmDiscount(52p256) => 592p256
    rule #Cbls12g1MsmDiscount(53p256) => 591p256
    rule #Cbls12g1MsmDiscount(54p256) => 589p256
    rule #Cbls12g1MsmDiscount(55p256) => 588p256
    rule #Cbls12g1MsmDiscount(56p256) => 586p256
    rule #Cbls12g1MsmDiscount(57p256) => 585p256
    rule #Cbls12g1MsmDiscount(58p256) => 584p256
    rule #Cbls12g1MsmDiscount(59p256) => 582p256
    rule #Cbls12g1MsmDiscount(60p256) => 581p256
    rule #Cbls12g1MsmDiscount(61p256) => 580p256
    rule #Cbls12g1MsmDiscount(62p256) => 579p256
    rule #Cbls12g1MsmDiscount(63p256) => 577p256
    rule #Cbls12g1MsmDiscount(64p256) => 576p256
    rule #Cbls12g1MsmDiscount(65p256) => 575p256
    rule #Cbls12g1MsmDiscount(66p256) => 574p256
    rule #Cbls12g1MsmDiscount(67p256) => 573p256
    rule #Cbls12g1MsmDiscount(68p256) => 572p256
    rule #Cbls12g1MsmDiscount(69p256) => 570p256
    rule #Cbls12g1MsmDiscount(70p256) => 569p256
    rule #Cbls12g1MsmDiscount(71p256) => 568p256
    rule #Cbls12g1MsmDiscount(72p256) => 567p256
    rule #Cbls12g1MsmDiscount(73p256) => 566p256
    rule #Cbls12g1MsmDiscount(74p256) => 565p256
    rule #Cbls12g1MsmDiscount(75p256) => 564p256
    rule #Cbls12g1MsmDiscount(76p256) => 563p256
    rule #Cbls12g1MsmDiscount(77p256) => 562p256
    rule #Cbls12g1MsmDiscount(78p256) => 561p256
    rule #Cbls12g1MsmDiscount(79p256) => 560p256
    rule #Cbls12g1MsmDiscount(80p256) => 559p256
    rule #Cbls12g1MsmDiscount(81p256) => 558p256
    rule #Cbls12g1MsmDiscount(82p256) => 557p256
    rule #Cbls12g1MsmDiscount(83p256) => 556p256
    rule #Cbls12g1MsmDiscount(84p256) => 555p256
    rule #Cbls12g1MsmDiscount(85p256) => 554p256
    rule #Cbls12g1MsmDiscount(86p256) => 553p256
    rule #Cbls12g1MsmDiscount(87p256) => 552p256
    rule #Cbls12g1MsmDiscount(88p256) => 551p256
    rule #Cbls12g1MsmDiscount(89p256) => 550p256
    rule #Cbls12g1MsmDiscount(90p256) => 549p256
    rule #Cbls12g1MsmDiscount(91p256) => 548p256
    rule #Cbls12g1MsmDiscount(92p256) => 547p256
    rule #Cbls12g1MsmDiscount(93p256) => 547p256
    rule #Cbls12g1MsmDiscount(94p256) => 546p256
    rule #Cbls12g1MsmDiscount(95p256) => 545p256
    rule #Cbls12g1MsmDiscount(96p256) => 544p256
    rule #Cbls12g1MsmDiscount(97p256) => 543p256
    rule #Cbls12g1MsmDiscount(98p256) => 542p256
    rule #Cbls12g1MsmDiscount(99p256) => 541p256
    rule #Cbls12g1MsmDiscount(100p256) => 540p256
    rule #Cbls12g1MsmDiscount(101p256) => 540p256
    rule #Cbls12g1MsmDiscount(102p256) => 539p256
    rule #Cbls12g1MsmDiscount(103p256) => 538p256
    rule #Cbls12g1MsmDiscount(104p256) => 537p256
    rule #Cbls12g1MsmDiscount(105p256) => 536p256
    rule #Cbls12g1MsmDiscount(106p256) => 536p256
    rule #Cbls12g1MsmDiscount(107p256) => 535p256
    rule #Cbls12g1MsmDiscount(108p256) => 534p256
    rule #Cbls12g1MsmDiscount(109p256) => 533p256
    rule #Cbls12g1MsmDiscount(110p256) => 532p256
    rule #Cbls12g1MsmDiscount(111p256) => 532p256
    rule #Cbls12g1MsmDiscount(112p256) => 531p256
    rule #Cbls12g1MsmDiscount(113p256) => 530p256
    rule #Cbls12g1MsmDiscount(114p256) => 529p256
    rule #Cbls12g1MsmDiscount(115p256) => 528p256
    rule #Cbls12g1MsmDiscount(116p256) => 528p256
    rule #Cbls12g1MsmDiscount(117p256) => 527p256
    rule #Cbls12g1MsmDiscount(118p256) => 526p256
    rule #Cbls12g1MsmDiscount(119p256) => 525p256
    rule #Cbls12g1MsmDiscount(120p256) => 525p256
    rule #Cbls12g1MsmDiscount(121p256) => 524p256
    rule #Cbls12g1MsmDiscount(122p256) => 523p256
    rule #Cbls12g1MsmDiscount(123p256) => 522p256
    rule #Cbls12g1MsmDiscount(124p256) => 522p256
    rule #Cbls12g1MsmDiscount(125p256) => 521p256
    rule #Cbls12g1MsmDiscount(126p256) => 520p256
    rule #Cbls12g1MsmDiscount(127p256) => 520p256
    rule #Cbls12g1MsmDiscount(128p256) => 519p256
    rule #Cbls12g1MsmDiscount(N) => 519p256 requires N >uMInt 128p256

    syntax MInt{256} ::= #Cbls12g2MsmDiscount( MInt{256} ) [function, total]
  // -----------------------------------------------------------------------
    rule #Cbls12g2MsmDiscount(0p256) => 1000p256
    rule #Cbls12g2MsmDiscount(1p256) => 1000p256
    rule #Cbls12g2MsmDiscount(2p256) => 1000p256
    rule #Cbls12g2MsmDiscount(3p256) => 923p256
    rule #Cbls12g2MsmDiscount(4p256) => 884p256
    rule #Cbls12g2MsmDiscount(5p256) => 855p256
    rule #Cbls12g2MsmDiscount(6p256) => 832p256
    rule #Cbls12g2MsmDiscount(7p256) => 812p256
    rule #Cbls12g2MsmDiscount(8p256) => 796p256
    rule #Cbls12g2MsmDiscount(9p256) => 782p256
    rule #Cbls12g2MsmDiscount(10p256) => 770p256
    rule #Cbls12g2MsmDiscount(11p256) => 759p256
    rule #Cbls12g2MsmDiscount(12p256) => 749p256
    rule #Cbls12g2MsmDiscount(13p256) => 740p256
    rule #Cbls12g2MsmDiscount(14p256) => 732p256
    rule #Cbls12g2MsmDiscount(15p256) => 724p256
    rule #Cbls12g2MsmDiscount(16p256) => 717p256
    rule #Cbls12g2MsmDiscount(17p256) => 711p256
    rule #Cbls12g2MsmDiscount(18p256) => 704p256
    rule #Cbls12g2MsmDiscount(19p256) => 699p256
    rule #Cbls12g2MsmDiscount(20p256) => 693p256
    rule #Cbls12g2MsmDiscount(21p256) => 688p256
    rule #Cbls12g2MsmDiscount(22p256) => 683p256
    rule #Cbls12g2MsmDiscount(23p256) => 679p256
    rule #Cbls12g2MsmDiscount(24p256) => 674p256
    rule #Cbls12g2MsmDiscount(25p256) => 670p256
    rule #Cbls12g2MsmDiscount(26p256) => 666p256
    rule #Cbls12g2MsmDiscount(27p256) => 663p256
    rule #Cbls12g2MsmDiscount(28p256) => 659p256
    rule #Cbls12g2MsmDiscount(29p256) => 655p256
    rule #Cbls12g2MsmDiscount(30p256) => 652p256
    rule #Cbls12g2MsmDiscount(31p256) => 649p256
    rule #Cbls12g2MsmDiscount(32p256) => 646p256
    rule #Cbls12g2MsmDiscount(33p256) => 643p256
    rule #Cbls12g2MsmDiscount(34p256) => 640p256
    rule #Cbls12g2MsmDiscount(35p256) => 637p256
    rule #Cbls12g2MsmDiscount(36p256) => 634p256
    rule #Cbls12g2MsmDiscount(37p256) => 632p256
    rule #Cbls12g2MsmDiscount(38p256) => 629p256
    rule #Cbls12g2MsmDiscount(39p256) => 627p256
    rule #Cbls12g2MsmDiscount(40p256) => 624p256
    rule #Cbls12g2MsmDiscount(41p256) => 622p256
    rule #Cbls12g2MsmDiscount(42p256) => 620p256
    rule #Cbls12g2MsmDiscount(43p256) => 618p256
    rule #Cbls12g2MsmDiscount(44p256) => 615p256
    rule #Cbls12g2MsmDiscount(45p256) => 613p256
    rule #Cbls12g2MsmDiscount(46p256) => 611p256
    rule #Cbls12g2MsmDiscount(47p256) => 609p256
    rule #Cbls12g2MsmDiscount(48p256) => 607p256
    rule #Cbls12g2MsmDiscount(49p256) => 606p256
    rule #Cbls12g2MsmDiscount(50p256) => 604p256
    rule #Cbls12g2MsmDiscount(51p256) => 602p256
    rule #Cbls12g2MsmDiscount(52p256) => 600p256
    rule #Cbls12g2MsmDiscount(53p256) => 598p256
    rule #Cbls12g2MsmDiscount(54p256) => 597p256
    rule #Cbls12g2MsmDiscount(55p256) => 595p256
    rule #Cbls12g2MsmDiscount(56p256) => 593p256
    rule #Cbls12g2MsmDiscount(57p256) => 592p256
    rule #Cbls12g2MsmDiscount(58p256) => 590p256
    rule #Cbls12g2MsmDiscount(59p256) => 589p256
    rule #Cbls12g2MsmDiscount(60p256) => 587p256
    rule #Cbls12g2MsmDiscount(61p256) => 586p256
    rule #Cbls12g2MsmDiscount(62p256) => 584p256
    rule #Cbls12g2MsmDiscount(63p256) => 583p256
    rule #Cbls12g2MsmDiscount(64p256) => 582p256
    rule #Cbls12g2MsmDiscount(65p256) => 580p256
    rule #Cbls12g2MsmDiscount(66p256) => 579p256
    rule #Cbls12g2MsmDiscount(67p256) => 578p256
    rule #Cbls12g2MsmDiscount(68p256) => 576p256
    rule #Cbls12g2MsmDiscount(69p256) => 575p256
    rule #Cbls12g2MsmDiscount(70p256) => 574p256
    rule #Cbls12g2MsmDiscount(71p256) => 573p256
    rule #Cbls12g2MsmDiscount(72p256) => 571p256
    rule #Cbls12g2MsmDiscount(73p256) => 570p256
    rule #Cbls12g2MsmDiscount(74p256) => 569p256
    rule #Cbls12g2MsmDiscount(75p256) => 568p256
    rule #Cbls12g2MsmDiscount(76p256) => 567p256
    rule #Cbls12g2MsmDiscount(77p256) => 566p256
    rule #Cbls12g2MsmDiscount(78p256) => 565p256
    rule #Cbls12g2MsmDiscount(79p256) => 563p256
    rule #Cbls12g2MsmDiscount(80p256) => 562p256
    rule #Cbls12g2MsmDiscount(81p256) => 561p256
    rule #Cbls12g2MsmDiscount(82p256) => 560p256
    rule #Cbls12g2MsmDiscount(83p256) => 559p256
    rule #Cbls12g2MsmDiscount(84p256) => 558p256
    rule #Cbls12g2MsmDiscount(85p256) => 557p256
    rule #Cbls12g2MsmDiscount(86p256) => 556p256
    rule #Cbls12g2MsmDiscount(87p256) => 555p256
    rule #Cbls12g2MsmDiscount(88p256) => 554p256
    rule #Cbls12g2MsmDiscount(89p256) => 553p256
    rule #Cbls12g2MsmDiscount(90p256) => 552p256
    rule #Cbls12g2MsmDiscount(91p256) => 552p256
    rule #Cbls12g2MsmDiscount(92p256) => 551p256
    rule #Cbls12g2MsmDiscount(93p256) => 550p256
    rule #Cbls12g2MsmDiscount(94p256) => 549p256
    rule #Cbls12g2MsmDiscount(95p256) => 548p256
    rule #Cbls12g2MsmDiscount(96p256) => 547p256
    rule #Cbls12g2MsmDiscount(97p256) => 546p256
    rule #Cbls12g2MsmDiscount(98p256) => 545p256
    rule #Cbls12g2MsmDiscount(99p256) => 545p256
    rule #Cbls12g2MsmDiscount(100p256) => 544p256
    rule #Cbls12g2MsmDiscount(101p256) => 543p256
    rule #Cbls12g2MsmDiscount(102p256) => 542p256
    rule #Cbls12g2MsmDiscount(103p256) => 541p256
    rule #Cbls12g2MsmDiscount(104p256) => 541p256
    rule #Cbls12g2MsmDiscount(105p256) => 540p256
    rule #Cbls12g2MsmDiscount(106p256) => 539p256
    rule #Cbls12g2MsmDiscount(107p256) => 538p256
    rule #Cbls12g2MsmDiscount(108p256) => 537p256
    rule #Cbls12g2MsmDiscount(109p256) => 537p256
    rule #Cbls12g2MsmDiscount(110p256) => 536p256
    rule #Cbls12g2MsmDiscount(111p256) => 535p256
    rule #Cbls12g2MsmDiscount(112p256) => 535p256
    rule #Cbls12g2MsmDiscount(113p256) => 534p256
    rule #Cbls12g2MsmDiscount(114p256) => 533p256
    rule #Cbls12g2MsmDiscount(115p256) => 532p256
    rule #Cbls12g2MsmDiscount(116p256) => 532p256
    rule #Cbls12g2MsmDiscount(117p256) => 531p256
    rule #Cbls12g2MsmDiscount(118p256) => 530p256
    rule #Cbls12g2MsmDiscount(119p256) => 530p256
    rule #Cbls12g2MsmDiscount(120p256) => 529p256
    rule #Cbls12g2MsmDiscount(121p256) => 528p256
    rule #Cbls12g2MsmDiscount(122p256) => 528p256
    rule #Cbls12g2MsmDiscount(123p256) => 527p256
    rule #Cbls12g2MsmDiscount(124p256) => 526p256
    rule #Cbls12g2MsmDiscount(125p256) => 526p256
    rule #Cbls12g2MsmDiscount(126p256) => 525p256
    rule #Cbls12g2MsmDiscount(127p256) => 524p256
    rule #Cbls12g2MsmDiscount(128p256) => 524p256
    rule #Cbls12g2MsmDiscount(N) => 524p256 requires N >uMInt 128p256

//    syntax Bool ::= #accountEmpty ( AccountCode , Int , Int ) [function, total, symbol(accountEmpty)]
// // -------------------------------------------------------------------------------------------------
//    rule #accountEmpty(CODE, NONCE, BAL) => CODE ==K .Bytes andBool NONCE ==Int 0 andBool BAL ==Int 0

    syntax Gas       ::= #allBut64th ( Gas       ) [symbol(#allBut64th_Gas), overload(#allBut64th), function, total, smtlib(gas_allBut64th_Gas)]
    syntax MInt{256} ::= #allBut64th ( MInt{256} ) [symbol(#allBut64th_Int), overload(#allBut64th), function, total, smtlib(gas_allBut64th_Int)]
 // --------------------------------------------------------------------------------------------------------------------------------------------
    rule [allBut64th.pos]: #allBut64th(N) => N -MInt (N /uMInt 64p256)

//    syntax Int ::= G0 ( Schedule , Bytes , Bool )           [function, symbol(G0base)]
//                 | G0 ( Schedule , Bytes , Int , Int, Int ) [function, symbol(G0data)]
// // ----------------------------------------------------------------------------------
//    rule G0(SCHED, WS, false) => G0(SCHED, WS, 0, lengthBytes(WS), 0) +Int Gtransaction < SCHED >
//    rule G0(SCHED, WS, true)  => G0(SCHED, WS, 0, lengthBytes(WS), 0) +Int Gtxcreate < SCHED > +Int Cinitcode(SCHED, lengthBytes(WS))
//
//    rule G0(    _,  _, I, I, R) => R
//    rule G0(SCHED, WS, I, J, R) => G0(SCHED, WS, I +Int 1, J, R +Int #if WS[I] ==Int 0 #then Gtxdatazero < SCHED > #else Gtxdatanonzero < SCHED > #fi) [owise]

//    syntax Gas ::= "G*" "(" Gas "," Int "," Int "," Schedule ")" [function]
// // -----------------------------------------------------------------------
//    rule G*(GAVAIL, GLIMIT, REFUND, SCHED) => GAVAIL +Gas minGas((GLIMIT -Gas GAVAIL) /Gas Rmaxquotient < SCHED >, REFUND)

    syntax MInt{256} ::= #multComplexity(MInt{256})    [symbol(#multComplexity),    function]
                       | #newMultComplexity(MInt{256}) [symbol(#newMultComplexity), function]
 // -----------------------------------------------------------------------------------------
    rule #multComplexity(X) => X *MInt X                                                        requires X <=uMInt 64p256
    rule #multComplexity(X) => X *MInt X /uMInt 4p256  +MInt 96p256  *MInt X -MInt 3072p256     requires X >uMInt 64p256 andBool X <=uMInt 1024p256
    rule #multComplexity(X) => X *MInt X /uMInt 16p256 +MInt 480p256 *MInt X -MInt 199680p256   requires X >uMInt 1024p256

    rule #newMultComplexity(X) => (X up/MInt256 8p256) ^MInt 2p256

    syntax MInt{256} ::= #adjustedExpLength(MInt{256}, MInt{256}, Bytes) [symbol(#adjustedExpLength),    function]
                       | #adjustedExpLength(MInt{256})                   [symbol(#adjustedExpLengthAux), function]
 // --------------------------------------------------------------------------------------------------------------
    rule #adjustedExpLength(BASELEN, EXPLEN, DATA) => #if EXPLEN <=uMInt 32p256 #then 0p256 #else 8p256 *MInt (EXPLEN -MInt 32p256) #fi +MInt #adjustedExpLength(Bytes2MInt(#rangeMInt256(DATA, 96p256 +MInt BASELEN, uMinMInt(EXPLEN, 32p256)))::MInt{256})

    rule #adjustedExpLength(0p256) => 0p256
    rule #adjustedExpLength(1p256) => 0p256
    rule #adjustedExpLength(N)     => 1p256 +MInt #adjustedExpLength(N /uMInt 2p256) requires N >uMInt 1p256
endmodule
```

KEVM Gas Simplifications
========================

Here are simplification rules related to gas that the haskell backend uses.

```k
module GAS-SIMPLIFICATION [symbolic]
    imports GAS-SYNTAX
    imports INT
    imports BOOL

    rule A <Gas B => false requires B <=Gas A [simplification]
endmodule
```
