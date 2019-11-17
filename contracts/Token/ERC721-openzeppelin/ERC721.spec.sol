pragma solidity ^0.5.0;


// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/ERC721.sol


contract ERC721_Spec {

    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);


    bytes4 internal constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    mapping(bytes4 => bool) internal _supportedInterfaces;


    /**
        @notice postcondition   _supportedInterfaces[interfaceId] == true
        @notice modifies  _supportedInterfaces[interfaceId]
    */
    function spec_registerInterface(bytes4 interfaceId) private {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }


    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint => address) internal _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint => address) internal _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => uint) internal _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) internal _operatorApprovals;


        /*
     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
     *
     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
     */
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;


    /**
        @notice postcondition  _supportedInterfaces[_INTERFACE_ID_ERC165] == true
        @notice postcondition  _supportedInterfaces[_INTERFACE_ID_ERC721] == true
        @notice modifies  _supportedInterfaces[_INTERFACE_ID_ERC721]
        @notice modifies  _supportedInterfaces[_INTERFACE_ID_ERC165]
     */
    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        spec_registerInterface(_INTERFACE_ID_ERC165);
        spec_registerInterface(_INTERFACE_ID_ERC721);
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner address to query the balance of
     * @return uint representing the amount owned by the passed address
       @notice precondition owner != address(0)
       @notice postcondition _balanceOf == _ownedTokensCount[owner]
     */
    function balanceOf(address owner) public view returns (uint _balanceOf) {
        return _ownedTokensCount[owner];
    }

    /**
     * @dev Gets the owner of the specified token ID.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
       @notice precondition _tokenOwner[tokenId] != address(0)
       @notice postcondition _ownerOf == _tokenOwner[tokenId]
     */
    function ownerOf(uint256 tokenId) public view returns (address _ownerOf) {
        return _tokenOwner[tokenId];
    }


    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
        @notice precondition _tokenOwner[tokenId] != address(0)
        @notice precondition msg.sender != address(0)
        @notice precondition to != address(0)
        @notice precondition to != _tokenOwner[tokenId]
        @notice precondition msg.sender == _tokenOwner[tokenId] || _operatorApprovals[_tokenOwner[tokenId]][msg.sender]
        @notice postcondition _tokenApprovals[tokenId] == to
        @notice modifies _tokenApprovals[tokenId]
    */
    function approve(address to, uint tokenId) external {
        address owner = _tokenOwner[tokenId];
        require(to != owner);

        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     * @notice precondition _tokenOwner[tokenId] != address(0)
     * @notice postcondition _getApproved == _tokenApprovals[tokenId]
     */
    function getApproved(uint256 tokenId) public view returns (address _getApproved) {
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf.
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
        @notice precondition to != address(0)
        @notice precondition to != msg.sender
        @notice postcondition  _operatorApprovals[msg.sender][to] == approved
        @notice modifies _operatorApprovals[msg.sender][to]
     */
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender);

        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner.
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
       @notice precondition owner != address(0)
       @notice precondition operator != address(0)
       @notice postcondition _isApprovedForAll == _operatorApprovals[owner][operator]
     */
    function isApprovedForAll(address owner, address operator) public view returns (bool _isApprovedForAll) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address.
     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     * Requires the msg.sender to be the owner, approved, or operator.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
        @notice precondition _tokenOwner[tokenId] != address(0)
        @notice precondition msg.sender != address(0)
        @notice precondition msg.sender == _tokenOwner[tokenId] || _tokenApprovals[tokenId] == msg.sender || _operatorApprovals[_tokenOwner[tokenId]][msg.sender]
        @notice precondition from == _tokenOwner[tokenId]
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
    function transferFrom(address from, address to, uint256 tokenId) public {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(msg.sender, tokenId));

        _transferFrom(from, to, tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
       @notice precondition from == _tokenOwner[tokenId]
       @notice precondition to != address(0)
       @notice precondition  1 <= _ownedTokensCount[from]
       @notice postcondition (from == to && _ownedTokensCount[from] == __verifier_old_uint(_ownedTokensCount[from])) || (from != to && _ownedTokensCount[from] == __verifier_old_uint(_ownedTokensCount[from]) - 1)
       @notice postcondition (from == to && _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to])) || (from != to && _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to]) + 1)
       @notice postcondition  _tokenOwner[tokenId] == to
       @notice postcondition  _tokenApprovals[tokenId] == address(0)
       @notice modifies _ownedTokensCount[from]
       @notice modifies _ownedTokensCount[to]
       @notice modifies _tokenOwner[tokenId]
       @notice modifies _tokenApprovals[tokenId]
     */
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(_tokenOwner[tokenId] == from);
        require(to != address(0));

        _clearApproval(tokenId);

        _ownedTokensCount[from] = _ownedTokensCount[from] - 1;
        _ownedTokensCount[to] = _ownedTokensCount[to] + 1;

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Returns whether the specified token exists.
     * @param tokenId uint256 ID of the token to query the existence of
     * @return bool whether the token exists
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

     /**
     * @dev Returns whether the given spender can transfer a given token ID.
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     * @notice precondition  _tokenOwner[tokenId] != address(0)
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_tokenOwner[tokenId] != address(0));
        address owner =_tokenOwner[tokenId];
        return (spender == owner || _tokenApprovals[tokenId] == spender || _operatorApprovals[owner][spender]);
    }


    /** @notice postcondition  _tokenApprovals[tokenId] == address(0)
        @notice modifies _tokenApprovals[tokenId]
    */
    function _clearApproval(uint tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }


     /**
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
       @notice precondition address(0) == _tokenOwner[tokenId]
       @notice precondition to != address(0)
       @notice postcondition _ownedTokensCount[to] == __verifier_old_uint(_ownedTokensCount[to]) + 1
       @notice postcondition  _tokenOwner[tokenId] == to
       @notice modifies _ownedTokensCount[to]
       @notice modifies _tokenOwner[tokenId]
     */
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(_tokenOwner[tokenId] == address(0), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to] + 1;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use {_burn} instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
       @notice precondition owner == _tokenOwner[tokenId]
       @notice precondition _ownedTokensCount[owner] >= 1
       @notice postcondition  _ownedTokensCount[owner] == __verifier_old_uint(_ownedTokensCount[owner]) - 1
       @notice postcondition  _tokenApprovals[tokenId] == address(0)
       @notice postcondition  _tokenOwner[tokenId] == address(0)
       @notice modifies _ownedTokensCount[owner]
       @notice modifies _tokenOwner[tokenId]
       @notice modifies _tokenApprovals[tokenId]
     */
    function _burn(address owner, uint256 tokenId) internal {
        require(_tokenOwner[tokenId] == owner, "ERC721: burn of token that is not own");

        _clearApproval(tokenId);

        _ownedTokensCount[owner] = _ownedTokensCount[owner] - 1;
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

}
