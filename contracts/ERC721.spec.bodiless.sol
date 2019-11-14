pragma solidity >=0.5.0;


// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721.sol


contract ERC721_Spec {
   uint public shadow$spec$Balance; 
   modifier shadow$spec$Balance$Modifier {
            shadow$spec$Balance = address(this).balance - msg.value;
            _;
            shadow$spec$Balance = address(this).balance;
        } 
   modifier shadow$spec$Balance$Modifier1 {
            shadow$spec$Balance = address(this).balance;
            _;
            shadow$spec$Balance = address(this).balance;
        }

    //bytes4 internal constant _ERC721_RECEIVED = 0x150b7a02;
    //bytes4 internal constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    // Mapping from token ID to owner
    mapping (uint => address) internal _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint => address) internal _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => uint) internal _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) internal _operatorApprovals;


    /** @notice precondition owner != address(0)
        @notice postcondition _balanceOf == _ownedTokensCount[owner]
    */
    function  spec_balanceOf( address owner) public view returns (uint _balanceOf) ;


    /** @notice postcondition _ownerOf == _tokenOwner[tokenId]
    */
    function  spec_ownerOf( uint tokenId) public view returns (address _ownerOf) ;



    /** @notice precondition to != address(0)
        @notice precondition msg.sender == _tokenOwner[tokenId]
        @notice postcondition _tokenApprovals[tokenId] == to
        @notice modifies _tokenApprovals[tokenId]
    */
    function  spec_approve( address to, uint tokenId) public ;


    /** @notice postcondition _getApproved == _tokenApprovals[tokenId]
    */
    function  spec_getApproved( uint tokenId) public view returns (address _getApproved) ;


    /** @notice precondition to != address(0)
        @notice postcondition  _operatorApprovals[msg.sender][to] == approved
        @notice modifies _operatorApprovals[msg.sender][to]
    */
    function  spec_setApprovalForAll( address to, bool approved) public ;

    /** @notice precondition owner != address(0)
        @notice precondition operator != address(0)
        @notice postcondition _isApprovedForAll == _operatorApprovals[owner][operator]
    */
    function  spec_isApprovedForAll( address owner, address operator) public view returns (bool _isApprovedForAll) ;

    /** @notice precondition from == _tokenOwner[tokenId]
        @notice precondition to != address(0)
        @notice precondition _ownedTokensCount[from] >= 1
        @notice postcondition (from == to && _ownedTokensCount[from] == __verifier_old_uint(_ownedTokensCount[from])) || (from != to && _ownedTokensCount[from] == __verifier_old_uint(_ownedTokensCount[from]) - 1)
        @notice postcondition (from == to && _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to])) || (from != to && _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to]) + 1)
        @notice postcondition  _tokenOwner[tokenId] == to
        @notice postcondition  _tokenApprovals[tokenId] == address(0)
        @notice modifies _ownedTokensCount[from]
        @notice modifies _ownedTokensCount[to]
        @notice modifies _tokenOwner[tokenId]
        @notice modifies _tokenApprovals[tokenId]
    */
    function  spec_transferFrom( address from, address to, uint tokenId) public ;


    /** @notice precondition from == _tokenOwner[tokenId]
        @notice precondition to != address(0)
        @notice precondition _ownedTokensCount[from] >= 1
        @notice postcondition (from == to && _ownedTokensCount[from] == __verifier_old_uint(_ownedTokensCount[from])) || (from != to && _ownedTokensCount[from] == __verifier_old_uint(_ownedTokensCount[from]) - 1)
        @notice postcondition (from == to && _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to])) || (from != to && _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to]) + 1)
        @notice postcondition  _tokenOwner[tokenId] == to
        @notice postcondition  _tokenApprovals[tokenId] == address(0)
        @notice modifies _ownedTokensCount[from]
        @notice modifies _ownedTokensCount[to]
        @notice modifies _tokenOwner[tokenId]
        @notice modifies _tokenApprovals[tokenId]
    */
    function _transferFrom(address from, address to, uint tokenId) internal {
        _clearApproval(tokenId);

        _ownedTokensCount[from]--;
        _ownedTokensCount[to]++;

        _tokenOwner[tokenId] = to;
    }

    /** @notice postcondition  _tokenApprovals[tokenId] == address(0)
        @notice modifies _tokenApprovals[tokenId]
    */
    function _clearApproval(uint tokenId) internal {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

}
