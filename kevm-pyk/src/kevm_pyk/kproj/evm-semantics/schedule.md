KEVM Schedules
==============

Fee Schedule
------------

The `Schedule` determines the constants/modes of operation for each hard fork.
There are `ScheduleFlag`s and `ScheduleConstant`s.

-   A `ScheduleFlag` is a boolean value determining whether a certain feature is turned on.
-   A `ScheduleConst` is an `Int` parameter which is used during EVM execution.

### Schedule Flags

A `ScheduleFlag` is a boolean determined by the fee schedule; applying a `ScheduleFlag` to a `Schedule` yields whether the flag is set or not.

```k
requires "data.md"

module SCHEDULE
    imports EVM-DATA

    syntax Schedule ::= getSchedule(Int) [function]
    rule getSchedule(0) => FRONTIER
    rule getSchedule(1) => HOMESTEAD
    rule getSchedule(2) => TANGERINE_WHISTLE
    rule getSchedule(3) => SPURIOUS_DRAGON
    rule getSchedule(4) => BYZANTIUM
    rule getSchedule(5) => CONSTANTINOPLE
    rule getSchedule(6) => PETERSBURG
    rule getSchedule(7) => ISTANBUL
    rule getSchedule(8) => BERLIN
    rule getSchedule(9) => LONDON
    rule getSchedule(10) => MERGE
    rule getSchedule(11) => SHANGHAI
    rule getSchedule(12) => CANCUN
    rule getSchedule(13) => PRAGUE

    syntax Bool ::= ScheduleFlag "<<" Schedule ">>" [function, total]
 // -----------------------------------------------------------------

    syntax ScheduleFlag ::= "Gselfdestructnewaccount" | "Gstaticcalldepth" | "Gemptyisnonexistent" | "Gzerovaluenewaccountgas"
                          | "Ghasrevert"              | "Ghasreturndata"   | "Ghasstaticcall"      | "Ghasshift"
                          | "Ghasdirtysstore"         | "Ghascreate2"      | "Ghasextcodehash"     | "Ghasselfbalance"
                          | "Ghassstorestipend"       | "Ghaschainid"      | "Ghasaccesslist"      | "Ghasbasefee"
                          | "Ghasrejectedfirstbyte"   | "Ghasprevrandao"   | "Ghasmaxinitcodesize" | "Ghaspushzero"
                          | "Ghaswarmcoinbase"        | "Ghaswithdrawals"  | "Ghastransient"       | "Ghasmcopy"
                          | "Ghasbeaconroot"          | "Ghaseip6780"      | "Ghasblobbasefee"     | "Ghasblobhash"
                          | "Ghasbls12msmdiscount"    | "Ghasdelegation"
```

### Schedule Constants

A `ScheduleConst` is a constant determined by the fee schedule.

```k
    syntax MInt{256} ::= ScheduleConst "<" Schedule ">" [function, total]
 // ---------------------------------------------------------------------

    syntax ScheduleConst ::= "Gzero"         | "Gbase"         | "Gverylow"      | "Glow"              | "Gmid"               | "Ghigh"            | "Gextcodesize"
                           | "Gextcodecopy"  | "Gbalance"      | "Gsload"        | "Gjumpdest"         | "Gsstoreset"         | "Gsstorereset"     | "Rsstoreclear"
                           | "Rselfdestruct" | "Gselfdestruct" | "Gcreate"       | "Gcodedeposit"      | "Gcall"              | "Gcallvalue"       | "Gcallstipend"
                           | "Gnewaccount"   | "Gexp"          | "Gexpbyte"      | "Gmemory"           | "Gtxcreate"          | "Gtxdatazero"      | "Gtxdatanonzero"
                           | "Gtransaction"  | "Glog"          | "Glogdata"      | "Glogtopic"         | "Gsha3"              | "Gsha3word"        | "Gcopy"
                           | "Gblockhash"    | "Gquadcoeff"    | "maxCodeSize"   | "Rb"                | "Gquaddivisor"       | "Gecadd"           | "Gecmul"
                           | "Gecpairconst"  | "Gecpaircoeff"  | "Gfround"       | "Gcoldsload"        | "Gcoldaccountaccess" | "Gwarmstorageread" | "Gaccesslistaddress"
                           | "Gaccessliststoragekey"           | "Rmaxquotient"  | "Ginitcodewordcost" | "maxInitCodeSize"    | "Gwarmstoragedirtystore"
                           | "Gpointeval"    | "Gbls12g1add"   | "Gbls12g1mul"   | "Gbls12g2add"       | "Gbls12g2mul"        | "Gbls12PairingCheckMul"
                           | "Gbls12PairingCheckAdd"           | "Gbls12mapfptog1"                     | "Gbls12mapfp2tog2"
 // ----------------------------------------------------------------------------------------------------------------------------------------------------
```

### Frontier Schedule

```k
    syntax Schedule ::= "FRONTIER" [symbol(FRONTIER_EVM), smtlib(schedule_FRONTIER)]
 // --------------------------------------------------------------------------------
    rule Gzero    < FRONTIER > => 0p256
    rule Gbase    < FRONTIER > => 2p256
    rule Gverylow < FRONTIER > => 3p256
    rule Glow     < FRONTIER > => 5p256
    rule Gmid     < FRONTIER > => 8p256
    rule Ghigh    < FRONTIER > => 10p256

    rule Gexp      < FRONTIER > => 10p256
    rule Gexpbyte  < FRONTIER > => 10p256
    rule Gsha3     < FRONTIER > => 30p256
    rule Gsha3word < FRONTIER > => 6p256

    rule Gsload       < FRONTIER > => 50p256
    rule Gsstoreset   < FRONTIER > => 20000p256
    rule Gsstorereset < FRONTIER > => 5000p256
    rule Rsstoreclear < FRONTIER > => 15000p256

    rule Glog      < FRONTIER > => 375p256
    rule Glogdata  < FRONTIER > => 8p256
    rule Glogtopic < FRONTIER > => 375p256

    rule Gcall        < FRONTIER > => 40p256
    rule Gcallstipend < FRONTIER > => 2300p256
    rule Gcallvalue   < FRONTIER > => 9000p256
    rule Gnewaccount  < FRONTIER > => 25000p256

    rule Gcreate       < FRONTIER > => 32000p256
    rule Gcodedeposit  < FRONTIER > => 200p256
    rule Gselfdestruct < FRONTIER > => 0p256
    rule Rselfdestruct < FRONTIER > => 24000p256

    rule Gmemory      < FRONTIER > => 3p256
    rule Gquadcoeff   < FRONTIER > => 512p256
    rule Gcopy        < FRONTIER > => 3p256
    rule Gquaddivisor < FRONTIER > => 20p256

    rule Gtransaction   < FRONTIER > => 21000p256
    rule Gtxcreate      < FRONTIER > => 21000p256
    rule Gtxdatazero    < FRONTIER > => 4p256
    rule Gtxdatanonzero < FRONTIER > => 68p256

    rule Gjumpdest    < FRONTIER > => 1p256
    rule Gbalance     < FRONTIER > => 20p256
    rule Gblockhash   < FRONTIER > => 20p256
    rule Gextcodesize < FRONTIER > => 20p256
    rule Gextcodecopy < FRONTIER > => 20p256

    rule Gecadd       < FRONTIER > => 500p256
    rule Gecmul       < FRONTIER > => 40000p256
    rule Gecpairconst < FRONTIER > => 100000p256
    rule Gecpaircoeff < FRONTIER > => 80000p256
    rule Gfround      < FRONTIER > => 1p256

    rule maxCodeSize < FRONTIER > => 2p256 ^MInt 32p256 -MInt 1p256
    rule Rb          < FRONTIER > => 5p256 *MInt (10p256 ^MInt 18p256)

    rule Gcoldsload             < FRONTIER > => 0p256
    rule Gcoldaccountaccess     < FRONTIER > => 0p256
    rule Gwarmstorageread       < FRONTIER > => 0p256
    rule Gwarmstoragedirtystore < FRONTIER > => 0p256

    rule Gpointeval < FRONTIER > => 0p256

    rule Gbls12g1add < FRONTIER > => 0p256
    rule Gbls12g1mul < FRONTIER > => 0p256
    rule Gbls12g2add < FRONTIER > => 0p256
    rule Gbls12g2mul < FRONTIER > => 0p256
    rule Gbls12PairingCheckMul < FRONTIER > => 0p256
    rule Gbls12PairingCheckAdd < FRONTIER > => 0p256
    rule Gbls12mapfptog1 < FRONTIER > => 0p256
    rule Gbls12mapfp2tog2 < FRONTIER > => 0p256

    rule Gaccessliststoragekey < FRONTIER > => 0p256
    rule Gaccesslistaddress    < FRONTIER > => 0p256

    rule maxInitCodeSize   < FRONTIER > => 0p256
    rule Ginitcodewordcost < FRONTIER > => 0p256

    rule Rmaxquotient < FRONTIER > => 2p256

    rule Gselfdestructnewaccount << FRONTIER >> => false
    rule Gstaticcalldepth        << FRONTIER >> => true
    rule Gemptyisnonexistent     << FRONTIER >> => false
    rule Gzerovaluenewaccountgas << FRONTIER >> => true
    rule Ghasrevert              << FRONTIER >> => false
    rule Ghasreturndata          << FRONTIER >> => false
    rule Ghasstaticcall          << FRONTIER >> => false
    rule Ghasshift               << FRONTIER >> => false
    rule Ghasdirtysstore         << FRONTIER >> => false
    rule Ghassstorestipend       << FRONTIER >> => false
    rule Ghascreate2             << FRONTIER >> => false
    rule Ghasextcodehash         << FRONTIER >> => false
    rule Ghasselfbalance         << FRONTIER >> => false
    rule Ghaschainid             << FRONTIER >> => false
    rule Ghasaccesslist          << FRONTIER >> => false
    rule Ghasbasefee             << FRONTIER >> => false
    rule Ghasrejectedfirstbyte   << FRONTIER >> => false
    rule Ghasprevrandao          << FRONTIER >> => false
    rule Ghasmaxinitcodesize     << FRONTIER >> => false
    rule Ghaspushzero            << FRONTIER >> => false
    rule Ghaswarmcoinbase        << FRONTIER >> => false
    rule Ghaswithdrawals         << FRONTIER >> => false
    rule Ghastransient           << FRONTIER >> => false
    rule Ghasmcopy               << FRONTIER >> => false
    rule Ghasbeaconroot          << FRONTIER >> => false
    rule Ghaseip6780             << FRONTIER >> => false
    rule Ghasblobbasefee         << FRONTIER >> => false
    rule Ghasblobhash            << FRONTIER >> => false
    rule Ghasbls12msmdiscount    << FRONTIER >> => false
    rule Ghasdelegation          << FRONTIER >> => false
```

### Homestead Schedule

