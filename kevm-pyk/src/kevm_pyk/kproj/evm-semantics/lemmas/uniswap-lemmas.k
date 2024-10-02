requires "domains.md"
requires "evm.md"

module UNISWAP-LEMMAS
    imports EVM
    imports FLOAT

	rule [sqrt-skip]:
	<kevm>
		<k>
		#execute ~> _REST
		</k>
		<ethereum>
			<evm>
				<callState>
					<id>
					352381412411141363593761104900125842968318969977
					</id>
					<caller>
					575959589790415302576757212507209407703957814182
					</caller>
					<callData>
					b"jbxB\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd2\t2\x0e\xb0f\x9c=M\xd5\x1f\xd8O\xdd\xa3\xc7\xef\xb2J\xef"
					</callData>
					(<wordStack> 
						ListItem ( PAR:Int )
						ListItem ( 1448 ) 
						WSREST 
					</wordStack>
					=>
					<wordStack>
						ListItem ( Float2Int(floorFloat(sqrtFloat(Int2Float(PAR, 192, 64)))) )
						WSREST 
					</wordStack>)
					(<pc> 4400 </pc> => <pc> 1448 </pc>)
					(<gas> 846598 </gas> => <gas> 836628 </gas>)
				...
				</callState>
			...
			</evm>
		...
		</ethereum>
	...
	</kevm> [priority(40)]

endmodule