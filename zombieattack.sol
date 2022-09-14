pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";
import "./safeMath";

contract ZombieAttack is ZombieHelper {
    using SafeMath for uint256;
    uint256 randNounce = 0;
    uint256 attackVictoryProbability = 70;

    function randMod(uint256 modulus) internal returns (uint256) {
        randNounce = randNounce.add(1);
        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNounce))) %
            _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId) external {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint256 rand = randMod(100);

        if (rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }
}
