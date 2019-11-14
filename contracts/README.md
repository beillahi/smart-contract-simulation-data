# Smart Contract Collection Prodcedure


* Fix solidity compiler version 
* Fix import paths to be relative the ```contracts``` folder
* Fix constructor declaration 
* Fix methods signatures to match the ones in spec contract
* Fix methods vibility (in older solidity versions it was possible to not specify visibility of methods)
* Add ```emit``` primtive to modifiers calls
* Convert ```address.send(amt)``` and ```address.call.value(amt)``` to the safe ```address.transfer(amt)```
* Convert ```constant``` to  either ```view``` or ```pure``` 
* Convert ```abort``` to ```revert```
* Convert ```assert``` in SafeMath library to ```require``` (specific for ```SafeMath```)

* For contracts that inherit for other contracts, we face some challenges: 
1) When we move in the examplified contract to the folder ```.sc-simulation.ignore```, we need to fix the import paths accordingly
2) Internalizing methods that were public results in visibility mis-matching between the super-contract in the internalized contract. 
3) If some the contract fields are inherited from other contracts, currently we cannot support the extracts of these fields