```k
    syntax Schedule ::= "HOMESTEAD" [symbol(HOMESTEAD_EVM), smtlib(schedule_HOMESTEAD)]
 // -----------------------------------------------------------------------------------
    rule Gzero    < HOMESTEAD > => 0p256
    rule Gbase    < HOMESTEAD > => 2p256
    rule Gverylow < HOMESTEAD > => 3p256
    rule Glow     < HOMESTEAD > => 5p256
    rule Gmid     < HOMESTEAD > => 8p256
    rule Ghigh    < HOMESTEAD > => 10p256

    rule Gexp      < HOMESTEAD > => 10p256
    rule Gexpbyte  < HOMESTEAD > => 10p256
    rule Gsha3     < HOMESTEAD > => 30p256
    rule Gsha3word < HOMESTEAD > => 6p256

    rule Gsload       < HOMESTEAD > => 50p256
    rule Gsstoreset   < HOMESTEAD > => 20000p256
    rule Gsstorereset < HOMESTEAD > => 5000p256
    rule Rsstoreclear < HOMESTEAD > => 15000p256

    rule Glog      < HOMESTEAD > => 375p256
    rule Glogdata  < HOMESTEAD > => 8p256
    rule Glogtopic < HOMESTEAD > => 375p256

    rule Gcall        < HOMESTEAD > => 40p256
    rule Gcallstipend < HOMESTEAD > => 2300p256
    rule Gcallvalue   < HOMESTEAD > => 9000p256
    rule Gnewaccount  < HOMESTEAD > => 25000p256

    rule Gcreate       < HOMESTEAD > => 32000p256
    rule Gcodedeposit  < HOMESTEAD > => 200p256
    rule Gselfdestruct < HOMESTEAD > => 0p256
    rule Rselfdestruct < HOMESTEAD > => 24000p256

    rule Gmemory      < HOMESTEAD > => 3p256
    rule Gquadcoeff   < HOMESTEAD > => 512p256
    rule Gcopy        < HOMESTEAD > => 3p256
    rule Gquaddivisor < HOMESTEAD > => 20p256

    rule Gtransaction   < HOMESTEAD > => 21000p256
    rule Gtxcreate      < HOMESTEAD > => 53000p256
    rule Gtxdatazero    < HOMESTEAD > => 4p256
    rule Gtxdatanonzero < HOMESTEAD > => 68p256

    rule Gjumpdest    < HOMESTEAD > => 1p256
    rule Gbalance     < HOMESTEAD > => 20p256
    rule Gblockhash   < HOMESTEAD > => 20p256
    rule Gextcodesize < HOMESTEAD > => 20p256
    rule Gextcodecopy < HOMESTEAD > => 20p256

    rule Gecadd       < HOMESTEAD > => 500p256
    rule Gecmul       < HOMESTEAD > => 40000p256
    rule Gecpairconst < HOMESTEAD > => 100000p256
    rule Gecpaircoeff < HOMESTEAD > => 80000p256
    rule Gfround      < HOMESTEAD > => 1p256

    rule maxCodeSize < HOMESTEAD > => 2p256 ^MInt 32p256 -MInt 1p256
    rule Rb          < HOMESTEAD > => 5p256 *MInt (10p256 ^MInt 18p256)

    rule Gcoldsload             < HOMESTEAD > => 0p256
    rule Gcoldaccountaccess     < HOMESTEAD > => 0p256
    rule Gwarmstorageread       < HOMESTEAD > => 0p256
    rule Gwarmstoragedirtystore < HOMESTEAD > => 0p256

    rule Gpointeval < HOMESTEAD > => 0p256

    rule Gbls12g1add < HOMESTEAD > => 0p256
    rule Gbls12g1mul < HOMESTEAD > => 0p256
    rule Gbls12g2add < HOMESTEAD > => 0p256
    rule Gbls12g2mul < HOMESTEAD > => 0p256
    rule Gbls12PairingCheckMul < HOMESTEAD > => 0p256
    rule Gbls12PairingCheckAdd < HOMESTEAD > => 0p256
    rule Gbls12mapfptog1 < HOMESTEAD > => 0p256
    rule Gbls12mapfp2tog2 < HOMESTEAD > => 0p256

    rule Gaccessliststoragekey < HOMESTEAD > => 0p256
    rule Gaccesslistaddress    < HOMESTEAD > => 0p256

    rule maxInitCodeSize   < HOMESTEAD > => 0p256
    rule Ginitcodewordcost < HOMESTEAD > => 0p256

    rule Rmaxquotient < HOMESTEAD > => 2p256

    rule Gselfdestructnewaccount << HOMESTEAD >> => false
    rule Gstaticcalldepth        << HOMESTEAD >> => true
    rule Gemptyisnonexistent     << HOMESTEAD >> => false
    rule Gzerovaluenewaccountgas << HOMESTEAD >> => true
    rule Ghasrevert              << HOMESTEAD >> => false
    rule Ghasreturndata          << HOMESTEAD >> => false
    rule Ghasstaticcall          << HOMESTEAD >> => false
    rule Ghasshift               << HOMESTEAD >> => false
    rule Ghasdirtysstore         << HOMESTEAD >> => false
    rule Ghassstorestipend       << HOMESTEAD >> => false
    rule Ghascreate2             << HOMESTEAD >> => false
    rule Ghasextcodehash         << HOMESTEAD >> => false
    rule Ghasselfbalance         << HOMESTEAD >> => false
    rule Ghaschainid             << HOMESTEAD >> => false
    rule Ghasaccesslist          << HOMESTEAD >> => false
    rule Ghasbasefee             << HOMESTEAD >> => false
    rule Ghasrejectedfirstbyte   << HOMESTEAD >> => false
    rule Ghasprevrandao          << HOMESTEAD >> => false
    rule Ghasmaxinitcodesize     << HOMESTEAD >> => false
    rule Ghaspushzero            << HOMESTEAD >> => false
    rule Ghaswarmcoinbase        << HOMESTEAD >> => false
    rule Ghaswithdrawals         << HOMESTEAD >> => false
    rule Ghastransient           << HOMESTEAD >> => false
    rule Ghasmcopy               << HOMESTEAD >> => false
    rule Ghasbeaconroot          << HOMESTEAD >> => false
    rule Ghaseip6780             << HOMESTEAD >> => false
    rule Ghasblobbasefee         << HOMESTEAD >> => false
    rule Ghasblobhash            << HOMESTEAD >> => false
    rule Ghasbls12msmdiscount    << HOMESTEAD >> => false
    rule Ghasdelegation          << HOMESTEAD >> => false
```

### Tangerine Whistle Schedule

```k
    syntax Schedule ::= "TANGERINE_WHISTLE" [symbol(TANGERINE_WHISTLE_EVM), smtlib(schedule_TANGERINE_WHISTLE)]
 // -----------------------------------------------------------------------------------------------------------
    rule Gzero    < TANGERINE_WHISTLE > => 0p256
    rule Gbase    < TANGERINE_WHISTLE > => 2p256
    rule Gverylow < TANGERINE_WHISTLE > => 3p256
    rule Glow     < TANGERINE_WHISTLE > => 5p256
    rule Gmid     < TANGERINE_WHISTLE > => 8p256
    rule Ghigh    < TANGERINE_WHISTLE > => 10p256

    rule Gexp      < TANGERINE_WHISTLE > => 10p256
    rule Gexpbyte  < TANGERINE_WHISTLE > => 10p256
    rule Gsha3     < TANGERINE_WHISTLE > => 30p256
    rule Gsha3word < TANGERINE_WHISTLE > => 6p256

    rule Gsload       < TANGERINE_WHISTLE > => 200p256
    rule Gsstoreset   < TANGERINE_WHISTLE > => 20000p256
    rule Gsstorereset < TANGERINE_WHISTLE > => 5000p256
    rule Rsstoreclear < TANGERINE_WHISTLE > => 15000p256

    rule Glog      < TANGERINE_WHISTLE > => 375p256
    rule Glogdata  < TANGERINE_WHISTLE > => 8p256
    rule Glogtopic < TANGERINE_WHISTLE > => 375p256

    rule Gcall        < TANGERINE_WHISTLE > => 700p256
    rule Gcallstipend < TANGERINE_WHISTLE > => 2300p256
    rule Gcallvalue   < TANGERINE_WHISTLE > => 9000p256
    rule Gnewaccount  < TANGERINE_WHISTLE > => 25000p256

    rule Gcreate       < TANGERINE_WHISTLE > => 32000p256
    rule Gcodedeposit  < TANGERINE_WHISTLE > => 200p256
    rule Gselfdestruct < TANGERINE_WHISTLE > => 5000p256
    rule Rselfdestruct < TANGERINE_WHISTLE > => 24000p256

    rule Gmemory      < TANGERINE_WHISTLE > => 3p256
    rule Gquadcoeff   < TANGERINE_WHISTLE > => 512p256
    rule Gcopy        < TANGERINE_WHISTLE > => 3p256
    rule Gquaddivisor < TANGERINE_WHISTLE > => 20p256

    rule Gtransaction   < TANGERINE_WHISTLE > => 21000p256
    rule Gtxcreate      < TANGERINE_WHISTLE > => 53000p256
    rule Gtxdatazero    < TANGERINE_WHISTLE > => 4p256
    rule Gtxdatanonzero < TANGERINE_WHISTLE > => 68p256

    rule Gjumpdest    < TANGERINE_WHISTLE > => 1p256
    rule Gbalance     < TANGERINE_WHISTLE > => 400p256
    rule Gblockhash   < TANGERINE_WHISTLE > => 20p256
    rule Gextcodesize < TANGERINE_WHISTLE > => 700p256
    rule Gextcodecopy < TANGERINE_WHISTLE > => 700p256

    rule Gecadd       < TANGERINE_WHISTLE > => 500p256
    rule Gecmul       < TANGERINE_WHISTLE > => 40000p256
    rule Gecpairconst < TANGERINE_WHISTLE > => 100000p256
    rule Gecpaircoeff < TANGERINE_WHISTLE > => 80000p256
    rule Gfround      < TANGERINE_WHISTLE > => 1p256

    rule maxCodeSize < TANGERINE_WHISTLE > => 2p256 ^MInt 32p256 -MInt 1p256
    rule Rb          < TANGERINE_WHISTLE > => 5p256 *MInt (10p256 ^MInt 18p256)

    rule Gcoldsload             < TANGERINE_WHISTLE > => 0p256
    rule Gcoldaccountaccess     < TANGERINE_WHISTLE > => 0p256
    rule Gwarmstorageread       < TANGERINE_WHISTLE > => 0p256
    rule Gwarmstoragedirtystore < TANGERINE_WHISTLE > => 0p256

    rule Gpointeval < TANGERINE_WHISTLE > => 0p256

    rule Gbls12g1add < TANGERINE_WHISTLE > => 0p256
    rule Gbls12g1mul < TANGERINE_WHISTLE > => 0p256
    rule Gbls12g2add < TANGERINE_WHISTLE > => 0p256
    rule Gbls12g2mul < TANGERINE_WHISTLE > => 0p256
    rule Gbls12PairingCheckMul < TANGERINE_WHISTLE > => 0p256
    rule Gbls12PairingCheckAdd < TANGERINE_WHISTLE > => 0p256
    rule Gbls12mapfptog1 < TANGERINE_WHISTLE > => 0p256
    rule Gbls12mapfp2tog2 < TANGERINE_WHISTLE > => 0p256

    rule Gaccessliststoragekey < TANGERINE_WHISTLE > => 0p256
    rule Gaccesslistaddress    < TANGERINE_WHISTLE > => 0p256

    rule maxInitCodeSize   < TANGERINE_WHISTLE > => 0p256
    rule Ginitcodewordcost < TANGERINE_WHISTLE > => 0p256

    rule Rmaxquotient < TANGERINE_WHISTLE > => 2p256

    rule Gselfdestructnewaccount << TANGERINE_WHISTLE >> => true
    rule Gstaticcalldepth        << TANGERINE_WHISTLE >> => false
    rule Gemptyisnonexistent     << TANGERINE_WHISTLE >> => false
    rule Gzerovaluenewaccountgas << TANGERINE_WHISTLE >> => true
    rule Ghasrevert              << TANGERINE_WHISTLE >> => false
    rule Ghasreturndata          << TANGERINE_WHISTLE >> => false
    rule Ghasstaticcall          << TANGERINE_WHISTLE >> => false
    rule Ghasshift               << TANGERINE_WHISTLE >> => false
    rule Ghasdirtysstore         << TANGERINE_WHISTLE >> => false
    rule Ghassstorestipend       << TANGERINE_WHISTLE >> => false
    rule Ghascreate2             << TANGERINE_WHISTLE >> => false
    rule Ghasextcodehash         << TANGERINE_WHISTLE >> => false
    rule Ghasselfbalance         << TANGERINE_WHISTLE >> => false
    rule Ghaschainid             << TANGERINE_WHISTLE >> => false
    rule Ghasaccesslist          << TANGERINE_WHISTLE >> => false
    rule Ghasbasefee             << TANGERINE_WHISTLE >> => false
    rule Ghasrejectedfirstbyte   << TANGERINE_WHISTLE >> => false
    rule Ghasprevrandao          << TANGERINE_WHISTLE >> => false
    rule Ghasmaxinitcodesize     << TANGERINE_WHISTLE >> => false
    rule Ghaspushzero            << TANGERINE_WHISTLE >> => false
    rule Ghaswarmcoinbase        << TANGERINE_WHISTLE >> => false
    rule Ghaswithdrawals         << TANGERINE_WHISTLE >> => false
    rule Ghastransient           << TANGERINE_WHISTLE >> => false
    rule Ghasmcopy               << TANGERINE_WHISTLE >> => false
    rule Ghasbeaconroot          << TANGERINE_WHISTLE >> => false
    rule Ghaseip6780             << TANGERINE_WHISTLE >> => false
    rule Ghasblobbasefee         << TANGERINE_WHISTLE >> => false
    rule Ghasblobhash            << TANGERINE_WHISTLE >> => false
    rule Ghasbls12msmdiscount    << TANGERINE_WHISTLE >> => false
    rule Ghasdelegation          << TANGERINE_WHISTLE >> => false
```

