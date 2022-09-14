pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safeMath";
/// @title The contract that manage zombie's trasfer and ownership
/// @author Dante
/// @notice Explain to an end user what this does
/// @dev  Compliant with OpenZeppelin's implementation of the ERC721 spec draft
contract ZombieOwnership is ZombieAttack, ERC721 {
    
    using SafeMath for uint256;
    mapping(uint256 => address) zombieApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        // 1. Return the number of zombies '_owner' has here
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 tokeId) external view returns (address) {
        // 2. Return the owner of '_tokenId' here
        return zombieToOwner[_tokenId];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(
            zombieToOwner[_tokenId] == msg.sender ||
                zombieApprovals[tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId)
        external
        payable
        onlyOwnerOf(_tokenId)
    {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, tokenId);
    }
}
