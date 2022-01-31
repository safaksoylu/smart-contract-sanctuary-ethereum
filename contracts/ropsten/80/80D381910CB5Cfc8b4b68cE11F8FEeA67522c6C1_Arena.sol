// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../interfaces/IToken.sol";
import "../interfaces/IPT.sol";
import "../interfaces/IArena.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Arena is IArena, Ownable, ReentrancyGuard, IERC721Receiver, Pausable {
    using SafeMath for uint256;
    // struct to store a stake's token, owner, and the time it's staked at
    struct Stake {
        uint256 tokenId;
        uint80 stakedAt; // stake time
        address owner;
    }

    // number of staked NFTs in Arena
    uint256 private numPetsStaked;

    event TokenStaked(
        address indexed owner,
        uint256 indexed tokenId,
        uint256 value
    );
    event TokenClaimed(
        uint256 indexed tokenId,
        bool indexed unstaked,
        uint256 earned
    );

    struct Pet {
        uint256 strength;
        uint256 magic;
        uint256 dexterity;
        uint256 charisma;
        uint256 intelligence;
        uint256 luck;
    }

    struct ArenaInfo {
        string arenaName;
        uint256 strength;
        uint256 magic;
        uint256 dexterity;
        uint256 charisma;
        uint256 intelligence;
        uint256 luck;
    }

    ArenaInfo squidGame = ArenaInfo("Squid Game", 3, 1, 4, 8, 1, 2);
    ArenaInfo deathmatch = ArenaInfo("Deathmatch", 8, 4, 7, 3, 1, 4);
    ArenaInfo escapeRoom = ArenaInfo("Escape Room", 2, 4, 6, 9, 2, 6);
    ArenaInfo KombatIsland = ArenaInfo("Kombat Island", 8, 4, 6, 2, 2, 7);
    ArenaInfo hideAndSeek = ArenaInfo("Hide and Seek", 2, 4, 6, 9, 8, 4);
    ArenaInfo captureTheFlag = ArenaInfo("Capture the Flag", 6, 4, 8, 3, 6, 3);
    ArenaInfo freezeDance = ArenaInfo("Freeze Dance", 2, 1, 6, 9, 8, 2);

    // is game ended
    bool gameEnded = true;

    // maps tokenId to Pet
    mapping(uint256 => Pet) private _stakedTokenDetails;

    //maps tokenId to score
    mapping(uint256 => uint256) public scores;

    // reference to Token contract
    IToken public token;
    // reference to the $PT contract for minting $PT earnings
    IPT public pt;

    // the current Arena
    ArenaInfo currentArena;

    // maps tokenId to stake
    mapping(uint256 => Stake) private stakedToArena;

    // maps address to tokenIds
    mapping(address => uint256[]) private tokensOfAddress;

    // the time pet have to play and cannot be unstaked until then
    uint256 public stakeTime;
    // there will only ever be (roughly) 2.4 billion $GP earned through staking
    uint256 public constant MAXIMUM_GLOBAL_PT = 2880000000 ether;

    // amount of $PT earned so far
    uint256 public totalPTEarned;

    // emergency rescue to allow unstaking without any checks but without $GP
    bool public rescueEnabled = false;

    //the time game starts
    uint256 startGameTime;

    ArenaInfo[] arenas;

    /**
     */
    constructor() {
        _pause();
        //arenas = new ArenaInfo[];
        arenas.push(squidGame);
        arenas.push(deathmatch);
        arenas.push(escapeRoom);
        arenas.push(KombatIsland);
        arenas.push(hideAndSeek);
        arenas.push(captureTheFlag);
        arenas.push(freezeDance);
    }

    /** CRITICAL TO SETUP */

    modifier requireContractsSet() {
        require(
            address(token) != address(0) && address(pt) != address(0),
            "Contracts not set"
        );
        _;
    }

    // set the contracts that are working with the Arena contract
    function setContracts(address _token, address _pt) external onlyOwner {
        token = IToken(_token);
        pt = IPT(_pt);
    }

    // set the time that is allowed to stake
    function setStakeTime(uint256 _stakeTime) internal onlyOwner {
        stakeTime = _stakeTime * 1 minutes;
    }

    // add a new arenas to the game
    function addNewArenas(ArenaInfo[] memory newArenas) external onlyOwner {
        for (uint256 i; i < newArenas.length; i++) {
            arenas.push(newArenas[i]);
        }
    }

    // add a new arena to the game
    function addNewArena(ArenaInfo memory newArena) external onlyOwner {
        arenas.push(newArena);
    }

    // get arena for the current game
    function getCurrentArena() external view onlyOwner returns (string memory) {
        return currentArena.arenaName;
    }

    function getStakedTokenDetails(uint256 tokenId)
        external
        view
        returns (Pet memory)
    {
        return _stakedTokenDetails[tokenId];
    }

    // get all the NFTs an address staked
    function getTokensOfAddress(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        return tokensOfAddress[_owner];
    }

    // get the amount of NFTs an address staked
    function getNumberOfTokensForUser(address _owner)
        external
        view
        returns (uint256)
    {
        return tokensOfAddress[_owner].length;
    }

    // get an NFT TokenId by index from array of NFTs maped to an address
    function getStakedItemByIndex(address _owner, uint256 _index)
        external
        view
        returns (uint256)
    {
        return tokensOfAddress[_owner][_index];
    }

    // get owner address, tokenId, stakedAt time for a staked NFT
    function getStakedToArena(uint256 tokenId)
        external
        view
        returns (Stake memory)
    {
        return stakedToArena[tokenId];
    }

    // get all available arenas
    function getNumOfArenas() external view onlyOwner returns (uint256) {
        return arenas.length;
    }

    /**
     * generates a pseudorandom number
     * @param seed a value ensure different outcomes for different sources in the same block
     * @return a pseudorandom value
     */
    function random(uint256 seed) internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        tx.origin,
                        blockhash(block.number - 1),
                        block.timestamp,
                        seed
                    )
                )
            );
    }

    //to recieve ETH to Arena contract
    receive() external payable {}

    /** STAKING */

    /**
     * adds pets to the Arena and play
     * @param account the address of the staker
     * @param tokenIds the IDs of the Pets to stake
     */
    function addManyToArenaAndPlay(address account, uint256[] calldata tokenIds)
        external
        override
        nonReentrant
    {
        // check if we can remove "account"
        require((stakeTime + startGameTime > block.timestamp), "game finished");
        require(
            tx.origin == _msgSender() || _msgSender() == address(token),
            "Only EOA"
        );
        require(account == tx.origin, "account to sender mismatch"); // maybe remove

        uint256 index = 0;

        while (index < tokenIds.length) {
            if (_msgSender() != address(token)) {
                // chack if we can change to "require"
                require(
                    token.ownerOf(tokenIds[index]) == _msgSender(), // check if we what that only the user himself can call
                    "You don't own this token"
                );

                token.transferFrom(
                    _msgSender(),
                    address(this),
                    tokenIds[index]
                );
                _addPetToPlay(account, tokenIds[index]);
            }
            index++;
        }
    }

    /**
     * adds a single Pet to the Arena to play
     * @param account the address of the staker
     * @param tokenId the ID of the Pet to add to Play
     */
    function _addPetToPlay(address account, uint256 tokenId)
        internal
        whenNotPaused
    {
        stakedToArena[tokenId] = Stake({
            owner: account,
            tokenId: uint256(tokenId),
            stakedAt: uint80(block.timestamp)
        });

        tokensOfAddress[account].push(tokenId);

        _stakedTokenDetails[tokenId] = Pet(
            token.getTokenDetails(tokenId).strength,
            token.getTokenDetails(tokenId).magic,
            token.getTokenDetails(tokenId).dexterity,
            token.getTokenDetails(tokenId).charisma,
            token.getTokenDetails(tokenId).intelligence,
            token.getTokenDetails(tokenId).luck
        );

        numPetsStaked += 1;
        emit TokenStaked(account, tokenId, block.timestamp);
    }

    function getNumOfStakedNFTs() external view returns (uint256) {
        return numPetsStaked;
    }

    /** UNSTAKING */

    /**
     * unstake NTFs from the arena
     * @param tokenIds the IDs of the NFTs to claim
     */
    function claimManyFromArenaAndPlay(
        address account,
        uint256[] calldata tokenIds
    ) external override whenNotPaused nonReentrant {
        require(gameEnded == true, "the game is not ended yet");
        require(
            tx.origin == _msgSender() || _msgSender() == address(token),
            "Only EOA"
        );
        require(account == tx.origin, "account to sender mismatch");
        uint256 index = 0;

        while (index < tokenIds.length) {
            _claimPetFromArena(tokenIds[index]);
            index++;
        }
        /*
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _claimPetFromArena(tokenIds[i]);
        }
        */
        if (tokensOfAddress[_msgSender()].length > 0) {
            delete tokensOfAddress[_msgSender()];
        }
    }

    /**
     * unstake a single NFT from the arena and get $PT earnings
     * @param tokenId the ID of the pet
     * @return playerScore - the players/pet score
     */
    function _claimPetFromArena(uint256 tokenId)
        internal
        returns (uint256 playerScore)
    {
        Stake memory stake = stakedToArena[tokenId];
        require(stake.owner == _msgSender(), "Don't own the given token");
        require(
            !(block.timestamp - stake.stakedAt < stakeTime),
            "Still playing in the arena"
        );
        playerScore = calculateScore(tokenId);

        // delete tokensOfAddress[stake.owner][tokenId];  // check
        delete stakedToArena[tokenId];
        numPetsStaked -= 1;

        token.safeTransferFrom(address(this), _msgSender(), tokenId, ""); // send back Pet
        pt.mint(_msgSender(), playerScore);
        scores[tokenId] = playerScore;
        emit TokenClaimed(tokenId, true, playerScore);
    }

    // calculate score for a single NFT
    function calculateScore(uint256 tokenId)
        internal
        view
        returns (uint256 playerScore)
    {
        uint256 randomNum = random(tokenId);
        playerScore = ((randomNum) % 650); // choose a value from 0 to the number of arenas

        uint256 strength = token.getTokenDetails(tokenId).strength;
        uint256 magic = token.getTokenDetails(tokenId).magic;
        uint256 dexterity = token.getTokenDetails(tokenId).dexterity;
        uint256 charisma = token.getTokenDetails(tokenId).charisma;
        uint256 intelligence = token.getTokenDetails(tokenId).intelligence;
        uint256 luck = token.getTokenDetails(tokenId).luck;

        uint256 score = strength *
            currentArena.strength +
            magic *
            currentArena.magic +
            dexterity *
            currentArena.dexterity +
            charisma *
            currentArena.charisma +
            intelligence *
            currentArena.intelligence +
            luck *
            currentArena.luck;

        playerScore += score;

        return playerScore.mul(10000000000000000000);
    }

    // start the game by inputing play time in seconds
    function startGame(uint256 _stakeTime) external onlyOwner {
        _unpause();
        gameEnded = false;
        startGameTime = block.timestamp;
        stakeTime = _stakeTime;
    }

    // end the game by inputing random number
    function endGame(uint256 rndNum) external onlyOwner {
        startGameTime = 0;
        stakeTime = 0;
        uint256 randomNum = random(rndNum);
        uint256 rndArenaIndex = ((randomNum) % arenas.length); // choose a value from 0 to the number of arenas
        currentArena = arenas[rndArenaIndex];
        gameEnded = true;
    }

    /** ADMIN */

    /**
     * allows owner to enable "rescue mode"
     * simplifies accounting, prioritizes tokens out in emergency
     */
    function setRescueEnabled(bool _enabled) external onlyOwner {
        rescueEnabled = _enabled;
    }

    /**
     * enables owner to pause / unpause contract
     */
    function setPaused(bool _paused) external requireContractsSet onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        require(from == address(0x0), "Cannot send to arena directly");
        return IERC721Receiver.onERC721Received.selector;
    }

    /**
     * allows owner to withdraw funds
     */
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

interface IToken is IERC721Enumerable {

        struct Pet {
        uint256 strength;
        uint256 magic;
        uint256 dexterity;
        uint256 charisma;
        uint256 intelligence;
        uint256 luck;
    }

    function getTokenDetails(uint256 tokenId) external view returns (Pet memory);
    function playerMint(
        uint256 strength,
        uint256 magic,
        uint256 dexterity,
        uint256 charisma,
        uint256 intelligence,
        uint256 luck) external payable;
    function feed(uint256 tokenId) external;
    function upgrade(
        uint256 tokenId,
        uint256 strength,
        uint256 magic,
        uint256 dexterity,
        uint256 charisma,
        uint256 luck) external;
    function getAllTokensForUser(address user) external view returns (uint256[] memory);
  
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IPT {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
    function updateOriginAccess() external;
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

interface IArena {
  function addManyToArenaAndPlay(address account, uint256[] calldata tokenIds) external;
  function claimManyFromArenaAndPlay(address account ,uint256[] calldata tokenIds) external;
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)

pragma solidity ^0.8.0;

import "../IERC721.sol";

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "../../utils/introspection/IERC165.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)

pragma solidity ^0.8.0;

import "../utils/Context.sol";

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

import "../utils/Context.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}