### Spurious Dragon Schedule

```k
    syntax Schedule ::= "SPURIOUS_DRAGON" [symbol(SPURIOUS_DRAGON_EVM), smtlib(schedule_SPURIOUS_DRAGON)]
 // -----------------------------------------------------------------------------------------------------
    rule Gzero    < SPURIOUS_DRAGON > => 0p256
    rule Gbase    < SPURIOUS_DRAGON > => 2p256
    rule Gverylow < SPURIOUS_DRAGON > => 3p256
    rule Glow     < SPURIOUS_DRAGON > => 5p256
    rule Gmid     < SPURIOUS_DRAGON > => 8p256
    rule Ghigh    < SPURIOUS_DRAGON > => 10p256

    rule Gexp      < SPURIOUS_DRAGON > => 10p256
    rule Gexpbyte  < SPURIOUS_DRAGON > => 50p256
    rule Gsha3     < SPURIOUS_DRAGON > => 30p256
    rule Gsha3word < SPURIOUS_DRAGON > => 6p256

    rule Gsload       < SPURIOUS_DRAGON > => 200p256
    rule Gsstoreset   < SPURIOUS_DRAGON > => 20000p256
    rule Gsstorereset < SPURIOUS_DRAGON > => 5000p256
    rule Rsstoreclear < SPURIOUS_DRAGON > => 15000p256

    rule Glog      < SPURIOUS_DRAGON > => 375p256
    rule Glogdata  < SPURIOUS_DRAGON > => 8p256
    rule Glogtopic < SPURIOUS_DRAGON > => 375p256

    rule Gcall        < SPURIOUS_DRAGON > => 700p256
    rule Gcallstipend < SPURIOUS_DRAGON > => 2300p256
    rule Gcallvalue   < SPURIOUS_DRAGON > => 9000p256
    rule Gnewaccount  < SPURIOUS_DRAGON > => 25000p256

    rule Gcreate       < SPURIOUS_DRAGON > => 32000p256
    rule Gcodedeposit  < SPURIOUS_DRAGON > => 200p256
    rule Gselfdestruct < SPURIOUS_DRAGON > => 5000p256
    rule Rselfdestruct < SPURIOUS_DRAGON > => 24000p256

    rule Gmemory      < SPURIOUS_DRAGON > => 3p256
    rule Gquadcoeff   < SPURIOUS_DRAGON > => 512p256
    rule Gcopy        < SPURIOUS_DRAGON > => 3p256
    rule Gquaddivisor < SPURIOUS_DRAGON > => 20p256

    rule Gtransaction   < SPURIOUS_DRAGON > => 21000p256
    rule Gtxcreate      < SPURIOUS_DRAGON > => 53000p256
    rule Gtxdatazero    < SPURIOUS_DRAGON > => 4p256
    rule Gtxdatanonzero < SPURIOUS_DRAGON > => 68p256

    rule Gjumpdest    < SPURIOUS_DRAGON > => 1p256
    rule Gbalance     < SPURIOUS_DRAGON > => 400p256
    rule Gblockhash   < SPURIOUS_DRAGON > => 20p256
    rule Gextcodesize < SPURIOUS_DRAGON > => 700p256
    rule Gextcodecopy < SPURIOUS_DRAGON > => 700p256

    rule Gecadd       < SPURIOUS_DRAGON > => 500p256
    rule Gecmul       < SPURIOUS_DRAGON > => 40000p256
    rule Gecpairconst < SPURIOUS_DRAGON > => 100000p256
    rule Gecpaircoeff < SPURIOUS_DRAGON > => 80000p256
    rule Gfround      < SPURIOUS_DRAGON > => 1p256

    rule maxCodeSize < SPURIOUS_DRAGON > => 24576p256
    rule Rb          < SPURIOUS_DRAGON > => 5p256 *MInt (10p256 ^MInt 18p256)

    rule Gcoldsload             < SPURIOUS_DRAGON > => 0p256
    rule Gcoldaccountaccess     < SPURIOUS_DRAGON > => 0p256
    rule Gwarmstorageread       < SPURIOUS_DRAGON > => 0p256
    rule Gwarmstoragedirtystore < SPURIOUS_DRAGON > => 0p256

    rule Gpointeval < SPURIOUS_DRAGON > => 0p256

    rule Gbls12g1add < SPURIOUS_DRAGON > => 0p256
    rule Gbls12g1mul < SPURIOUS_DRAGON > => 0p256
    rule Gbls12g2add < SPURIOUS_DRAGON > => 0p256
    rule Gbls12g2mul < SPURIOUS_DRAGON > => 0p256
    rule Gbls12PairingCheckMul < SPURIOUS_DRAGON > => 0p256
    rule Gbls12PairingCheckAdd < SPURIOUS_DRAGON > => 0p256
    rule Gbls12mapfptog1 < SPURIOUS_DRAGON > => 0p256
    rule Gbls12mapfp2tog2 < SPURIOUS_DRAGON > => 0p256

    rule Gaccessliststoragekey < SPURIOUS_DRAGON > => 0p256
    rule Gaccesslistaddress    < SPURIOUS_DRAGON > => 0p256

    rule maxInitCodeSize   < SPURIOUS_DRAGON > => 0p256
    rule Ginitcodewordcost < SPURIOUS_DRAGON > => 0p256

    rule Rmaxquotient < SPURIOUS_DRAGON > => 2p256

    rule Gselfdestructnewaccount << SPURIOUS_DRAGON >> => true
    rule Gstaticcalldepth        << SPURIOUS_DRAGON >> => false
    rule Gemptyisnonexistent     << SPURIOUS_DRAGON >> => true
    rule Gzerovaluenewaccountgas << SPURIOUS_DRAGON >> => false
    rule Ghasrevert              << SPURIOUS_DRAGON >> => false
    rule Ghasreturndata          << SPURIOUS_DRAGON >> => false
    rule Ghasstaticcall          << SPURIOUS_DRAGON >> => false
    rule Ghasshift               << SPURIOUS_DRAGON >> => false
    rule Ghasdirtysstore         << SPURIOUS_DRAGON >> => false
    rule Ghassstorestipend       << SPURIOUS_DRAGON >> => false
    rule Ghascreate2             << SPURIOUS_DRAGON >> => false
    rule Ghasextcodehash         << SPURIOUS_DRAGON >> => false
    rule Ghasselfbalance         << SPURIOUS_DRAGON >> => false
    rule Ghaschainid             << SPURIOUS_DRAGON >> => false
    rule Ghasaccesslist          << SPURIOUS_DRAGON >> => false
    rule Ghasbasefee             << SPURIOUS_DRAGON >> => false
    rule Ghasrejectedfirstbyte   << SPURIOUS_DRAGON >> => false
    rule Ghasprevrandao          << SPURIOUS_DRAGON >> => false
    rule Ghasmaxinitcodesize     << SPURIOUS_DRAGON >> => false
    rule Ghaspushzero            << SPURIOUS_DRAGON >> => false
    rule Ghaswarmcoinbase        << SPURIOUS_DRAGON >> => false
    rule Ghaswithdrawals         << SPURIOUS_DRAGON >> => false
    rule Ghastransient           << SPURIOUS_DRAGON >> => false
    rule Ghasmcopy               << SPURIOUS_DRAGON >> => false
    rule Ghasbeaconroot          << SPURIOUS_DRAGON >> => false
    rule Ghaseip6780             << SPURIOUS_DRAGON >> => false
    rule Ghasblobbasefee         << SPURIOUS_DRAGON >> => false
    rule Ghasblobhash            << SPURIOUS_DRAGON >> => false
    rule Ghasbls12msmdiscount    << SPURIOUS_DRAGON >> => false
    rule Ghasdelegation          << SPURIOUS_DRAGON >> => false
```

### Byzantium Schedule

