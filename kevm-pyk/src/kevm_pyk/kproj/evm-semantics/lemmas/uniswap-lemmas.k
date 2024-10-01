requires "domains.md"
requires "evm.md"

module UNISWAP-LEMMAS
    imports EVM
    imports FLOAT

	rule [sqrt-skip]:
	<kevm>
		<k>
		(#next [ JUMP ] ~> REST => REST)
		</k>
		<ethereum>
			<evm>
				<callState>
					(<wordStack> 
						ListItem ( _DEST )
						ListItem ( PAR:Int )
						ListItem ( _PC ) 
						WSREST 
					</wordStack>
					=>
					<wordStack>
						ListItem ( Float2Int(floorFloat(sqrtFloat(Int2Float(PAR, 192, 64)))) )
						WSREST 
					</wordStack>)
					(<pc> 1447 </pc> => <pc> 1448 </pc>)
					(<gas> 846606 </gas> => <gas> 836628 </gas>)
				...
				</callState>
			...
			</evm>
		...
		</ethereum>
	...
	</kevm> [priority(40)]

endmodule