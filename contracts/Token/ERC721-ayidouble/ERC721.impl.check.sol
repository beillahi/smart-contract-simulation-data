pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/AYIDouble/Simple-Game-ERC-721-Token-Template/blob/master/solidity/contracts/ERC721.sol

/**
  @notice simulation __verifier_eq(ERC721_Impl._tokenOwner, ERC721_Spec._tokenOwner)
  @notice simulation __verifier_eq(ERC721_Impl._tokenApprovals, ERC721_Spec._tokenApprovals)
  @notice simulation __verifier_eq(ERC721_Impl._ownedTokensCount, ERC721_Spec._ownedTokensCount)
  @notice simulation __verifier_eq(ERC721_Impl._operatorApprovals, ERC721_Spec._operatorApprovals)
 */
contract ERC721_Impl {

    bytes4 internal constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) internal _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint => address) internal _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => uint) internal _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) internal _operatorApprovals;

    bytes4 internal constant _InterfaceId_ERC721 = 0x80ac58cd;


    //require(owner != address(0));
    function balanceOf(address owner) public view returns (uint256) {
        return _ownedTokensCount[owner];
    }

    //    require(owner != address(0));
    function ownerOf(uint256 tokenId) public view returns (address) {
        //address owner = _tokenOwner[tokenId];
        return _tokenOwner[tokenId];
    }

    // address owner = ownerOf(tokenId);
    // require(to != owner);
    // require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
    /// @notice modifies _tokenApprovals[tokenId]
    function approve(address to, uint256 tokenId) external {
        address owner = ownerOf(tokenId);
        require(to != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
        _tokenApprovals[tokenId] = to;
        //emit Approval(owner, to, tokenId);
    }

    // require(_exists(tokenId));
    function getApproved(uint256 tokenId) public view returns (address) {
        return _tokenApprovals[tokenId];
    }


    //  require(to != msg.sender);
    /// @notice modifies _operatorApprovals[msg.sender][to]
    function setApprovalForAll(address to, bool approved) public {
         _operatorApprovals[msg.sender][to] = approved;
     }


  function isApprovedForAll(address owner, address operator)
    public
    view
    returns (bool)
  {
    return _operatorApprovals[owner][operator];
  }

    // require(_isApprovedOrOwner(msg.sender, tokenId));
    // require(to != address(0));
    /// @notice modifies _tokenApprovals[tokenId]
    /// @notice modifies _ownedTokensCount[from]
    /// @notice modifies _ownedTokensCount[to]
    /// @notice modifies _tokenOwner[tokenId]
    function transferFrom(address from, address to, uint256 tokenId)
    public
    {
    _clearApproval(from, tokenId);
    _removeTokenFrom(from, tokenId);
    _addTokenTo(to, tokenId);

    }

    /// @notice modifies _tokenApprovals[tokenId]
    function _clearApproval(address owner, uint256 tokenId) internal {
        require(ownerOf(tokenId) == owner, "owner must be the right owner of the token");
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

    // require(ownerOf(tokenId) == from);
    /// @notice modifies _ownedTokensCount[from]
    /// @notice modifies _tokenOwner[tokenId]
    function _removeTokenFrom(address from, uint256 tokenId) internal {
        _ownedTokensCount[from] = _ownedTokensCount[from] - 1;
        _tokenOwner[tokenId] = address(0);
    }


    // require(_tokenOwner[tokenId] == address(0));
    /// @notice modifies _ownedTokensCount[to]
    /// @notice modifies _tokenOwner[tokenId]
    function _addTokenTo(address to, uint256 tokenId) internal {
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to] + 1;
    }

}