```k
    syntax Schedule ::= "BYZANTIUM" [symbol(BYZANTIUM_EVM), smtlib(schedule_BYZANTIUM)]
 // -----------------------------------------------------------------------------------
    rule Gzero    < BYZANTIUM > => 0p256
    rule Gbase    < BYZANTIUM > => 2p256
    rule Gverylow < BYZANTIUM > => 3p256
    rule Glow     < BYZANTIUM > => 5p256
    rule Gmid     < BYZANTIUM > => 8p256
    rule Ghigh    < BYZANTIUM > => 10p256

    rule Gexp      < BYZANTIUM > => 10p256
    rule Gexpbyte  < BYZANTIUM > => 50p256
    rule Gsha3     < BYZANTIUM > => 30p256
    rule Gsha3word < BYZANTIUM > => 6p256

    rule Gsload       < BYZANTIUM > => 200p256
    rule Gsstoreset   < BYZANTIUM > => 20000p256
    rule Gsstorereset < BYZANTIUM > => 5000p256
    rule Rsstoreclear < BYZANTIUM > => 15000p256

    rule Glog      < BYZANTIUM > => 375p256
    rule Glogdata  < BYZANTIUM > => 8p256
    rule Glogtopic < BYZANTIUM > => 375p256

    rule Gcall        < BYZANTIUM > => 700p256
    rule Gcallstipend < BYZANTIUM > => 2300p256
    rule Gcallvalue   < BYZANTIUM > => 9000p256
    rule Gnewaccount  < BYZANTIUM > => 25000p256

    rule Gcreate       < BYZANTIUM > => 32000p256
    rule Gcodedeposit  < BYZANTIUM > => 200p256
    rule Gselfdestruct < BYZANTIUM > => 5000p256
    rule Rselfdestruct < BYZANTIUM > => 24000p256

    rule Gmemory      < BYZANTIUM > => 3p256
    rule Gquadcoeff   < BYZANTIUM > => 512p256
    rule Gcopy        < BYZANTIUM > => 3p256
    rule Gquaddivisor < BYZANTIUM > => 20p256

    rule Gtransaction   < BYZANTIUM > => 21000p256
    rule Gtxcreate      < BYZANTIUM > => 53000p256
    rule Gtxdatazero    < BYZANTIUM > => 4p256
    rule Gtxdatanonzero < BYZANTIUM > => 68p256

    rule Gjumpdest    < BYZANTIUM > => 1p256
    rule Gbalance     < BYZANTIUM > => 400p256
    rule Gblockhash   < BYZANTIUM > => 20p256
    rule Gextcodesize < BYZANTIUM > => 700p256
    rule Gextcodecopy < BYZANTIUM > => 700p256

    rule Gecadd       < BYZANTIUM > => 500p256
    rule Gecmul       < BYZANTIUM > => 40000p256
    rule Gecpairconst < BYZANTIUM > => 100000p256
    rule Gecpaircoeff < BYZANTIUM > => 80000p256
    rule Gfround      < BYZANTIUM > => 1p256

    rule maxCodeSize < BYZANTIUM > => 24576p256
    rule Rb          < BYZANTIUM > => 3p256 *MInt ethp256

    rule Gcoldsload             < BYZANTIUM > => 0p256
    rule Gcoldaccountaccess     < BYZANTIUM > => 0p256
    rule Gwarmstorageread       < BYZANTIUM > => 0p256
    rule Gwarmstoragedirtystore < BYZANTIUM > => 0p256

    rule Gpointeval < BYZANTIUM > => 0p256

    rule Gbls12g1add < BYZANTIUM > => 0p256
    rule Gbls12g1mul < BYZANTIUM > => 0p256
    rule Gbls12g2add < BYZANTIUM > => 0p256
    rule Gbls12g2mul < BYZANTIUM > => 0p256
    rule Gbls12PairingCheckMul < BYZANTIUM > => 0p256
    rule Gbls12PairingCheckAdd < BYZANTIUM > => 0p256
    rule Gbls12mapfptog1 < BYZANTIUM > => 0p256
    rule Gbls12mapfp2tog2 < BYZANTIUM > => 0p256

    rule Gaccessliststoragekey < BYZANTIUM > => 0p256
    rule Gaccesslistaddress    < BYZANTIUM > => 0p256

    rule maxInitCodeSize   < BYZANTIUM > => 0p256
    rule Ginitcodewordcost < BYZANTIUM > => 0p256

    rule Rmaxquotient < BYZANTIUM > => 2p256

    rule Gselfdestructnewaccount << BYZANTIUM >> => true
    rule Gstaticcalldepth        << BYZANTIUM >> => false
    rule Gemptyisnonexistent     << BYZANTIUM >> => true
    rule Gzerovaluenewaccountgas << BYZANTIUM >> => false
    rule Ghasrevert              << BYZANTIUM >> => true
    rule Ghasreturndata          << BYZANTIUM >> => true
    rule Ghasstaticcall          << BYZANTIUM >> => true
    rule Ghasshift               << BYZANTIUM >> => false
    rule Ghasdirtysstore         << BYZANTIUM >> => false
    rule Ghassstorestipend       << BYZANTIUM >> => false
    rule Ghascreate2             << BYZANTIUM >> => false
    rule Ghasextcodehash         << BYZANTIUM >> => false
    rule Ghasselfbalance         << BYZANTIUM >> => false
    rule Ghaschainid             << BYZANTIUM >> => false
    rule Ghasaccesslist          << BYZANTIUM >> => false
    rule Ghasbasefee             << BYZANTIUM >> => false
    rule Ghasrejectedfirstbyte   << BYZANTIUM >> => false
    rule Ghasprevrandao          << BYZANTIUM >> => false
    rule Ghasmaxinitcodesize     << BYZANTIUM >> => false
    rule Ghaspushzero            << BYZANTIUM >> => false
    rule Ghaswarmcoinbase        << BYZANTIUM >> => false
    rule Ghaswithdrawals         << BYZANTIUM >> => false
    rule Ghastransient           << BYZANTIUM >> => false
    rule Ghasmcopy               << BYZANTIUM >> => false
    rule Ghasbeaconroot          << BYZANTIUM >> => false
    rule Ghaseip6780             << BYZANTIUM >> => false
    rule Ghasblobbasefee         << BYZANTIUM >> => false
    rule Ghasblobhash            << BYZANTIUM >> => false
    rule Ghasbls12msmdiscount    << BYZANTIUM >> => false
    rule Ghasdelegation          << BYZANTIUM >> => false
```

### Constantinople Schedule

```k
    syntax Schedule ::= "CONSTANTINOPLE" [symbol(CONSTANTINOPLE_EVM), smtlib(schedule_CONSTANTINOPLE)]
 // --------------------------------------------------------------------------------------------------
    rule Gzero    < CONSTANTINOPLE > => 0p256
    rule Gbase    < CONSTANTINOPLE > => 2p256
    rule Gverylow < CONSTANTINOPLE > => 3p256
    rule Glow     < CONSTANTINOPLE > => 5p256
    rule Gmid     < CONSTANTINOPLE > => 8p256
    rule Ghigh    < CONSTANTINOPLE > => 10p256

    rule Gexp      < CONSTANTINOPLE > => 10p256
    rule Gexpbyte  < CONSTANTINOPLE > => 50p256
    rule Gsha3     < CONSTANTINOPLE > => 30p256
    rule Gsha3word < CONSTANTINOPLE > => 6p256

    rule Gsload       < CONSTANTINOPLE > => 200p256
    rule Gsstoreset   < CONSTANTINOPLE > => 20000p256
    rule Gsstorereset < CONSTANTINOPLE > => 5000p256
    rule Rsstoreclear < CONSTANTINOPLE > => 15000p256

    rule Glog      < CONSTANTINOPLE > => 375p256
    rule Glogdata  < CONSTANTINOPLE > => 8p256
    rule Glogtopic < CONSTANTINOPLE > => 375p256

    rule Gcall        < CONSTANTINOPLE > => 700p256
    rule Gcallstipend < CONSTANTINOPLE > => 2300p256
    rule Gcallvalue   < CONSTANTINOPLE > => 9000p256
    rule Gnewaccount  < CONSTANTINOPLE > => 25000p256

    rule Gcreate       < CONSTANTINOPLE > => 32000p256
    rule Gcodedeposit  < CONSTANTINOPLE > => 200p256
    rule Gselfdestruct < CONSTANTINOPLE > => 5000p256
    rule Rselfdestruct < CONSTANTINOPLE > => 24000p256

    rule Gmemory      < CONSTANTINOPLE > => 3p256
    rule Gquadcoeff   < CONSTANTINOPLE > => 512p256
    rule Gcopy        < CONSTANTINOPLE > => 3p256
    rule Gquaddivisor < CONSTANTINOPLE > => 20p256

    rule Gtransaction   < CONSTANTINOPLE > => 21000p256
    rule Gtxcreate      < CONSTANTINOPLE > => 53000p256
    rule Gtxdatazero    < CONSTANTINOPLE > => 4p256
    rule Gtxdatanonzero < CONSTANTINOPLE > => 68p256

    rule Gjumpdest    < CONSTANTINOPLE > => 1p256
    rule Gbalance     < CONSTANTINOPLE > => 400p256
    rule Gblockhash   < CONSTANTINOPLE > => 20p256
    rule Gextcodesize < CONSTANTINOPLE > => 700p256
    rule Gextcodecopy < CONSTANTINOPLE > => 700p256

    rule Gecadd       < CONSTANTINOPLE > => 500p256
    rule Gecmul       < CONSTANTINOPLE > => 40000p256
    rule Gecpairconst < CONSTANTINOPLE > => 100000p256
    rule Gecpaircoeff < CONSTANTINOPLE > => 80000p256
    rule Gfround      < CONSTANTINOPLE > => 1p256

    rule maxCodeSize < CONSTANTINOPLE > => 24576p256
    rule Rb          < CONSTANTINOPLE > => 2p256 *MInt ethp256

    rule Gcoldsload             < CONSTANTINOPLE > => 0p256
    rule Gcoldaccountaccess     < CONSTANTINOPLE > => 0p256
    rule Gwarmstorageread       < CONSTANTINOPLE > => 0p256
    rule Gwarmstoragedirtystore < CONSTANTINOPLE > => 0p256

    rule Gpointeval < CONSTANTINOPLE > => 0p256

    rule Gbls12g1add < CONSTANTINOPLE > => 0p256
    rule Gbls12g1mul < CONSTANTINOPLE > => 0p256
    rule Gbls12g2add < CONSTANTINOPLE > => 0p256
    rule Gbls12g2mul < CONSTANTINOPLE > => 0p256
    rule Gbls12PairingCheckMul < CONSTANTINOPLE > => 0p256
    rule Gbls12PairingCheckAdd < CONSTANTINOPLE > => 0p256
    rule Gbls12mapfptog1 < CONSTANTINOPLE > => 0p256
    rule Gbls12mapfp2tog2 < CONSTANTINOPLE > => 0p256

    rule Gaccessliststoragekey < CONSTANTINOPLE > => 0p256
    rule Gaccesslistaddress    < CONSTANTINOPLE > => 0p256

    rule maxInitCodeSize   < CONSTANTINOPLE > => 0p256
    rule Ginitcodewordcost < CONSTANTINOPLE > => 0p256

    rule Rmaxquotient < CONSTANTINOPLE > => 2p256

    rule Gselfdestructnewaccount << CONSTANTINOPLE >> => true
    rule Gstaticcalldepth        << CONSTANTINOPLE >> => false
    rule Gemptyisnonexistent     << CONSTANTINOPLE >> => true
    rule Gzerovaluenewaccountgas << CONSTANTINOPLE >> => false
    rule Ghasrevert              << CONSTANTINOPLE >> => true
    rule Ghasreturndata          << CONSTANTINOPLE >> => true
    rule Ghasstaticcall          << CONSTANTINOPLE >> => true
    rule Ghasshift               << CONSTANTINOPLE >> => true
    rule Ghasdirtysstore         << CONSTANTINOPLE >> => true
    rule Ghassstorestipend       << CONSTANTINOPLE >> => false
    rule Ghascreate2             << CONSTANTINOPLE >> => true
    rule Ghasextcodehash         << CONSTANTINOPLE >> => true
    rule Ghasselfbalance         << CONSTANTINOPLE >> => false
    rule Ghaschainid             << CONSTANTINOPLE >> => false
    rule Ghasaccesslist          << CONSTANTINOPLE >> => false
    rule Ghasbasefee             << CONSTANTINOPLE >> => false
    rule Ghasrejectedfirstbyte   << CONSTANTINOPLE >> => false
    rule Ghasprevrandao          << CONSTANTINOPLE >> => false
    rule Ghasmaxinitcodesize     << CONSTANTINOPLE >> => false
    rule Ghaspushzero            << CONSTANTINOPLE >> => false
    rule Ghaswarmcoinbase        << CONSTANTINOPLE >> => false
    rule Ghaswithdrawals         << CONSTANTINOPLE >> => false
    rule Ghastransient           << CONSTANTINOPLE >> => false
    rule Ghasmcopy               << CONSTANTINOPLE >> => false
    rule Ghasbeaconroot          << CONSTANTINOPLE >> => false
    rule Ghaseip6780             << CONSTANTINOPLE >> => false
    rule Ghasblobbasefee         << CONSTANTINOPLE >> => false
    rule Ghasblobhash            << CONSTANTINOPLE >> => false
    rule Ghasbls12msmdiscount    << CONSTANTINOPLE >> => false
    rule Ghasdelegation          << CONSTANTINOPLE >> => false
```

### Petersburg Schedule

```k
    syntax Schedule ::= "PETERSBURG" [symbol(PETERSBURG_EVM), smtlib(schedule_PETERSBURG)]
 // --------------------------------------------------------------------------------------
    rule Gzero    < PETERSBURG > => 0p256
    rule Gbase    < PETERSBURG > => 2p256
    rule Gverylow < PETERSBURG > => 3p256
    rule Glow     < PETERSBURG > => 5p256
    rule Gmid     < PETERSBURG > => 8p256
    rule Ghigh    < PETERSBURG > => 10p256

    rule Gexp      < PETERSBURG > => 10p256
    rule Gexpbyte  < PETERSBURG > => 50p256
    rule Gsha3     < PETERSBURG > => 30p256
    rule Gsha3word < PETERSBURG > => 6p256

    rule Gsload       < PETERSBURG > => 200p256
    rule Gsstoreset   < PETERSBURG > => 20000p256
    rule Gsstorereset < PETERSBURG > => 5000p256
    rule Rsstoreclear < PETERSBURG > => 15000p256

    rule Glog      < PETERSBURG > => 375p256
    rule Glogdata  < PETERSBURG > => 8p256
    rule Glogtopic < PETERSBURG > => 375p256

    rule Gcall        < PETERSBURG > => 700p256
    rule Gcallstipend < PETERSBURG > => 2300p256
    rule Gcallvalue   < PETERSBURG > => 9000p256
    rule Gnewaccount  < PETERSBURG > => 25000p256

    rule Gcreate       < PETERSBURG > => 32000p256
    rule Gcodedeposit  < PETERSBURG > => 200p256
    rule Gselfdestruct < PETERSBURG > => 5000p256
    rule Rselfdestruct < PETERSBURG > => 24000p256

    rule Gmemory      < PETERSBURG > => 3p256
    rule Gquadcoeff   < PETERSBURG > => 512p256
    rule Gcopy        < PETERSBURG > => 3p256
    rule Gquaddivisor < PETERSBURG > => 20p256

    rule Gtransaction   < PETERSBURG > => 21000p256
    rule Gtxcreate      < PETERSBURG > => 53000p256
    rule Gtxdatazero    < PETERSBURG > => 4p256
    rule Gtxdatanonzero < PETERSBURG > => 68p256

    rule Gjumpdest    < PETERSBURG > => 1p256
    rule Gbalance     < PETERSBURG > => 400p256
    rule Gblockhash   < PETERSBURG > => 20p256
    rule Gextcodesize < PETERSBURG > => 700p256
    rule Gextcodecopy < PETERSBURG > => 700p256

    rule Gecadd       < PETERSBURG > => 500p256
    rule Gecmul       < PETERSBURG > => 40000p256
    rule Gecpairconst < PETERSBURG > => 100000p256
    rule Gecpaircoeff < PETERSBURG > => 80000p256
    rule Gfround      < PETERSBURG > => 1p256

    rule maxCodeSize < PETERSBURG > => 24576p256
    rule Rb          < PETERSBURG > => 2p256 *MInt ethp256

    rule Gcoldsload             < PETERSBURG > => 0p256
    rule Gcoldaccountaccess     < PETERSBURG > => 0p256
    rule Gwarmstorageread       < PETERSBURG > => 0p256
    rule Gwarmstoragedirtystore < PETERSBURG > => 0p256

    rule Gpointeval < PETERSBURG > => 0p256

    rule Gbls12g1add < PETERSBURG > => 0p256
    rule Gbls12g1mul < PETERSBURG > => 0p256
    rule Gbls12g2add < PETERSBURG > => 0p256
    rule Gbls12g2mul < PETERSBURG > => 0p256
    rule Gbls12PairingCheckMul < PETERSBURG > => 0p256
    rule Gbls12PairingCheckAdd < PETERSBURG > => 0p256
    rule Gbls12mapfptog1 < PETERSBURG > => 0p256
    rule Gbls12mapfp2tog2 < PETERSBURG > => 0p256

    rule Gaccessliststoragekey < PETERSBURG > => 0p256
    rule Gaccesslistaddress    < PETERSBURG > => 0p256

    rule maxInitCodeSize   < PETERSBURG > => 0p256
    rule Ginitcodewordcost < PETERSBURG > => 0p256

    rule Rmaxquotient < PETERSBURG > => 2p256

    rule Gselfdestructnewaccount << PETERSBURG >> => true
    rule Gstaticcalldepth        << PETERSBURG >> => false
    rule Gemptyisnonexistent     << PETERSBURG >> => true
    rule Gzerovaluenewaccountgas << PETERSBURG >> => false
    rule Ghasrevert              << PETERSBURG >> => true
    rule Ghasreturndata          << PETERSBURG >> => true
    rule Ghasstaticcall          << PETERSBURG >> => true
    rule Ghasshift               << PETERSBURG >> => true
    rule Ghasdirtysstore         << PETERSBURG >> => false
    rule Ghassstorestipend       << PETERSBURG >> => false
    rule Ghascreate2             << PETERSBURG >> => true
    rule Ghasextcodehash         << PETERSBURG >> => true
    rule Ghasselfbalance         << PETERSBURG >> => false
    rule Ghaschainid             << PETERSBURG >> => false
    rule Ghasaccesslist          << PETERSBURG >> => false
    rule Ghasbasefee             << PETERSBURG >> => false
    rule Ghasrejectedfirstbyte   << PETERSBURG >> => false
    rule Ghasprevrandao          << PETERSBURG >> => false
    rule Ghasmaxinitcodesize     << PETERSBURG >> => false
    rule Ghaspushzero            << PETERSBURG >> => false
    rule Ghaswarmcoinbase        << PETERSBURG >> => false
    rule Ghaswithdrawals         << PETERSBURG >> => false
    rule Ghastransient           << PETERSBURG >> => false
    rule Ghasmcopy               << PETERSBURG >> => false
    rule Ghasbeaconroot          << PETERSBURG >> => false
    rule Ghaseip6780             << PETERSBURG >> => false
    rule Ghasblobbasefee         << PETERSBURG >> => false
    rule Ghasblobhash            << PETERSBURG >> => false
    rule Ghasbls12msmdiscount    << PETERSBURG >> => false
    rule Ghasdelegation          << PETERSBURG >> => false
```

### Istanbul Schedule

```k
    syntax Schedule ::= "ISTANBUL" [symbol(ISTANBUL_EVM), smtlib(schedule_ISTANBUL)]
 // --------------------------------------------------------------------------------
    rule Gzero    < ISTANBUL > => 0p256
    rule Gbase    < ISTANBUL > => 2p256
    rule Gverylow < ISTANBUL > => 3p256
    rule Glow     < ISTANBUL > => 5p256
    rule Gmid     < ISTANBUL > => 8p256
    rule Ghigh    < ISTANBUL > => 10p256

    rule Gexp      < ISTANBUL > => 10p256
    rule Gexpbyte  < ISTANBUL > => 50p256
    rule Gsha3     < ISTANBUL > => 30p256
    rule Gsha3word < ISTANBUL > => 6p256

    rule Gsload       < ISTANBUL > => 800p256
    rule Gsstoreset   < ISTANBUL > => 20000p256
    rule Gsstorereset < ISTANBUL > => 5000p256
    rule Rsstoreclear < ISTANBUL > => 15000p256

    rule Glog      < ISTANBUL > => 375p256
    rule Glogdata  < ISTANBUL > => 8p256
    rule Glogtopic < ISTANBUL > => 375p256

    rule Gcall        < ISTANBUL > => 700p256
    rule Gcallstipend < ISTANBUL > => 2300p256
    rule Gcallvalue   < ISTANBUL > => 9000p256
    rule Gnewaccount  < ISTANBUL > => 25000p256

    rule Gcreate       < ISTANBUL > => 32000p256
    rule Gcodedeposit  < ISTANBUL > => 200p256
    rule Gselfdestruct < ISTANBUL > => 5000p256
    rule Rselfdestruct < ISTANBUL > => 24000p256

    rule Gmemory      < ISTANBUL > => 3p256
    rule Gquadcoeff   < ISTANBUL > => 512p256
    rule Gcopy        < ISTANBUL > => 3p256
    rule Gquaddivisor < ISTANBUL > => 20p256

    rule Gtransaction   < ISTANBUL > => 21000p256
    rule Gtxcreate      < ISTANBUL > => 53000p256
    rule Gtxdatazero    < ISTANBUL > => 4p256
    rule Gtxdatanonzero < ISTANBUL > => 16p256

    rule Gjumpdest    < ISTANBUL > => 1p256
    rule Gbalance     < ISTANBUL > => 700p256
    rule Gblockhash   < ISTANBUL > => 20p256
    rule Gextcodesize < ISTANBUL > => 700p256
    rule Gextcodecopy < ISTANBUL > => 700p256

    rule Gecadd       < ISTANBUL > => 150p256
    rule Gecmul       < ISTANBUL > => 6000p256
    rule Gecpairconst < ISTANBUL > => 45000p256
    rule Gecpaircoeff < ISTANBUL > => 34000p256
    rule Gfround      < ISTANBUL > => 1p256

    rule maxCodeSize < ISTANBUL > => 24576p256
    rule Rb          < ISTANBUL > => 2p256 *MInt ethp256

    rule Gcoldsload             < ISTANBUL > => 0p256
    rule Gcoldaccountaccess     < ISTANBUL > => 0p256
    rule Gwarmstorageread       < ISTANBUL > => 0p256
    rule Gwarmstoragedirtystore < ISTANBUL > => 0p256

    rule Gpointeval < ISTANBUL > => 0p256

    rule Gbls12g1add < ISTANBUL > => 0p256
    rule Gbls12g1mul < ISTANBUL > => 0p256
    rule Gbls12g2add < ISTANBUL > => 0p256
    rule Gbls12g2mul < ISTANBUL > => 0p256
    rule Gbls12PairingCheckMul < ISTANBUL > => 0p256
    rule Gbls12PairingCheckAdd < ISTANBUL > => 0p256
    rule Gbls12mapfptog1 < ISTANBUL > => 0p256
    rule Gbls12mapfp2tog2 < ISTANBUL > => 0p256

    rule Gaccessliststoragekey < ISTANBUL > => 0p256
    rule Gaccesslistaddress    < ISTANBUL > => 0p256

    rule maxInitCodeSize   < ISTANBUL > => 0p256
    rule Ginitcodewordcost < ISTANBUL > => 0p256

    rule Rmaxquotient < ISTANBUL > => 2p256

    rule Gselfdestructnewaccount << ISTANBUL >> => true
    rule Gstaticcalldepth        << ISTANBUL >> => false
    rule Gemptyisnonexistent     << ISTANBUL >> => true
    rule Gzerovaluenewaccountgas << ISTANBUL >> => false
    rule Ghasrevert              << ISTANBUL >> => true
    rule Ghasreturndata          << ISTANBUL >> => true
    rule Ghasstaticcall          << ISTANBUL >> => true
    rule Ghasshift               << ISTANBUL >> => true
    rule Ghasdirtysstore         << ISTANBUL >> => true
    rule Ghassstorestipend       << ISTANBUL >> => true
    rule Ghascreate2             << ISTANBUL >> => true
    rule Ghasextcodehash         << ISTANBUL >> => true
    rule Ghasselfbalance         << ISTANBUL >> => true
    rule Ghaschainid             << ISTANBUL >> => true
    rule Ghasaccesslist          << ISTANBUL >> => false
    rule Ghasbasefee             << ISTANBUL >> => false
    rule Ghasrejectedfirstbyte   << ISTANBUL >> => false
    rule Ghasprevrandao          << ISTANBUL >> => false
    rule Ghasmaxinitcodesize     << ISTANBUL >> => false
    rule Ghaspushzero            << ISTANBUL >> => false
    rule Ghaswarmcoinbase        << ISTANBUL >> => false
    rule Ghaswithdrawals         << ISTANBUL >> => false
    rule Ghastransient           << ISTANBUL >> => false
    rule Ghasmcopy               << ISTANBUL >> => false
    rule Ghasbeaconroot          << ISTANBUL >> => false
    rule Ghaseip6780             << ISTANBUL >> => false
    rule Ghasblobbasefee         << ISTANBUL >> => false
    rule Ghasblobhash            << ISTANBUL >> => false
    rule Ghasbls12msmdiscount    << ISTANBUL >> => false
    rule Ghasdelegation          << ISTANBUL >> => false
```

### Berlin Schedule

```k
    syntax Schedule ::= "BERLIN" [symbol(BERLIN_EVM), smtlib(schedule_BERLIN)]
 // --------------------------------------------------------------------------
    rule Gzero    < BERLIN > => 0p256
    rule Gbase    < BERLIN > => 2p256
    rule Gverylow < BERLIN > => 3p256
    rule Glow     < BERLIN > => 5p256
    rule Gmid     < BERLIN > => 8p256
    rule Ghigh    < BERLIN > => 10p256

    rule Gexp      < BERLIN > => 10p256
    rule Gexpbyte  < BERLIN > => 50p256
    rule Gsha3     < BERLIN > => 30p256
    rule Gsha3word < BERLIN > => 6p256

    rule Gsload       < BERLIN > => 100p256
    rule Gsstoreset   < BERLIN > => 20000p256
    rule Gsstorereset < BERLIN > => 2900p256
    rule Rsstoreclear < BERLIN > => 15000p256

    rule Glog      < BERLIN > => 375p256
    rule Glogdata  < BERLIN > => 8p256
    rule Glogtopic < BERLIN > => 375p256

    rule Gcall        < BERLIN > => 700p256
    rule Gcallstipend < BERLIN > => 2300p256
    rule Gcallvalue   < BERLIN > => 9000p256
    rule Gnewaccount  < BERLIN > => 25000p256

    rule Gcreate       < BERLIN > => 32000p256
    rule Gcodedeposit  < BERLIN > => 200p256
    rule Gselfdestruct < BERLIN > => 5000p256
    rule Rselfdestruct < BERLIN > => 24000p256

    rule Gmemory      < BERLIN > => 3p256
    rule Gquadcoeff   < BERLIN > => 512p256
    rule Gcopy        < BERLIN > => 3p256
    rule Gquaddivisor < BERLIN > => 3p256

    rule Gtransaction   < BERLIN > => 21000p256
    rule Gtxcreate      < BERLIN > => 53000p256
    rule Gtxdatazero    < BERLIN > => 4p256
    rule Gtxdatanonzero < BERLIN > => 16p256

    rule Gjumpdest    < BERLIN > => 1p256
    rule Gbalance     < BERLIN > => 700p256
    rule Gblockhash   < BERLIN > => 20p256
    rule Gextcodesize < BERLIN > => 700p256
    rule Gextcodecopy < BERLIN > => 700p256

    rule Gecadd       < BERLIN > => 150p256
    rule Gecmul       < BERLIN > => 6000p256
    rule Gecpairconst < BERLIN > => 45000p256
    rule Gecpaircoeff < BERLIN > => 34000p256
    rule Gfround      < BERLIN > => 1p256

    rule maxCodeSize < BERLIN > => 24576p256
    rule Rb          < BERLIN > => 2p256 *MInt ethp256

    rule Gcoldsload             < BERLIN > => 2100p256
    rule Gcoldaccountaccess     < BERLIN > => 2600p256
    rule Gwarmstorageread       < BERLIN > => 100p256
    rule Gwarmstoragedirtystore < BERLIN > => 0p256

    rule Gpointeval < BERLIN > => 0p256

    rule Gbls12g1add < BERLIN > => 0p256
    rule Gbls12g1mul < BERLIN > => 0p256
    rule Gbls12g2add < BERLIN > => 0p256
    rule Gbls12g2mul < BERLIN > => 0p256
    rule Gbls12PairingCheckMul < BERLIN > => 0p256
    rule Gbls12PairingCheckAdd < BERLIN > => 0p256
    rule Gbls12mapfptog1 < BERLIN > => 0p256
    rule Gbls12mapfp2tog2 < BERLIN > => 0p256

    rule Gaccessliststoragekey < BERLIN > => 1900p256
    rule Gaccesslistaddress    < BERLIN > => 2400p256

    rule maxInitCodeSize   < BERLIN > => 0p256
    rule Ginitcodewordcost < BERLIN > => 0p256

    rule Rmaxquotient < BERLIN > => 2p256

    rule Gselfdestructnewaccount << BERLIN >> => true
    rule Gstaticcalldepth        << BERLIN >> => false
    rule Gemptyisnonexistent     << BERLIN >> => true
    rule Gzerovaluenewaccountgas << BERLIN >> => false
    rule Ghasrevert              << BERLIN >> => true
    rule Ghasreturndata          << BERLIN >> => true
    rule Ghasstaticcall          << BERLIN >> => true
    rule Ghasshift               << BERLIN >> => true
    rule Ghasdirtysstore         << BERLIN >> => true
    rule Ghassstorestipend       << BERLIN >> => true
    rule Ghascreate2             << BERLIN >> => true
    rule Ghasextcodehash         << BERLIN >> => true
    rule Ghasselfbalance         << BERLIN >> => true
    rule Ghaschainid             << BERLIN >> => true
    rule Ghasaccesslist          << BERLIN >> => true
    rule Ghasbasefee             << BERLIN >> => false
    rule Ghasrejectedfirstbyte   << BERLIN >> => false
    rule Ghasprevrandao          << BERLIN >> => false
    rule Ghasmaxinitcodesize     << BERLIN >> => false
    rule Ghaspushzero            << BERLIN >> => false
    rule Ghaswarmcoinbase        << BERLIN >> => false
    rule Ghaswithdrawals         << BERLIN >> => false
    rule Ghastransient           << BERLIN >> => false
    rule Ghasmcopy               << BERLIN >> => false
    rule Ghasbeaconroot          << BERLIN >> => false
    rule Ghaseip6780             << BERLIN >> => false
    rule Ghasblobbasefee         << BERLIN >> => false
    rule Ghasblobhash            << BERLIN >> => false
    rule Ghasbls12msmdiscount    << BERLIN >> => false
    rule Ghasdelegation          << BERLIN >> => false
```

### London Schedule

```k
    syntax Schedule ::= "LONDON" [symbol(LONDON_EVM), smtlib(schedule_LONDON)]
 // --------------------------------------------------------------------------
    rule Gzero    < LONDON > => 0p256
    rule Gbase    < LONDON > => 2p256
    rule Gverylow < LONDON > => 3p256
    rule Glow     < LONDON > => 5p256
    rule Gmid     < LONDON > => 8p256
    rule Ghigh    < LONDON > => 10p256

    rule Gexp      < LONDON > => 10p256
    rule Gexpbyte  < LONDON > => 50p256
    rule Gsha3     < LONDON > => 30p256
    rule Gsha3word < LONDON > => 6p256

    rule Gsload       < LONDON > => 100p256
    rule Gsstoreset   < LONDON > => 20000p256
    rule Gsstorereset < LONDON > => 2900p256
    rule Rsstoreclear < LONDON > => 4800p256

    rule Glog      < LONDON > => 375p256
    rule Glogdata  < LONDON > => 8p256
    rule Glogtopic < LONDON > => 375p256

    rule Gcall        < LONDON > => 700p256
    rule Gcallstipend < LONDON > => 2300p256
    rule Gcallvalue   < LONDON > => 9000p256
    rule Gnewaccount  < LONDON > => 25000p256

    rule Gcreate       < LONDON > => 32000p256
    rule Gcodedeposit  < LONDON > => 200p256
    rule Gselfdestruct < LONDON > => 5000p256
    rule Rselfdestruct < LONDON > => 0p256

    rule Gmemory      < LONDON > => 3p256
    rule Gquadcoeff   < LONDON > => 512p256
    rule Gcopy        < LONDON > => 3p256
    rule Gquaddivisor < LONDON > => 3p256

    rule Gtransaction   < LONDON > => 21000p256
    rule Gtxcreate      < LONDON > => 53000p256
    rule Gtxdatazero    < LONDON > => 4p256
    rule Gtxdatanonzero < LONDON > => 16p256

    rule Gjumpdest    < LONDON > => 1p256
    rule Gbalance     < LONDON > => 700p256
    rule Gblockhash   < LONDON > => 20p256
    rule Gextcodesize < LONDON > => 700p256
    rule Gextcodecopy < LONDON > => 700p256

    rule Gecadd       < LONDON > => 150p256
    rule Gecmul       < LONDON > => 6000p256
    rule Gecpairconst < LONDON > => 45000p256
    rule Gecpaircoeff < LONDON > => 34000p256
    rule Gfround      < LONDON > => 1p256

    rule maxCodeSize < LONDON > => 24576p256
    rule Rb          < LONDON > => 2p256 *MInt ethp256

    rule Gcoldsload             < LONDON > => 2100p256
    rule Gcoldaccountaccess     < LONDON > => 2600p256
    rule Gwarmstorageread       < LONDON > => 100p256
    rule Gwarmstoragedirtystore < LONDON > => 0p256

    rule Gpointeval < LONDON > => 0p256

    rule Gbls12g1add < LONDON > => 0p256
    rule Gbls12g1mul < LONDON > => 0p256
    rule Gbls12g2add < LONDON > => 0p256
    rule Gbls12g2mul < LONDON > => 0p256
    rule Gbls12PairingCheckMul < LONDON > => 0p256
    rule Gbls12PairingCheckAdd < LONDON > => 0p256
    rule Gbls12mapfptog1 < LONDON > => 0p256
    rule Gbls12mapfp2tog2 < LONDON > => 0p256

    rule Gaccessliststoragekey < LONDON > => 1900p256
    rule Gaccesslistaddress    < LONDON > => 2400p256

    rule maxInitCodeSize   < LONDON > => 0p256
    rule Ginitcodewordcost < LONDON > => 0p256

    rule Rmaxquotient < LONDON > => 5p256

    rule Gselfdestructnewaccount << LONDON >> => true
    rule Gstaticcalldepth        << LONDON >> => false
    rule Gemptyisnonexistent     << LONDON >> => true
    rule Gzerovaluenewaccountgas << LONDON >> => false
    rule Ghasrevert              << LONDON >> => true
    rule Ghasreturndata          << LONDON >> => true
    rule Ghasstaticcall          << LONDON >> => true
    rule Ghasshift               << LONDON >> => true
    rule Ghasdirtysstore         << LONDON >> => true
    rule Ghassstorestipend       << LONDON >> => true
    rule Ghascreate2             << LONDON >> => true
    rule Ghasextcodehash         << LONDON >> => true
    rule Ghasselfbalance         << LONDON >> => true
    rule Ghaschainid             << LONDON >> => true
    rule Ghasaccesslist          << LONDON >> => true
    rule Ghasbasefee             << LONDON >> => true
    rule Ghasrejectedfirstbyte   << LONDON >> => true
    rule Ghasprevrandao          << LONDON >> => false
    rule Ghasmaxinitcodesize     << LONDON >> => false
    rule Ghaspushzero            << LONDON >> => false
    rule Ghaswarmcoinbase        << LONDON >> => false
    rule Ghaswithdrawals         << LONDON >> => false
    rule Ghastransient           << LONDON >> => false
    rule Ghasmcopy               << LONDON >> => false
    rule Ghasbeaconroot          << LONDON >> => false
    rule Ghaseip6780             << LONDON >> => false
    rule Ghasblobbasefee         << LONDON >> => false
    rule Ghasblobhash            << LONDON >> => false
    rule Ghasbls12msmdiscount    << LONDON >> => false
    rule Ghasdelegation          << LONDON >> => false
```

### Merge Schedule

```k
    syntax Schedule ::= "MERGE" [symbol(MERGE_EVM), smtlib(schedule_MERGE)]
 // -----------------------------------------------------------------------
    rule Gzero    < MERGE > => 0p256
    rule Gbase    < MERGE > => 2p256
    rule Gverylow < MERGE > => 3p256
    rule Glow     < MERGE > => 5p256
    rule Gmid     < MERGE > => 8p256
    rule Ghigh    < MERGE > => 10p256

    rule Gexp      < MERGE > => 10p256
    rule Gexpbyte  < MERGE > => 50p256
    rule Gsha3     < MERGE > => 30p256
    rule Gsha3word < MERGE > => 6p256

    rule Gsload       < MERGE > => 100p256
    rule Gsstoreset   < MERGE > => 20000p256
    rule Gsstorereset < MERGE > => 2900p256
    rule Rsstoreclear < MERGE > => 4800p256

    rule Glog      < MERGE > => 375p256
    rule Glogdata  < MERGE > => 8p256
    rule Glogtopic < MERGE > => 375p256

    rule Gcall        < MERGE > => 700p256
    rule Gcallstipend < MERGE > => 2300p256
    rule Gcallvalue   < MERGE > => 9000p256
    rule Gnewaccount  < MERGE > => 25000p256

    rule Gcreate       < MERGE > => 32000p256
    rule Gcodedeposit  < MERGE > => 200p256
    rule Gselfdestruct < MERGE > => 5000p256
    rule Rselfdestruct < MERGE > => 0p256

    rule Gmemory      < MERGE > => 3p256
    rule Gquadcoeff   < MERGE > => 512p256
    rule Gcopy        < MERGE > => 3p256
    rule Gquaddivisor < MERGE > => 3p256

    rule Gtransaction   < MERGE > => 21000p256
    rule Gtxcreate      < MERGE > => 53000p256
    rule Gtxdatazero    < MERGE > => 4p256
    rule Gtxdatanonzero < MERGE > => 16p256

    rule Gjumpdest    < MERGE > => 1p256
    rule Gbalance     < MERGE > => 700p256
    rule Gblockhash   < MERGE > => 20p256
    rule Gextcodesize < MERGE > => 700p256
    rule Gextcodecopy < MERGE > => 700p256

    rule Gecadd       < MERGE > => 150p256
    rule Gecmul       < MERGE > => 6000p256
    rule Gecpairconst < MERGE > => 45000p256
    rule Gecpaircoeff < MERGE > => 34000p256
    rule Gfround      < MERGE > => 1p256

    rule maxCodeSize < MERGE > => 24576p256
    rule Rb          < MERGE > => 0p256

    rule Gcoldsload             < MERGE > => 2100p256
    rule Gcoldaccountaccess     < MERGE > => 2600p256
    rule Gwarmstorageread       < MERGE > => 100p256
    rule Gwarmstoragedirtystore < MERGE > => 0p256

    rule Gpointeval < MERGE > => 0p256

    rule Gbls12g1add < MERGE > => 0p256
    rule Gbls12g1mul < MERGE > => 0p256
    rule Gbls12g2add < MERGE > => 0p256
    rule Gbls12g2mul < MERGE > => 0p256
    rule Gbls12PairingCheckMul < MERGE > => 0p256
    rule Gbls12PairingCheckAdd < MERGE > => 0p256
    rule Gbls12mapfptog1 < MERGE > => 0p256
    rule Gbls12mapfp2tog2 < MERGE > => 0p256

    rule Gaccessliststoragekey < MERGE > => 1900p256
    rule Gaccesslistaddress    < MERGE > => 2400p256

    rule maxInitCodeSize   < MERGE > => 0p256
    rule Ginitcodewordcost < MERGE > => 0p256

    rule Rmaxquotient < MERGE > => 5p256

    rule Gselfdestructnewaccount << MERGE >> => true
    rule Gstaticcalldepth        << MERGE >> => false
    rule Gemptyisnonexistent     << MERGE >> => true
    rule Gzerovaluenewaccountgas << MERGE >> => false
    rule Ghasrevert              << MERGE >> => true
    rule Ghasreturndata          << MERGE >> => true
    rule Ghasstaticcall          << MERGE >> => true
    rule Ghasshift               << MERGE >> => true
    rule Ghasdirtysstore         << MERGE >> => true
    rule Ghassstorestipend       << MERGE >> => true
    rule Ghascreate2             << MERGE >> => true
    rule Ghasextcodehash         << MERGE >> => true
    rule Ghasselfbalance         << MERGE >> => true
    rule Ghaschainid             << MERGE >> => true
    rule Ghasaccesslist          << MERGE >> => true
    rule Ghasbasefee             << MERGE >> => true
    rule Ghasrejectedfirstbyte   << MERGE >> => true
    rule Ghasprevrandao          << MERGE >> => true
    rule Ghasmaxinitcodesize     << MERGE >> => false
    rule Ghaspushzero            << MERGE >> => false
    rule Ghaswarmcoinbase        << MERGE >> => false
    rule Ghaswithdrawals         << MERGE >> => false
    rule Ghastransient           << MERGE >> => false
    rule Ghasmcopy               << MERGE >> => false
    rule Ghasbeaconroot          << MERGE >> => false
    rule Ghaseip6780             << MERGE >> => false
    rule Ghasblobbasefee         << MERGE >> => false
    rule Ghasblobhash            << MERGE >> => false
    rule Ghasbls12msmdiscount    << MERGE >> => false
    rule Ghasdelegation          << MERGE >> => false
```

### Shanghai Schedule

```k
    syntax Schedule ::= "SHANGHAI" [symbol(SHANGHAI_EVM), smtlib(schedule_SHANGHAI)]
 // --------------------------------------------------------------------------------
    rule Gzero    < SHANGHAI > => 0p256

    rule Gbase    < SHANGHAI > => 2p256
    rule Gverylow < SHANGHAI > => 3p256
    rule Glow     < SHANGHAI > => 5p256
    rule Gmid     < SHANGHAI > => 8p256
    rule Ghigh    < SHANGHAI > => 10p256

    rule Gexp      < SHANGHAI > => 10p256
    rule Gexpbyte  < SHANGHAI > => 50p256
    rule Gsha3     < SHANGHAI > => 30p256
    rule Gsha3word < SHANGHAI > => 6p256

    rule Gsload       < SHANGHAI > => 100p256
    rule Gsstoreset   < SHANGHAI > => 20000p256
    rule Gsstorereset < SHANGHAI > => 2900p256
    rule Rsstoreclear < SHANGHAI > => 4800p256

    rule Glog      < SHANGHAI > => 375p256
    rule Glogdata  < SHANGHAI > => 8p256
    rule Glogtopic < SHANGHAI > => 375p256

    rule Gcall        < SHANGHAI > => 700p256
    rule Gcallstipend < SHANGHAI > => 2300p256
    rule Gcallvalue   < SHANGHAI > => 9000p256
    rule Gnewaccount  < SHANGHAI > => 25000p256

    rule Gcreate       < SHANGHAI > => 32000p256
    rule Gcodedeposit  < SHANGHAI > => 200p256
    rule Gselfdestruct < SHANGHAI > => 5000p256
    rule Rselfdestruct < SHANGHAI > => 0p256

    rule Gmemory      < SHANGHAI > => 3p256
    rule Gquadcoeff   < SHANGHAI > => 512p256
    rule Gcopy        < SHANGHAI > => 3p256
    rule Gquaddivisor < SHANGHAI > => 3p256

    rule Gtransaction   < SHANGHAI > => 21000p256
    rule Gtxcreate      < SHANGHAI > => 53000p256
    rule Gtxdatazero    < SHANGHAI > => 4p256
    rule Gtxdatanonzero < SHANGHAI > => 16p256

    rule Gjumpdest    < SHANGHAI > => 1p256
    rule Gbalance     < SHANGHAI > => 700p256
    rule Gblockhash   < SHANGHAI > => 20p256
    rule Gextcodesize < SHANGHAI > => 700p256
    rule Gextcodecopy < SHANGHAI > => 700p256

    rule Gecadd       < SHANGHAI > => 150p256
    rule Gecmul       < SHANGHAI > => 6000p256
    rule Gecpairconst < SHANGHAI > => 45000p256
    rule Gecpaircoeff < SHANGHAI > => 34000p256
    rule Gfround      < SHANGHAI > => 1p256

    rule maxCodeSize < SHANGHAI > => 24576p256
    rule Rb          < SHANGHAI > => 0p256

    rule Gcoldsload             < SHANGHAI > => 2100p256
    rule Gcoldaccountaccess     < SHANGHAI > => 2600p256
    rule Gwarmstorageread       < SHANGHAI > => 100p256
    rule Gwarmstoragedirtystore < SHANGHAI > => 0p256

    rule Gpointeval < SHANGHAI > => 0p256

    rule Gbls12g1add < SHANGHAI > => 0p256
    rule Gbls12g1mul < SHANGHAI > => 0p256
    rule Gbls12g2add < SHANGHAI > => 0p256
    rule Gbls12g2mul < SHANGHAI > => 0p256
    rule Gbls12PairingCheckMul < SHANGHAI > => 0p256
    rule Gbls12PairingCheckAdd < SHANGHAI > => 0p256
    rule Gbls12mapfptog1 < SHANGHAI > => 0p256
    rule Gbls12mapfp2tog2 < SHANGHAI > => 0p256

    rule Gaccessliststoragekey < SHANGHAI > => 1900p256
    rule Gaccesslistaddress    < SHANGHAI > => 2400p256

    rule maxInitCodeSize   < SHANGHAI > => 49152p256
    rule Ginitcodewordcost < SHANGHAI > => 2p256

    rule Rmaxquotient < SHANGHAI > => 5p256

    rule Gselfdestructnewaccount << SHANGHAI >> => true
    rule Gstaticcalldepth        << SHANGHAI >> => false
    rule Gemptyisnonexistent     << SHANGHAI >> => true
    rule Gzerovaluenewaccountgas << SHANGHAI >> => false
    rule Ghasrevert              << SHANGHAI >> => true
    rule Ghasreturndata          << SHANGHAI >> => true
    rule Ghasstaticcall          << SHANGHAI >> => true
    rule Ghasshift               << SHANGHAI >> => true
    rule Ghasdirtysstore         << SHANGHAI >> => true
    rule Ghassstorestipend       << SHANGHAI >> => true
    rule Ghascreate2             << SHANGHAI >> => true
    rule Ghasextcodehash         << SHANGHAI >> => true
    rule Ghasselfbalance         << SHANGHAI >> => true
    rule Ghaschainid             << SHANGHAI >> => true
    rule Ghasaccesslist          << SHANGHAI >> => true
    rule Ghasbasefee             << SHANGHAI >> => true
    rule Ghasrejectedfirstbyte   << SHANGHAI >> => true
    rule Ghasprevrandao          << SHANGHAI >> => true
    rule Ghasmaxinitcodesize     << SHANGHAI >> => true
    rule Ghaspushzero            << SHANGHAI >> => true
    rule Ghaswarmcoinbase        << SHANGHAI >> => true
    rule Ghaswithdrawals         << SHANGHAI >> => true
    rule Ghastransient           << SHANGHAI >> => false
    rule Ghasmcopy               << SHANGHAI >> => false
    rule Ghasbeaconroot          << SHANGHAI >> => false
    rule Ghaseip6780             << SHANGHAI >> => false
    rule Ghasblobbasefee         << SHANGHAI >> => false
    rule Ghasblobhash            << SHANGHAI >> => false
    rule Ghasbls12msmdiscount    << SHANGHAI >> => false
    rule Ghasdelegation          << SHANGHAI >> => false
```

### Cancun Schedule

```k
    syntax Schedule ::= "CANCUN" [symbol(CANCUN_EVM), smtlib(schedule_CANCUN)]
 // --------------------------------------------------------------------------
    rule Gzero    < CANCUN > => 0p256

    rule Gbase    < CANCUN > => 2p256
    rule Gverylow < CANCUN > => 3p256
    rule Glow     < CANCUN > => 5p256
    rule Gmid     < CANCUN > => 8p256
    rule Ghigh    < CANCUN > => 10p256

    rule Gexp      < CANCUN > => 10p256
    rule Gexpbyte  < CANCUN > => 50p256
    rule Gsha3     < CANCUN > => 30p256
    rule Gsha3word < CANCUN > => 6p256

    rule Gsload       < CANCUN > => 100p256
    rule Gsstoreset   < CANCUN > => 20000p256
    rule Gsstorereset < CANCUN > => 2900p256
    rule Rsstoreclear < CANCUN > => 4800p256

    rule Glog      < CANCUN > => 375p256
    rule Glogdata  < CANCUN > => 8p256
    rule Glogtopic < CANCUN > => 375p256

    rule Gcall        < CANCUN > => 700p256
    rule Gcallstipend < CANCUN > => 2300p256
    rule Gcallvalue   < CANCUN > => 9000p256
    rule Gnewaccount  < CANCUN > => 25000p256

    rule Gcreate       < CANCUN > => 32000p256
    rule Gcodedeposit  < CANCUN > => 200p256
    rule Gselfdestruct < CANCUN > => 5000p256
    rule Rselfdestruct < CANCUN > => 0p256

    rule Gmemory      < CANCUN > => 3p256
    rule Gquadcoeff   < CANCUN > => 512p256
    rule Gcopy        < CANCUN > => 3p256
    rule Gquaddivisor < CANCUN > => 3p256

    rule Gtransaction   < CANCUN > => 21000p256
    rule Gtxcreate      < CANCUN > => 53000p256
    rule Gtxdatazero    < CANCUN > => 4p256
    rule Gtxdatanonzero < CANCUN > => 16p256

    rule Gjumpdest    < CANCUN > => 1p256
    rule Gbalance     < CANCUN > => 700p256
    rule Gblockhash   < CANCUN > => 20p256
    rule Gextcodesize < CANCUN > => 700p256
    rule Gextcodecopy < CANCUN > => 700p256

    rule Gecadd       < CANCUN > => 150p256
    rule Gecmul       < CANCUN > => 6000p256
    rule Gecpairconst < CANCUN > => 45000p256
    rule Gecpaircoeff < CANCUN > => 34000p256
    rule Gfround      < CANCUN > => 1p256

    rule maxCodeSize < CANCUN > => 24576p256
    rule Rb          < CANCUN > => 0p256

    rule Gcoldsload             < CANCUN > => 2100p256
    rule Gcoldaccountaccess     < CANCUN > => 2600p256
    rule Gwarmstorageread       < CANCUN > => 100p256
    rule Gwarmstoragedirtystore < CANCUN > => 100p256

    rule Gpointeval < CANCUN > => 50000p256

    rule Gbls12g1add < CANCUN > => 0p256
    rule Gbls12g1mul < CANCUN > => 0p256
    rule Gbls12g2add < CANCUN > => 0p256
    rule Gbls12g2mul < CANCUN > => 0p256
    rule Gbls12PairingCheckMul < CANCUN > => 0p256
    rule Gbls12PairingCheckAdd < CANCUN > => 0p256
    rule Gbls12mapfptog1 < CANCUN > => 0p256
    rule Gbls12mapfp2tog2 < CANCUN > => 0p256

    rule Gaccessliststoragekey < CANCUN > => 1900p256
    rule Gaccesslistaddress    < CANCUN > => 2400p256

    rule maxInitCodeSize   < CANCUN > => 49152p256
    rule Ginitcodewordcost < CANCUN > => 2p256

    rule Rmaxquotient < CANCUN > => 5p256

    rule Gselfdestructnewaccount << CANCUN >> => true
    rule Gstaticcalldepth        << CANCUN >> => false
    rule Gemptyisnonexistent     << CANCUN >> => true
    rule Gzerovaluenewaccountgas << CANCUN >> => false
    rule Ghasrevert              << CANCUN >> => true
    rule Ghasreturndata          << CANCUN >> => true
    rule Ghasstaticcall          << CANCUN >> => true
    rule Ghasshift               << CANCUN >> => true
    rule Ghasdirtysstore         << CANCUN >> => true
    rule Ghassstorestipend       << CANCUN >> => true
    rule Ghascreate2             << CANCUN >> => true
    rule Ghasextcodehash         << CANCUN >> => true
    rule Ghasselfbalance         << CANCUN >> => true
    rule Ghaschainid             << CANCUN >> => true
    rule Ghasaccesslist          << CANCUN >> => true
    rule Ghasbasefee             << CANCUN >> => true
    rule Ghasrejectedfirstbyte   << CANCUN >> => true
    rule Ghasprevrandao          << CANCUN >> => true
    rule Ghasmaxinitcodesize     << CANCUN >> => true
    rule Ghaspushzero            << CANCUN >> => true
    rule Ghaswarmcoinbase        << CANCUN >> => true
    rule Ghaswithdrawals         << CANCUN >> => true
    rule Ghastransient           << CANCUN >> => true
    rule Ghasmcopy               << CANCUN >> => true
    rule Ghasbeaconroot          << CANCUN >> => true
    rule Ghaseip6780             << CANCUN >> => true
    rule Ghasblobbasefee         << CANCUN >> => true
    rule Ghasblobhash            << CANCUN >> => true
    rule Ghasbls12msmdiscount    << CANCUN >> => false
    rule Ghasdelegation          << CANCUN >> => false

```

### Prague Schedule

```k
    syntax Schedule ::= "PRAGUE" [symbol(PRAGUE_EVM), smtlib(schedule_PRAGUE)]
 // --------------------------------------------------------------------------

    rule Gzero    < PRAGUE > => 0p256

    rule Gbase    < PRAGUE > => 2p256
    rule Gverylow < PRAGUE > => 3p256
    rule Glow     < PRAGUE > => 5p256
    rule Gmid     < PRAGUE > => 8p256
    rule Ghigh    < PRAGUE > => 10p256

    rule Gexp      < PRAGUE > => 10p256
    rule Gexpbyte  < PRAGUE > => 50p256
    rule Gsha3     < PRAGUE > => 30p256
    rule Gsha3word < PRAGUE > => 6p256

    rule Gsload       < PRAGUE > => 100p256
    rule Gsstoreset   < PRAGUE > => 20000p256
    rule Gsstorereset < PRAGUE > => 2900p256
    rule Rsstoreclear < PRAGUE > => 4800p256

    rule Glog      < PRAGUE > => 375p256
    rule Glogdata  < PRAGUE > => 8p256
    rule Glogtopic < PRAGUE > => 375p256

    rule Gcall        < PRAGUE > => 700p256
    rule Gcallstipend < PRAGUE > => 2300p256
    rule Gcallvalue   < PRAGUE > => 9000p256
    rule Gnewaccount  < PRAGUE > => 25000p256

    rule Gcreate       < PRAGUE > => 32000p256
    rule Gcodedeposit  < PRAGUE > => 200p256
    rule Gselfdestruct < PRAGUE > => 5000p256
    rule Rselfdestruct < PRAGUE > => 0p256

    rule Gmemory      < PRAGUE > => 3p256
    rule Gquadcoeff   < PRAGUE > => 512p256
    rule Gcopy        < PRAGUE > => 3p256
    rule Gquaddivisor < PRAGUE > => 3p256

    rule Gtransaction   < PRAGUE > => 21000p256
    rule Gtxcreate      < PRAGUE > => 53000p256
    rule Gtxdatazero    < PRAGUE > => 4p256
    rule Gtxdatanonzero < PRAGUE > => 16p256

    rule Gjumpdest    < PRAGUE > => 1p256
    rule Gbalance     < PRAGUE > => 700p256
    rule Gblockhash   < PRAGUE > => 20p256
    rule Gextcodesize < PRAGUE > => 700p256
    rule Gextcodecopy < PRAGUE > => 700p256

    rule Gecadd       < PRAGUE > => 150p256
    rule Gecmul       < PRAGUE > => 6000p256
    rule Gecpairconst < PRAGUE > => 45000p256
    rule Gecpaircoeff < PRAGUE > => 34000p256
    rule Gfround      < PRAGUE > => 1p256

    rule maxCodeSize < PRAGUE > => 24576p256
    rule Rb          < PRAGUE > => 0p256

    rule Gcoldsload             < PRAGUE > => 2100p256
    rule Gcoldaccountaccess     < PRAGUE > => 2600p256
    rule Gwarmstorageread       < PRAGUE > => 100p256
    rule Gwarmstoragedirtystore < PRAGUE > => 100p256

    rule Gpointeval < PRAGUE > => 50000p256

    rule Gbls12g1add < PRAGUE > => 375p256
    rule Gbls12g1mul < PRAGUE > => 12000p256
    rule Gbls12g2add < PRAGUE > => 600p256
    rule Gbls12g2mul < PRAGUE > => 22500p256
    rule Gbls12PairingCheckMul < PRAGUE > => 32600p256
    rule Gbls12PairingCheckAdd < PRAGUE > => 37700p256
    rule Gbls12mapfptog1 < PRAGUE > => 5500p256
    rule Gbls12mapfp2tog2 < PRAGUE > => 23800p256

    rule Gaccessliststoragekey < PRAGUE > => 1900p256
    rule Gaccesslistaddress    < PRAGUE > => 2400p256

    rule maxInitCodeSize   < PRAGUE > => 49152p256
    rule Ginitcodewordcost < PRAGUE > => 2p256

    rule Rmaxquotient < PRAGUE > => 5p256

    rule Gselfdestructnewaccount << PRAGUE >> => true
    rule Gstaticcalldepth        << PRAGUE >> => false
    rule Gemptyisnonexistent     << PRAGUE >> => true
    rule Gzerovaluenewaccountgas << PRAGUE >> => false
    rule Ghasrevert              << PRAGUE >> => true
    rule Ghasreturndata          << PRAGUE >> => true
    rule Ghasstaticcall          << PRAGUE >> => true
    rule Ghasshift               << PRAGUE >> => true
    rule Ghasdirtysstore         << PRAGUE >> => true
    rule Ghassstorestipend       << PRAGUE >> => true
    rule Ghascreate2             << PRAGUE >> => true
    rule Ghasextcodehash         << PRAGUE >> => true
    rule Ghasselfbalance         << PRAGUE >> => true
    rule Ghaschainid             << PRAGUE >> => true
    rule Ghasaccesslist          << PRAGUE >> => true
    rule Ghasbasefee             << PRAGUE >> => true
    rule Ghasrejectedfirstbyte   << PRAGUE >> => true
    rule Ghasprevrandao          << PRAGUE >> => true
    rule Ghasmaxinitcodesize     << PRAGUE >> => true
    rule Ghaspushzero            << PRAGUE >> => true
    rule Ghaswarmcoinbase        << PRAGUE >> => true
    rule Ghaswithdrawals         << PRAGUE >> => true
    rule Ghastransient           << PRAGUE >> => true
    rule Ghasmcopy               << PRAGUE >> => true
    rule Ghasbeaconroot          << PRAGUE >> => true
    rule Ghaseip6780             << PRAGUE >> => true
    rule Ghasblobbasefee         << PRAGUE >> => true
    rule Ghasblobhash            << PRAGUE >> => true
    rule Ghasbls12msmdiscount    << PRAGUE >> => true
    rule Ghasdelegation          << PRAGUE >> => true

endmodule
```
