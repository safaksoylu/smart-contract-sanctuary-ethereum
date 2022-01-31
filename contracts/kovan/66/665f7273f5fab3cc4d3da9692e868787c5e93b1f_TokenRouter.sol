/**
 *Submitted for verification at Etherscan.io on 2022-01-27
*/

// Sources flattened with hardhat v2.8.0 https://hardhat.org

// File @summa-tx/memview-sol/contracts/[email protected]

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.10;

/*
The MIT License (MIT)

Copyright (c) 2016 Smart Contract Solutions, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File @summa-tx/memview-sol/contracts/[email protected]

//
pragma solidity >=0.5.10;

library TypedMemView {
    using SafeMath for uint256;

    // Why does this exist?
    // the solidity `bytes memory` type has a few weaknesses.
    // 1. You can't index ranges effectively
    // 2. You can't slice without copying
    // 3. The underlying data may represent any type
    // 4. Solidity never deallocates memory, and memory costs grow
    //    superlinearly

    // By using a memory view instead of a `bytes memory` we get the following
    // advantages:
    // 1. Slices are done on the stack, by manipulating the pointer
    // 2. We can index arbitrary ranges and quickly convert them to stack types
    // 3. We can insert type info into the pointer, and typecheck at runtime

    // This makes `TypedMemView` a useful tool for efficient zero-copy
    // algorithms.

    // Why bytes29?
    // We want to avoid confusion between views, digests, and other common
    // types so we chose a large and uncommonly used odd number of bytes
    //
    // Note that while bytes are left-aligned in a word, integers and addresses
    // are right-aligned. This means when working in assembly we have to
    // account for the 3 unused bytes on the righthand side
    //
    // First 5 bytes are a type flag.
    // - ff_ffff_fffe is reserved for unknown type.
    // - ff_ffff_ffff is reserved for invalid types/errors.
    // next 12 are memory address
    // next 12 are len
    // bottom 3 bytes are empty

    // Assumptions:
    // - non-modification of memory.
    // - No Solidity updates
    // - - wrt free mem point
    // - - wrt bytes representation in memory
    // - - wrt memory addressing in general

    // Usage:
    // - create type constants
    // - use `assertType` for runtime type assertions
    // - - unfortunately we can't do this at compile time yet :(
    // - recommended: implement modifiers that perform type checking
    // - - e.g.
    // - - `uint40 constant MY_TYPE = 3;`
    // - - ` modifer onlyMyType(bytes29 myView) { myView.assertType(MY_TYPE); }`
    // - instantiate a typed view from a bytearray using `ref`
    // - use `index` to inspect the contents of the view
    // - use `slice` to create smaller views into the same memory
    // - - `slice` can increase the offset
    // - - `slice can decrease the length`
    // - - must specify the output type of `slice`
    // - - `slice` will return a null view if you try to overrun
    // - - make sure to explicitly check for this with `notNull` or `assertType`
    // - use `equal` for typed comparisons.


    // The null view
    bytes29 public constant NULL = hex"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
    uint256 constant LOW_12_MASK = 0xffffffffffffffffffffffff;
    uint8 constant TWELVE_BYTES = 96;

    /**
     * @notice      Returns the encoded hex character that represents the lower 4 bits of the argument.
     * @param _b    The byte
     * @return      char - The encoded hex character
     */
    function nibbleHex(uint8 _b) internal pure returns (uint8 char) {
        // This can probably be done more efficiently, but it's only in error
        // paths, so we don't really care :)
        uint8 _nibble = _b | 0xf0; // set top 4, keep bottom 4
        if (_nibble == 0xf0) {return 0x30;} // 0
        if (_nibble == 0xf1) {return 0x31;} // 1
        if (_nibble == 0xf2) {return 0x32;} // 2
        if (_nibble == 0xf3) {return 0x33;} // 3
        if (_nibble == 0xf4) {return 0x34;} // 4
        if (_nibble == 0xf5) {return 0x35;} // 5
        if (_nibble == 0xf6) {return 0x36;} // 6
        if (_nibble == 0xf7) {return 0x37;} // 7
        if (_nibble == 0xf8) {return 0x38;} // 8
        if (_nibble == 0xf9) {return 0x39;} // 9
        if (_nibble == 0xfa) {return 0x61;} // a
        if (_nibble == 0xfb) {return 0x62;} // b
        if (_nibble == 0xfc) {return 0x63;} // c
        if (_nibble == 0xfd) {return 0x64;} // d
        if (_nibble == 0xfe) {return 0x65;} // e
        if (_nibble == 0xff) {return 0x66;} // f
    }

    /**
     * @notice      Returns a uint16 containing the hex-encoded byte.
     * @param _b    The byte
     * @return      encoded - The hex-encoded byte
     */
    function byteHex(uint8 _b) internal pure returns (uint16 encoded) {
        encoded |= nibbleHex(_b >> 4); // top 4 bits
        encoded <<= 8;
        encoded |= nibbleHex(_b); // lower 4 bits
    }

    /**
     * @notice      Encodes the uint256 to hex. `first` contains the encoded top 16 bytes.
     *              `second` contains the encoded lower 16 bytes.
     *
     * @param _b    The 32 bytes as uint256
     * @return      first - The top 16 bytes
     * @return      second - The bottom 16 bytes
     */
    function encodeHex(uint256 _b) internal pure returns (uint256 first, uint256 second) {
        for (uint8 i = 31; i > 15; i -= 1) {
            uint8 _byte = uint8(_b >> (i * 8));
            first |= byteHex(_byte);
            if (i != 16) {
                first <<= 16;
            }
        }

        // abusing underflow here =_=
        for (uint8 i = 15; i < 255 ; i -= 1) {
            uint8 _byte = uint8(_b >> (i * 8));
            second |= byteHex(_byte);
            if (i != 0) {
                second <<= 16;
            }
        }
    }

    /**
     * @notice          Changes the endianness of a uint256.
     * @dev             https://graphics.stanford.edu/~seander/bithacks.html#ReverseParallel
     * @param _b        The unsigned integer to reverse
     * @return          v - The reversed value
     */
    function reverseUint256(uint256 _b) internal pure returns (uint256 v) {
        v = _b;

        // swap bytes
        v = ((v >> 8) & 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) |
        ((v & 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) << 8);
        // swap 2-byte long pairs
        v = ((v >> 16) & 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) |
        ((v & 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) << 16);
        // swap 4-byte long pairs
        v = ((v >> 32) & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) |
        ((v & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) << 32);
        // swap 8-byte long pairs
        v = ((v >> 64) & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) |
        ((v & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) << 64);
        // swap 16-byte long pairs
        v = (v >> 128) | (v << 128);
    }

    /**
     * @notice      Create a mask with the highest `_len` bits set.
     * @param _len  The length
     * @return      mask - The mask
     */
    function leftMask(uint8 _len) private pure returns (uint256 mask) {
        // ugly. redo without assembly?
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            mask := sar(
            sub(_len, 1),
            0x8000000000000000000000000000000000000000000000000000000000000000
            )
        }
    }

    /**
     * @notice      Return the null view.
     * @return      bytes29 - The null view
     */
    function nullView() internal pure returns (bytes29) {
        return NULL;
    }

    /**
     * @notice      Check if the view is null.
     * @return      bool - True if the view is null
     */
    function isNull(bytes29 memView) internal pure returns (bool) {
        return memView == NULL;
    }

    /**
     * @notice      Check if the view is not null.
     * @return      bool - True if the view is not null
     */
    function notNull(bytes29 memView) internal pure returns (bool) {
        return !isNull(memView);
    }

    /**
     * @notice          Check if the view is of a valid type and points to a valid location
     *                  in memory.
     * @dev             We perform this check by examining solidity's unallocated memory
     *                  pointer and ensuring that the view's upper bound is less than that.
     * @param memView   The view
     * @return          ret - True if the view is valid
     */
    function isValid(bytes29 memView) internal pure returns (bool ret) {
        if (typeOf(memView) == 0xffffffffff) {return false;}
        uint256 _end = end(memView);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            ret := not(gt(_end, mload(0x40)))
        }
    }

    /**
     * @notice          Require that a typed memory view be valid.
     * @dev             Returns the view for easy chaining.
     * @param memView   The view
     * @return          bytes29 - The validated view
     */
    function assertValid(bytes29 memView) internal pure returns (bytes29) {
        require(isValid(memView), "Validity assertion failed");
        return memView;
    }

    /**
     * @notice          Return true if the memview is of the expected type. Otherwise false.
     * @param memView   The view
     * @param _expected The expected type
     * @return          bool - True if the memview is of the expected type
     */
    function isType(bytes29 memView, uint40 _expected) internal pure returns (bool) {
        return typeOf(memView) == _expected;
    }

    /**
     * @notice          Require that a typed memory view has a specific type.
     * @dev             Returns the view for easy chaining.
     * @param memView   The view
     * @param _expected The expected type
     * @return          bytes29 - The view with validated type
     */
    function assertType(bytes29 memView, uint40 _expected) internal pure returns (bytes29) {
        if (!isType(memView, _expected)) {
            (, uint256 g) = encodeHex(uint256(typeOf(memView)));
            (, uint256 e) = encodeHex(uint256(_expected));
            string memory err = string(
                abi.encodePacked(
                    "Type assertion failed. Got 0x",
                    uint80(g),
                    ". Expected 0x",
                    uint80(e)
                )
            );
            revert(err);
        }
        return memView;
    }

    /**
     * @notice          Return an identical view with a different type.
     * @param memView   The view
     * @param _newType  The new type
     * @return          newView - The new view with the specified type
     */
    function castTo(bytes29 memView, uint40 _newType) internal pure returns (bytes29 newView) {
        // then | in the new type
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
        // shift off the top 5 bytes
            newView := or(newView, shr(40, shl(40, memView)))
            newView := or(newView, shl(216, _newType))
        }
    }

    /**
     * @notice          Unsafe raw pointer construction. This should generally not be called
     *                  directly. Prefer `ref` wherever possible.
     * @dev             Unsafe raw pointer construction. This should generally not be called
     *                  directly. Prefer `ref` wherever possible.
     * @param _type     The type
     * @param _loc      The memory address
     * @param _len      The length
     * @return          newView - The new view with the specified type, location and length
     */
    function unsafeBuildUnchecked(uint256 _type, uint256 _loc, uint256 _len) private pure returns (bytes29 newView) {
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            newView := shl(96, or(newView, _type)) // insert type
            newView := shl(96, or(newView, _loc))  // insert loc
            newView := shl(24, or(newView, _len))  // empty bottom 3 bytes
        }
    }

    /**
     * @notice          Instantiate a new memory view. This should generally not be called
     *                  directly. Prefer `ref` wherever possible.
     * @dev             Instantiate a new memory view. This should generally not be called
     *                  directly. Prefer `ref` wherever possible.
     * @param _type     The type
     * @param _loc      The memory address
     * @param _len      The length
     * @return          newView - The new view with the specified type, location and length
     */
    function build(uint256 _type, uint256 _loc, uint256 _len) internal pure returns (bytes29 newView) {
        uint256 _end = _loc.add(_len);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            if gt(_end, mload(0x40)) {
                _end := 0
            }
        }
        if (_end == 0) {
            return NULL;
        }
        newView = unsafeBuildUnchecked(_type, _loc, _len);
    }

    /**
     * @notice          Instantiate a memory view from a byte array.
     * @dev             Note that due to Solidity memory representation, it is not possible to
     *                  implement a deref, as the `bytes` type stores its len in memory.
     * @param arr       The byte array
     * @param newType   The type
     * @return          bytes29 - The memory view
     */
    function ref(bytes memory arr, uint40 newType) internal pure returns (bytes29) {
        uint256 _len = arr.length;

        uint256 _loc;
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            _loc := add(arr, 0x20)  // our view is of the data, not the struct
        }

        return build(newType, _loc, _len);
    }

    /**
     * @notice          Return the associated type information.
     * @param memView   The memory view
     * @return          _type - The type associated with the view
     */
    function typeOf(bytes29 memView) public pure returns (uint40 _type) {
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
        // 216 == 256 - 40
            _type := shr(216, memView) // shift out lower 24 bytes
        }
    }

    /**
     * @notice          Optimized type comparison. Checks that the 5-byte type flag is equal.
     * @param left      The first view
     * @param right     The second view
     * @return          bool - True if the 5-byte type flag is equal
     */
    function sameType(bytes29 left, bytes29 right) internal pure returns (bool) {
        return (left ^ right) >> (2 * TWELVE_BYTES) == 0;
    }

    /**
     * @notice          Return the memory address of the underlying bytes.
     * @param memView   The view
     * @return          _loc - The memory address
     */
    function loc(bytes29 memView) internal pure returns (uint96 _loc) {
        uint256 _mask = LOW_12_MASK;  // assembly can't use globals
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
        // 120 bits = 12 bytes (the encoded loc) + 3 bytes (empty low space)
            _loc := and(shr(120, memView), _mask)
        }
    }

    /**
     * @notice          The number of memory words this memory view occupies, rounded up.
     * @param memView   The view
     * @return          uint256 - The number of memory words
     */
    function words(bytes29 memView) internal pure returns (uint256) {
        return uint256(len(memView)).add(32) / 32;
    }

    /**
     * @notice          The in-memory footprint of a fresh copy of the view.
     * @param memView   The view
     * @return          uint256 - The in-memory footprint of a fresh copy of the view.
     */
    function footprint(bytes29 memView) internal pure returns (uint256) {
        return words(memView) * 32;
    }

    /**
     * @notice          The number of bytes of the view.
     * @param memView   The view
     * @return          _len - The length of the view
     */
    function len(bytes29 memView) internal pure returns (uint96 _len) {
        uint256 _mask = LOW_12_MASK;  // assembly can't use globals
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            _len := and(shr(24, memView), _mask)
        }
    }

    /**
     * @notice          Returns the endpoint of `memView`.
     * @param memView   The view
     * @return          uint256 - The endpoint of `memView`
     */
    function end(bytes29 memView) internal pure returns (uint256) {
        return loc(memView) + len(memView);
    }

    /**
     * @notice          Safe slicing without memory modification.
     * @param memView   The view
     * @param _index    The start index
     * @param _len      The length
     * @param newType   The new type
     * @return          bytes29 - The new view
     */
    function slice(bytes29 memView, uint256 _index, uint256 _len, uint40 newType) internal pure returns (bytes29) {
        uint256 _loc = loc(memView);

        // Ensure it doesn't overrun the view
        if (_loc.add(_index).add(_len) > end(memView)) {
            return NULL;
        }

        _loc = _loc.add(_index);
        return build(newType, _loc, _len);
    }

    /**
     * @notice          Shortcut to `slice`. Gets a view representing the first `_len` bytes.
     * @param memView   The view
     * @param _len      The length
     * @param newType   The new type
     * @return          bytes29 - The new view
     */
    function prefix(bytes29 memView, uint256 _len, uint40 newType) internal pure returns (bytes29) {
        return slice(memView, 0, _len, newType);
    }

    /**
     * @notice          Shortcut to `slice`. Gets a view representing the last `_len` byte.
     * @param memView   The view
     * @param _len      The length
     * @param newType   The new type
     * @return          bytes29 - The new view
     */
    function postfix(bytes29 memView, uint256 _len, uint40 newType) internal pure returns (bytes29) {
        return slice(memView, uint256(len(memView)).sub(_len), _len, newType);
    }

    /**
     * @notice          Construct an error message for an indexing overrun.
     * @param _loc      The memory address
     * @param _len      The length
     * @param _index    The index
     * @param _slice    The slice where the overrun occurred
     * @return          err - The err
     */
    function indexErrOverrun(
        uint256 _loc,
        uint256 _len,
        uint256 _index,
        uint256 _slice
    ) internal pure returns (string memory err) {
        (, uint256 a) = encodeHex(_loc);
        (, uint256 b) = encodeHex(_len);
        (, uint256 c) = encodeHex(_index);
        (, uint256 d) = encodeHex(_slice);
        err = string(
            abi.encodePacked(
                "TypedMemView/index - Overran the view. Slice is at 0x",
                uint48(a),
                " with length 0x",
                uint48(b),
                ". Attempted to index at offset 0x",
                uint48(c),
                " with length 0x",
                uint48(d),
                "."
            )
        );
    }

    /**
     * @notice          Load up to 32 bytes from the view onto the stack.
     * @dev             Returns a bytes32 with only the `_bytes` highest bytes set.
     *                  This can be immediately cast to a smaller fixed-length byte array.
     *                  To automatically cast to an integer, use `indexUint`.
     * @param memView   The view
     * @param _index    The index
     * @param _bytes    The bytes
     * @return          result - The 32 byte result
     */
    function index(bytes29 memView, uint256 _index, uint8 _bytes) internal pure returns (bytes32 result) {
        if (_bytes == 0) {return bytes32(0);}
        if (_index.add(_bytes) > len(memView)) {
            revert(indexErrOverrun(loc(memView), len(memView), _index, uint256(_bytes)));
        }
        require(_bytes <= 32, "TypedMemView/index - Attempted to index more than 32 bytes");

        uint8 bitLength = _bytes * 8;
        uint256 _loc = loc(memView);
        uint256 _mask = leftMask(bitLength);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            result := and(mload(add(_loc, _index)), _mask)
        }
    }

    /**
     * @notice          Parse an unsigned integer from the view at `_index`.
     * @dev             Requires that the view have >= `_bytes` bytes following that index.
     * @param memView   The view
     * @param _index    The index
     * @param _bytes    The bytes
     * @return          result - The unsigned integer
     */
    function indexUint(bytes29 memView, uint256 _index, uint8 _bytes) internal pure returns (uint256 result) {
        return uint256(index(memView, _index, _bytes)) >> ((32 - _bytes) * 8);
    }

    /**
     * @notice          Parse an unsigned integer from LE bytes.
     * @param memView   The view
     * @param _index    The index
     * @param _bytes    The bytes
     * @return          result - The unsigned integer
     */
    function indexLEUint(bytes29 memView, uint256 _index, uint8 _bytes) internal pure returns (uint256 result) {
        return reverseUint256(uint256(index(memView, _index, _bytes)));
    }

    /**
     * @notice          Parse an address from the view at `_index`. Requires that the view have >= 20 bytes
     *                  following that index.
     * @param memView   The view
     * @param _index    The index
     * @return          address - The address
     */
    function indexAddress(bytes29 memView, uint256 _index) internal pure returns (address) {
        return address(uint160(indexUint(memView, _index, 20)));
    }

    /**
     * @notice          Return the keccak256 hash of the underlying memory
     * @param memView   The view
     * @return          digest - The keccak256 hash of the underlying memory
     */
    function keccak(bytes29 memView) internal pure returns (bytes32 digest) {
        uint256 _loc = loc(memView);
        uint256 _len = len(memView);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            digest := keccak256(_loc, _len)
        }
    }

    /**
     * @notice          Return the sha2 digest of the underlying memory.
     * @dev             We explicitly deallocate memory afterwards.
     * @param memView   The view
     * @return          digest - The sha2 hash of the underlying memory
     */
    function sha2(bytes29 memView) internal view returns (bytes32 digest) {
        uint256 _loc = loc(memView);
        uint256 _len = len(memView);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            let ptr := mload(0x40)
            pop(staticcall(gas(), 2, _loc, _len, ptr, 0x20)) // sha2 #1
            digest := mload(ptr)
        }
    }

    /**
     * @notice          Implements bitcoin's hash160 (rmd160(sha2()))
     * @param memView   The pre-image
     * @return          digest - the Digest
     */
    function hash160(bytes29 memView) internal view returns (bytes20 digest) {
        uint256 _loc = loc(memView);
        uint256 _len = len(memView);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            let ptr := mload(0x40)
            pop(staticcall(gas(), 2, _loc, _len, ptr, 0x20)) // sha2
            pop(staticcall(gas(), 3, ptr, 0x20, ptr, 0x20)) // rmd160
            digest := mload(add(ptr, 0xc)) // return value is 0-prefixed.
        }
    }

    /**
     * @notice          Implements bitcoin's hash256 (double sha2)
     * @param memView   A view of the preimage
     * @return          digest - the Digest
     */
    function hash256(bytes29 memView) internal view returns (bytes32 digest) {
        uint256 _loc = loc(memView);
        uint256 _len = len(memView);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            let ptr := mload(0x40)
            pop(staticcall(gas(), 2, _loc, _len, ptr, 0x20)) // sha2 #1
            pop(staticcall(gas(), 2, ptr, 0x20, ptr, 0x20)) // sha2 #2
            digest := mload(ptr)
        }
    }

    /**
     * @notice          Return true if the underlying memory is equal. Else false.
     * @param left      The first view
     * @param right     The second view
     * @return          bool - True if the underlying memory is equal
     */
    function untypedEqual(bytes29 left, bytes29 right) internal pure returns (bool) {
        return (loc(left) == loc(right) && len(left) == len(right)) || keccak(left) == keccak(right);
    }

    /**
     * @notice          Return false if the underlying memory is equal. Else true.
     * @param left      The first view
     * @param right     The second view
     * @return          bool - False if the underlying memory is equal
     */
    function untypedNotEqual(bytes29 left, bytes29 right) internal pure returns (bool) {
        return !untypedEqual(left, right);
    }

    /**
     * @notice          Compares type equality.
     * @dev             Shortcuts if the pointers are identical, otherwise compares type and digest.
     * @param left      The first view
     * @param right     The second view
     * @return          bool - True if the types are the same
     */
    function equal(bytes29 left, bytes29 right) internal pure returns (bool) {
        return left == right || (typeOf(left) == typeOf(right) && keccak(left) == keccak(right));
    }

    /**
     * @notice          Compares type inequality.
     * @dev             Shortcuts if the pointers are identical, otherwise compares type and digest.
     * @param left      The first view
     * @param right     The second view
     * @return          bool - True if the types are not the same
     */
    function notEqual(bytes29 left, bytes29 right) internal pure returns (bool) {
        return !equal(left, right);
    }

    /**
     * @notice          Copy the view to a location, return an unsafe memory reference
     * @dev             Super Dangerous direct memory access.
     *
     *                  This reference can be overwritten if anything else modifies memory (!!!).
     *                  As such it MUST be consumed IMMEDIATELY.
     *                  This function is private to prevent unsafe usage by callers.
     * @param memView   The view
     * @param _newLoc   The new location
     * @return          written - the unsafe memory reference
     */
    function unsafeCopyTo(bytes29 memView, uint256 _newLoc) private view returns (bytes29 written) {
        require(notNull(memView), "TypedMemView/copyTo - Null pointer deref");
        require(isValid(memView), "TypedMemView/copyTo - Invalid pointer deref");
        uint256 _len = len(memView);
        uint256 _oldLoc = loc(memView);

        uint256 ptr;
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            ptr := mload(0x40)
        // revert if we're writing in occupied memory
            if gt(ptr, _newLoc) {
                revert(0x60, 0x20) // empty revert message
            }

        // use the identity precompile to copy
        // guaranteed not to fail, so pop the success
            pop(staticcall(gas(), 4, _oldLoc, _len, _newLoc, _len))
        }

        written = unsafeBuildUnchecked(typeOf(memView), _newLoc, _len);
    }

    /**
     * @notice          Copies the referenced memory to a new loc in memory, returning a `bytes` pointing to
     *                  the new memory
     * @dev             Shortcuts if the pointers are identical, otherwise compares type and digest.
     * @param memView   The view
     * @return          ret - The view pointing to the new memory
     */
    function clone(bytes29 memView) internal view returns (bytes memory ret) {
        uint256 ptr;
        uint256 _len = len(memView);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            ptr := mload(0x40) // load unused memory pointer
            ret := ptr
        }
        unsafeCopyTo(memView, ptr + 0x20);
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            mstore(0x40, add(add(ptr, _len), 0x20)) // write new unused pointer
            mstore(ptr, _len) // write len of new array (in bytes)
        }
    }

    /**
     * @notice          Join the views in memory, return an unsafe reference to the memory.
     * @dev             Super Dangerous direct memory access.
     *
     *                  This reference can be overwritten if anything else modifies memory (!!!).
     *                  As such it MUST be consumed IMMEDIATELY.
     *                  This function is private to prevent unsafe usage by callers.
     * @param memViews  The views
     * @return          unsafeView - The conjoined view pointing to the new memory
     */
    function unsafeJoin(bytes29[] memory memViews, uint256 _location) private view returns (bytes29 unsafeView) {
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            let ptr := mload(0x40)
        // revert if we're writing in occupied memory
            if gt(ptr, _location) {
                revert(0x60, 0x20) // empty revert message
            }
        }

        uint256 _offset = 0;
        for (uint256 i = 0; i < memViews.length; i ++) {
            bytes29 memView = memViews[i];
            unsafeCopyTo(memView, _location + _offset);
            _offset += len(memView);
        }
        unsafeView = unsafeBuildUnchecked(0, _location, _offset);
    }

    /**
     * @notice          Produce the keccak256 digest of the concatenated contents of multiple views.
     * @param memViews  The views
     * @return          bytes32 - The keccak256 digest
     */
    function joinKeccak(bytes29[] memory memViews) internal view returns (bytes32) {
        uint256 ptr;
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            ptr := mload(0x40) // load unused memory pointer
        }
        return keccak(unsafeJoin(memViews, ptr));
    }

    /**
     * @notice          Produce the sha256 digest of the concatenated contents of multiple views.
     * @param memViews  The views
     * @return          bytes32 - The sha256 digest
     */
    function joinSha2(bytes29[] memory memViews) internal view returns (bytes32) {
        uint256 ptr;
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            ptr := mload(0x40) // load unused memory pointer
        }
        return sha2(unsafeJoin(memViews, ptr));
    }

    /**
     * @notice          copies all views, joins them into a new bytearray.
     * @param memViews  The views
     * @return          ret - The new byte array
     */
    function join(bytes29[] memory memViews) internal view returns (bytes memory ret) {
        uint256 ptr;
        assembly {
        // solium-disable-previous-line security/no-inline-assembly
            ptr := mload(0x40) // load unused memory pointer
        }

        bytes29 _newView = unsafeJoin(memViews, ptr + 0x20);
        uint256 _written = len(_newView);
        uint256 _footprint = footprint(_newView);

        assembly {
        // solium-disable-previous-line security/no-inline-assembly
        // store the legnth
            mstore(ptr, _written)
        // new pointer is old + 0x20 + the footprint of the body
            mstore(0x40, add(add(ptr, _footprint), 0x20))
            ret := ptr
        }
    }
}


// File contracts/token-ping-pong/TokenMessage.sol

//
pragma solidity >=0.6.11;

library TokenMessage {
    using TypedMemView for bytes;
    using TypedMemView for bytes29;

    enum Types {
        Invalid, // 0
        Mint, // 1
        Burn // 1
    }

    // ============ Formatters ============

    /**
     * @notice Given the information needed for a message TypeA
     * (in this example case, the information is just a single number)
     * format a bytes message encoding the information
     * @param _amount The number to be included in the TypeA message
     * @return The encoded bytes message
     */
    function formatTypeMint(uint32 _amount, address _to)
    internal
    pure
    returns (bytes memory)
    {
        return abi.encodePacked(uint8(Types.Mint), _amount, _to);
    }

    function formatTypeBurn(uint32 _amount, address _to)
    internal
    pure
    returns (bytes memory)
    {
        return abi.encodePacked(uint8(Types.Burn), _amount, _to);
    }

    // ============ Identifiers ============

    /**
     * @notice Get the type that the TypedMemView is cast to
     * @param _view The message
     * @return _type The type of the message (one of the enum Types)
     */
    function messageType(bytes29 _view) internal pure returns (Types _type) {
        _type = Types(uint8(_view.typeOf()));
    }

    /**
     * @notice Determine whether the message is a message TypeA
     * @param _view The message
     * @return _isTypeMint True if the message is TypeA
     */
    function isTypeMint(bytes calldata _view)
    internal
    pure
    returns (bool _isTypeMint)
    {
        uint8 tt = uint8(_view[0]);
        _isTypeMint = Types(tt) == Types.Mint;
    }

    function isTypeBurn(bytes calldata _view)
    internal
    pure
    returns (bool _isTypeBurn)
    {
        uint8 tt = uint8(_view[0]);
        _isTypeBurn = Types(tt) == Types.Burn;
    }

    // ============ Getters ============

    /**
     * @notice Parse the amount sent within a Mint message
     * @param _view The message
     * @return _amount The number encoded in the message
     */
    function amount(bytes calldata _view)
    internal
    pure
    returns (uint256 _amount)
    {
        require(
            isTypeMint(_view) || isTypeBurn(_view),
            "MessageTemplate/number: view must be of type A"
        );
        _amount = abi.decode(_view[1:5], (uint32));
    }

    function to(bytes calldata _view) internal pure returns (address _to) {
        require(
            isTypeMint(_view) || isTypeBurn(_view),
            "MessageTemplate/number: view must be of type A"
        );
        _to = abi.decode(_view[6:26], (address));
    }

    //    function isPing(bytes29 _view) internal pure returns (bool) {
    //        return messageType(_view) == Types.Ping;
    //    }
    //
    ////    /**
    ////     * @notice Determine whether the message contains a Pong volley
    ////     * @param _view The message
    ////     * @return True if the volley is Pong
    ////     */
    ////    function matchId(bytes29 _view) internal pure returns (uint32) {
    ////        // At index 1, read 4 bytes as a uint, and cast to a uint32
    ////        return uint32(_view.indexUint(1, 4));
    ////    }
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

/**
 * @title Version0
 * @notice Version getter for contracts
 **/
contract Version0 {
    uint8 public constant VERSION = 0;
}


// File @celo-org/optics-sol/libs/[email protected]

//
pragma solidity >=0.6.11;

library TypeCasts {
    using TypedMemView for bytes;
    using TypedMemView for bytes29;

    function coerceBytes32(string memory _s)
    internal
    pure
    returns (bytes32 _b)
    {
        _b = bytes(_s).ref(0).index(0, uint8(bytes(_s).length));
    }

    // treat it as a null-terminated string of max 32 bytes
    function coerceString(bytes32 _buf)
    internal
    pure
    returns (string memory _newStr)
    {
        uint8 _slen = 0;
        while (_slen < 32 && _buf[_slen] != 0) {
            _slen++;
        }

        // solhint-disable-next-line no-inline-assembly
        assembly {
            _newStr := mload(0x40)
            mstore(0x40, add(_newStr, 0x40)) // may end up with extra
            mstore(_newStr, _slen)
            mstore(add(_newStr, 0x20), _buf)
        }
    }

    // alignment preserving cast
    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

    // alignment preserving cast
    function bytes32ToAddress(bytes32 _buf) internal pure returns (address) {
        return address(uint160(uint256(_buf)));
    }
}


// File @celo-org/optics-sol/libs/[email protected]

//
pragma solidity >=0.6.11;

/**
 * @title Message Library
 * @author Celo Labs Inc.
 * @notice Library for formatted messages used by Home and Replica.
 **/
library Message {
    using TypedMemView for bytes;
    using TypedMemView for bytes29;

    // Number of bytes in formatted message before `body` field
    uint256 internal constant PREFIX_LENGTH = 76;

    /**
     * @notice Returns formatted (packed) message with provided fields
     * @param _originDomain Domain of home chain
     * @param _sender Address of sender as bytes32
     * @param _nonce Destination-specific nonce
     * @param _destinationDomain Domain of destination chain
     * @param _recipient Address of recipient on destination chain as bytes32
     * @param _messageBody Raw bytes of message body
     * @return Formatted message
     **/
    function formatMessage(
        uint32 _originDomain,
        bytes32 _sender,
        uint32 _nonce,
        uint32 _destinationDomain,
        bytes32 _recipient,
        bytes memory _messageBody
    ) internal pure returns (bytes memory) {
        return
        abi.encodePacked(
            _originDomain,
            _sender,
            _nonce,
            _destinationDomain,
            _recipient,
            _messageBody
        );
    }

    /**
     * @notice Returns leaf of formatted message with provided fields.
     * @param _origin Domain of home chain
     * @param _sender Address of sender as bytes32
     * @param _nonce Destination-specific nonce number
     * @param _destination Domain of destination chain
     * @param _recipient Address of recipient on destination chain as bytes32
     * @param _body Raw bytes of message body
     * @return Leaf (hash) of formatted message
     **/
    function messageHash(
        uint32 _origin,
        bytes32 _sender,
        uint32 _nonce,
        uint32 _destination,
        bytes32 _recipient,
        bytes memory _body
    ) internal pure returns (bytes32) {
        return
        keccak256(
            formatMessage(
                _origin,
                _sender,
                _nonce,
                _destination,
                _recipient,
                _body
            )
        );
    }

    /// @notice Returns message's origin field
    function origin(bytes29 _message) internal pure returns (uint32) {
        return uint32(_message.indexUint(0, 4));
    }

    /// @notice Returns message's sender field
    function sender(bytes29 _message) internal pure returns (bytes32) {
        return _message.index(4, 32);
    }

    /// @notice Returns message's nonce field
    function nonce(bytes29 _message) internal pure returns (uint32) {
        return uint32(_message.indexUint(36, 4));
    }

    /// @notice Returns message's destination field
    function destination(bytes29 _message) internal pure returns (uint32) {
        return uint32(_message.indexUint(40, 4));
    }

    /// @notice Returns message's recipient field as bytes32
    function recipient(bytes29 _message) internal pure returns (bytes32) {
        return _message.index(44, 32);
    }

    /// @notice Returns message's recipient field as an address
    function recipientAddress(bytes29 _message)
    internal
    pure
    returns (address)
    {
        return TypeCasts.bytes32ToAddress(recipient(_message));
    }

    /// @notice Returns message's body field as bytes29 (refer to TypedMemView library for details on bytes29 type)
    function body(bytes29 _message) internal pure returns (bytes29) {
        return _message.slice(PREFIX_LENGTH, _message.len() - PREFIX_LENGTH, 0);
    }

    function leaf(bytes29 _message) internal view returns (bytes32) {
        return messageHash(origin(_message), sender(_message), nonce(_message), destination(_message), recipient(_message), TypedMemView.clone(body(_message)));
    }
}


// File @openzeppelin/contracts/cryptography/[email protected]

//

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        return recover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
        require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}


// File @openzeppelin/contracts-upgradeable/utils/[email protected]

//

pragma solidity >=0.6.2 <0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts-upgradeable/proxy/[email protected]

//

// solhint-disable-next-line compiler-version
pragma solidity >=0.4.24 <0.8.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============

// ============ External Imports ============


/**
 * @title Common
 * @author Celo Labs Inc.
 * @notice Shared utilities between Home and Replica.
 */
abstract contract Common is Initializable {
    // ============ Enums ============

    // States:
    //   0 - UnInitialized - before initialize function is called
    //   note: the contract is initialized at deploy time, so it should never be in this state
    //   1 - Active - as long as the contract has not become fraudulent
    //   2 - Failed - after a valid fraud proof has been submitted;
    //   contract will no longer accept updates or new messages
    enum States {
        UnInitialized,
        Active,
        Failed
    }

// ============ Immutable Variables ============

// Domain of chain on which the contract is deployed
uint32 public immutable localDomain;

// ============ Public Variables ============

// Address of bonded Updater
address public updater;
// Current state of contract
States public state;
// The latest root that has been signed by the Updater
bytes32 public committedRoot;

// ============ Upgrade Gap ============

// gap for upgrade safety
uint256[47] private __GAP;

// ============ Events ============

/**
 * @notice Emitted when update is made on Home
 * or unconfirmed update root is submitted on Replica
 * @param homeDomain Domain of home contract
 * @param oldRoot Old merkle root
 * @param newRoot New merkle root
 * @param signature Updater's signature on `oldRoot` and `newRoot`
 */
event Update(
uint32 indexed homeDomain,
bytes32 indexed oldRoot,
bytes32 indexed newRoot,
bytes signature
);

/**
 * @notice Emitted when proof of a double update is submitted,
 * which sets the contract to FAILED state
 * @param oldRoot Old root shared between two conflicting updates
 * @param newRoot Array containing two conflicting new roots
 * @param signature Signature on `oldRoot` and `newRoot`[0]
 * @param signature2 Signature on `oldRoot` and `newRoot`[1]
 */
event DoubleUpdate(
bytes32 oldRoot,
bytes32[2] newRoot,
bytes signature,
bytes signature2
);

// ============ Modifiers ============

/**
 * @notice Ensures that contract state != FAILED when the function is called
 */
modifier notFailed() {
require(state != States.Failed, "failed state");
_;
}

// ============ Constructor ============

constructor(uint32 _localDomain) {
localDomain = _localDomain;
}

// ============ Initializer ============

function __Common_initialize(address _updater) internal initializer {
updater = _updater;
state = States.Active;
}

// ============ External Functions ============

/**
 * @notice Called by external agent. Checks that signatures on two sets of
 * roots are valid and that the new roots conflict with each other. If both
 * cases hold true, the contract is failed and a `DoubleUpdate` event is
 * emitted.
 * @dev When `fail()` is called on Home, updater is slashed.
 * @param _oldRoot Old root shared between two conflicting updates
 * @param _newRoot Array containing two conflicting new roots
 * @param _signature Signature on `_oldRoot` and `_newRoot`[0]
 * @param _signature2 Signature on `_oldRoot` and `_newRoot`[1]
 */
function doubleUpdate(
bytes32 _oldRoot,
bytes32[2] calldata _newRoot,
bytes calldata _signature,
bytes calldata _signature2
) external notFailed {
if (
Common._isUpdaterSignature(_oldRoot, _newRoot[0], _signature) &&
Common._isUpdaterSignature(_oldRoot, _newRoot[1], _signature2) &&
_newRoot[0] != _newRoot[1]
) {
_fail();
emit DoubleUpdate(_oldRoot, _newRoot, _signature, _signature2);
}
}

// ============ Public Functions ============

/**
 * @notice Hash of Home domain concatenated with "OPTICS"
 */
function homeDomainHash() public view virtual returns (bytes32);

// ============ Internal Functions ============

/**
 * @notice Hash of Home domain concatenated with "OPTICS"
 * @param _homeDomain the Home domain to hash
 */
function _homeDomainHash(uint32 _homeDomain)
internal
pure
returns (bytes32)
{
return keccak256(abi.encodePacked(_homeDomain, "OPTICS"));
}

/**
 * @notice Set contract state to FAILED
 * @dev Called when a valid fraud proof is submitted
 */
function _setFailed() internal {
state = States.Failed;
}

/**
 * @notice Moves the contract into failed state
 * @dev Called when fraud is proven
 * (Double Update is submitted on Home or Replica,
 * or Improper Update is submitted on Home)
 */
function _fail() internal virtual;

/**
 * @notice Checks that signature was signed by Updater
 * @param _oldRoot Old merkle root
 * @param _newRoot New merkle root
 * @param _signature Signature on `_oldRoot` and `_newRoot`
 * @return TRUE iff signature is valid signed by updater
 **/
function _isUpdaterSignature(
bytes32 _oldRoot,
bytes32 _newRoot,
bytes memory _signature
) internal view returns (bool) {
bytes32 _digest = keccak256(
abi.encodePacked(homeDomainHash(), _oldRoot, _newRoot)
);
_digest = ECDSA.toEthSignedMessageHash(_digest);
return (ECDSA.recover(_digest, _signature) == updater);
}
}


// File @celo-org/optics-sol/libs/[email protected]

//
pragma solidity >=0.6.11;

/**
 * @title QueueLib
 * @author Celo Labs Inc.
 * @notice Library containing queue struct and operations for queue used by
 * Home and Replica.
 **/
library QueueLib {
/**
 * @notice Queue struct
 * @dev Internally keeps track of the `first` and `last` elements through
 * indices and a mapping of indices to enqueued elements.
 **/
struct Queue {
uint128 first;
uint128 last;
mapping(uint256 => bytes32) queue;
}

/**
 * @notice Initializes the queue
 * @dev Empty state denoted by _q.first > q._last. Queue initialized
 * with _q.first = 1 and _q.last = 0.
 **/
function initialize(Queue storage _q) internal {
if (_q.first == 0) {
_q.first = 1;
}
}

/**
 * @notice Enqueues a single new element
 * @param _item New element to be enqueued
 * @return _last Index of newly enqueued element
 **/
function enqueue(Queue storage _q, bytes32 _item)
internal
returns (uint128 _last)
{
_last = _q.last + 1;
_q.last = _last;
if (_item != bytes32(0)) {
// saves gas if we're queueing 0
_q.queue[_last] = _item;
}
}

/**
 * @notice Dequeues element at front of queue
 * @dev Removes dequeued element from storage
 * @return _item Dequeued element
 **/
function dequeue(Queue storage _q) internal returns (bytes32 _item) {
uint128 _last = _q.last;
uint128 _first = _q.first;
require(_length(_last, _first) != 0, "Empty");
_item = _q.queue[_first];
if (_item != bytes32(0)) {
// saves gas if we're dequeuing 0
delete _q.queue[_first];
}
_q.first = _first + 1;
}

/**
 * @notice Batch enqueues several elements
 * @param _items Array of elements to be enqueued
 * @return _last Index of last enqueued element
 **/
function enqueue(Queue storage _q, bytes32[] memory _items)
internal
returns (uint128 _last)
{
_last = _q.last;
for (uint256 i = 0; i < _items.length; i += 1) {
_last += 1;
bytes32 _item = _items[i];
if (_item != bytes32(0)) {
_q.queue[_last] = _item;
}
}
_q.last = _last;
}

/**
 * @notice Batch dequeues `_number` elements
 * @dev Reverts if `_number` > queue length
 * @param _number Number of elements to dequeue
 * @return Array of dequeued elements
 **/
function dequeue(Queue storage _q, uint256 _number)
internal
returns (bytes32[] memory)
{
uint128 _last = _q.last;
uint128 _first = _q.first;
// Cannot underflow unless state is corrupted
require(_length(_last, _first) >= _number, "Insufficient");

bytes32[] memory _items = new bytes32[](_number);

for (uint256 i = 0; i < _number; i++) {
_items[i] = _q.queue[_first];
delete _q.queue[_first];
_first++;
}
_q.first = _first;
return _items;
}

/**
 * @notice Returns true if `_item` is in the queue and false if otherwise
 * @dev Linearly scans from _q.first to _q.last looking for `_item`
 * @param _item Item being searched for in queue
 * @return True if `_item` currently exists in queue, false if otherwise
 **/
function contains(Queue storage _q, bytes32 _item)
internal
view
returns (bool)
{
for (uint256 i = _q.first; i <= _q.last; i++) {
if (_q.queue[i] == _item) {
return true;
}
}
return false;
}

/// @notice Returns last item in queue
/// @dev Returns bytes32(0) if queue empty
function lastItem(Queue storage _q) internal view returns (bytes32) {
return _q.queue[_q.last];
}

/// @notice Returns element at front of queue without removing element
/// @dev Reverts if queue is empty
function peek(Queue storage _q) internal view returns (bytes32 _item) {
require(!isEmpty(_q), "Empty");
_item = _q.queue[_q.first];
}

/// @notice Returns true if queue is empty and false if otherwise
function isEmpty(Queue storage _q) internal view returns (bool) {
return _q.last < _q.first;
}

/// @notice Returns number of elements in queue
function length(Queue storage _q) internal view returns (uint256) {
uint128 _last = _q.last;
uint128 _first = _q.first;
// Cannot underflow unless state is corrupted
return _length(_last, _first);
}

/// @notice Returns number of elements between `_last` and `_first` (used internally)
function _length(uint128 _last, uint128 _first)
internal
pure
returns (uint256)
{
return uint256(_last + 1 - _first);
}
}


// File @celo-org/optics-sol/libs/[email protected]

//
pragma solidity >=0.6.11;

// work based on eth2 deposit contract, which is used under CC0-1.0

/**
 * @title MerkleLib
 * @author Celo Labs Inc.
 * @notice An incremental merkle tree modeled on the eth2 deposit contract.
 **/
library MerkleLib {
uint256 internal constant TREE_DEPTH = 32;
uint256 internal constant MAX_LEAVES = 2**TREE_DEPTH - 1;

/**
 * @notice Struct representing incremental merkle tree. Contains current
 * branch and the number of inserted leaves in the tree.
 **/
struct Tree {
bytes32[TREE_DEPTH] branch;
uint256 count;
}

/**
 * @notice Inserts `_node` into merkle tree
 * @dev Reverts if tree is full
 * @param _node Element to insert into tree
 **/
function insert(Tree storage _tree, bytes32 _node) internal {
require(_tree.count < MAX_LEAVES, "merkle tree full");

_tree.count += 1;
uint256 size = _tree.count;
for (uint256 i = 0; i < TREE_DEPTH; i++) {
if ((size & 1) == 1) {
_tree.branch[i] = _node;
return;
}
_node = keccak256(abi.encodePacked(_tree.branch[i], _node));
size /= 2;
}
// As the loop should always end prematurely with the `return` statement,
// this code should be unreachable. We assert `false` just to be safe.
assert(false);
}

/**
 * @notice Calculates and returns`_tree`'s current root given array of zero
 * hashes
 * @param _zeroes Array of zero hashes
 * @return _current Calculated root of `_tree`
 **/
function rootWithCtx(Tree storage _tree, bytes32[TREE_DEPTH] memory _zeroes)
internal
view
returns (bytes32 _current)
{
uint256 _index = _tree.count;

for (uint256 i = 0; i < TREE_DEPTH; i++) {
uint256 _ithBit = (_index >> i) & 0x01;
bytes32 _next = _tree.branch[i];
if (_ithBit == 1) {
_current = keccak256(abi.encodePacked(_next, _current));
} else {
_current = keccak256(abi.encodePacked(_current, _zeroes[i]));
}
}
}

/// @notice Calculates and returns`_tree`'s current root
function root(Tree storage _tree) internal view returns (bytes32) {
return rootWithCtx(_tree, zeroHashes());
}

/// @notice Returns array of TREE_DEPTH zero hashes
/// @return _zeroes Array of TREE_DEPTH zero hashes
function zeroHashes()
internal
pure
returns (bytes32[TREE_DEPTH] memory _zeroes)
{
_zeroes[0] = Z_0;
_zeroes[1] = Z_1;
_zeroes[2] = Z_2;
_zeroes[3] = Z_3;
_zeroes[4] = Z_4;
_zeroes[5] = Z_5;
_zeroes[6] = Z_6;
_zeroes[7] = Z_7;
_zeroes[8] = Z_8;
_zeroes[9] = Z_9;
_zeroes[10] = Z_10;
_zeroes[11] = Z_11;
_zeroes[12] = Z_12;
_zeroes[13] = Z_13;
_zeroes[14] = Z_14;
_zeroes[15] = Z_15;
_zeroes[16] = Z_16;
_zeroes[17] = Z_17;
_zeroes[18] = Z_18;
_zeroes[19] = Z_19;
_zeroes[20] = Z_20;
_zeroes[21] = Z_21;
_zeroes[22] = Z_22;
_zeroes[23] = Z_23;
_zeroes[24] = Z_24;
_zeroes[25] = Z_25;
_zeroes[26] = Z_26;
_zeroes[27] = Z_27;
_zeroes[28] = Z_28;
_zeroes[29] = Z_29;
_zeroes[30] = Z_30;
_zeroes[31] = Z_31;
}

/**
 * @notice Calculates and returns the merkle root for the given leaf
 * `_item`, a merkle branch, and the index of `_item` in the tree.
 * @param _item Merkle leaf
 * @param _branch Merkle proof
 * @param _index Index of `_item` in tree
 * @return _current Calculated merkle root
 **/
function branchRoot(
bytes32 _item,
bytes32[TREE_DEPTH] memory _branch,
uint256 _index
) internal pure returns (bytes32 _current) {
_current = _item;

for (uint256 i = 0; i < TREE_DEPTH; i++) {
uint256 _ithBit = (_index >> i) & 0x01;
bytes32 _next = _branch[i];
if (_ithBit == 1) {
_current = keccak256(abi.encodePacked(_next, _current));
} else {
_current = keccak256(abi.encodePacked(_current, _next));
}
}
}

// keccak256 zero hashes
bytes32 internal constant Z_0 =
hex"0000000000000000000000000000000000000000000000000000000000000000";
bytes32 internal constant Z_1 =
hex"ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5";
bytes32 internal constant Z_2 =
hex"b4c11951957c6f8f642c4af61cd6b24640fec6dc7fc607ee8206a99e92410d30";
bytes32 internal constant Z_3 =
hex"21ddb9a356815c3fac1026b6dec5df3124afbadb485c9ba5a3e3398a04b7ba85";
bytes32 internal constant Z_4 =
hex"e58769b32a1beaf1ea27375a44095a0d1fb664ce2dd358e7fcbfb78c26a19344";
bytes32 internal constant Z_5 =
hex"0eb01ebfc9ed27500cd4dfc979272d1f0913cc9f66540d7e8005811109e1cf2d";
bytes32 internal constant Z_6 =
hex"887c22bd8750d34016ac3c66b5ff102dacdd73f6b014e710b51e8022af9a1968";
bytes32 internal constant Z_7 =
hex"ffd70157e48063fc33c97a050f7f640233bf646cc98d9524c6b92bcf3ab56f83";
bytes32 internal constant Z_8 =
hex"9867cc5f7f196b93bae1e27e6320742445d290f2263827498b54fec539f756af";
bytes32 internal constant Z_9 =
hex"cefad4e508c098b9a7e1d8feb19955fb02ba9675585078710969d3440f5054e0";
bytes32 internal constant Z_10 =
hex"f9dc3e7fe016e050eff260334f18a5d4fe391d82092319f5964f2e2eb7c1c3a5";
bytes32 internal constant Z_11 =
hex"f8b13a49e282f609c317a833fb8d976d11517c571d1221a265d25af778ecf892";
bytes32 internal constant Z_12 =
hex"3490c6ceeb450aecdc82e28293031d10c7d73bf85e57bf041a97360aa2c5d99c";
bytes32 internal constant Z_13 =
hex"c1df82d9c4b87413eae2ef048f94b4d3554cea73d92b0f7af96e0271c691e2bb";
bytes32 internal constant Z_14 =
hex"5c67add7c6caf302256adedf7ab114da0acfe870d449a3a489f781d659e8becc";
bytes32 internal constant Z_15 =
hex"da7bce9f4e8618b6bd2f4132ce798cdc7a60e7e1460a7299e3c6342a579626d2";
bytes32 internal constant Z_16 =
hex"2733e50f526ec2fa19a22b31e8ed50f23cd1fdf94c9154ed3a7609a2f1ff981f";
bytes32 internal constant Z_17 =
hex"e1d3b5c807b281e4683cc6d6315cf95b9ade8641defcb32372f1c126e398ef7a";
bytes32 internal constant Z_18 =
hex"5a2dce0a8a7f68bb74560f8f71837c2c2ebbcbf7fffb42ae1896f13f7c7479a0";
bytes32 internal constant Z_19 =
hex"b46a28b6f55540f89444f63de0378e3d121be09e06cc9ded1c20e65876d36aa0";
bytes32 internal constant Z_20 =
hex"c65e9645644786b620e2dd2ad648ddfcbf4a7e5b1a3a4ecfe7f64667a3f0b7e2";
bytes32 internal constant Z_21 =
hex"f4418588ed35a2458cffeb39b93d26f18d2ab13bdce6aee58e7b99359ec2dfd9";
bytes32 internal constant Z_22 =
hex"5a9c16dc00d6ef18b7933a6f8dc65ccb55667138776f7dea101070dc8796e377";
bytes32 internal constant Z_23 =
hex"4df84f40ae0c8229d0d6069e5c8f39a7c299677a09d367fc7b05e3bc380ee652";
bytes32 internal constant Z_24 =
hex"cdc72595f74c7b1043d0e1ffbab734648c838dfb0527d971b602bc216c9619ef";
bytes32 internal constant Z_25 =
hex"0abf5ac974a1ed57f4050aa510dd9c74f508277b39d7973bb2dfccc5eeb0618d";
bytes32 internal constant Z_26 =
hex"b8cd74046ff337f0a7bf2c8e03e10f642c1886798d71806ab1e888d9e5ee87d0";
bytes32 internal constant Z_27 =
hex"838c5655cb21c6cb83313b5a631175dff4963772cce9108188b34ac87c81c41e";
bytes32 internal constant Z_28 =
hex"662ee4dd2dd7b2bc707961b1e646c4047669dcb6584f0d8d770daf5d7e7deb2e";
bytes32 internal constant Z_29 =
hex"388ab20e2573d171a88108e79d820e98f26c0b84aa8b2f4aa4968dbb818ea322";
bytes32 internal constant Z_30 =
hex"93237c50ba75ee485f4c22adf2f741400bdf8d6a9cc7df7ecae576221665d735";
bytes32 internal constant Z_31 =
hex"8448818bb4ae4562849e949e17ac16e0be16688e156b5cf15e098c627c0056a9";
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============

/**
 * @title MerkleTreeManager
 * @author Celo Labs Inc.
 * @notice Contains a Merkle tree instance and
 * exposes view functions for the tree.
 */
contract MerkleTreeManager {
// ============ Libraries ============

using MerkleLib for MerkleLib.Tree;
MerkleLib.Tree public tree;

// ============ Upgrade Gap ============

// gap for upgrade safety
uint256[49] private __GAP;

// ============ Public Functions ============

/**
 * @notice Calculates and returns tree's current root
 */
function root() public view returns (bytes32) {
return tree.root();
}

/**
 * @notice Returns the number of inserted leaves in the tree (current index)
 */
function count() public view returns (uint256) {
return tree.count;
}
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============

// ============ External Imports ============

/**
 * @title QueueManager
 * @author Celo Labs Inc.
 * @notice Contains a queue instance and
 * exposes view functions for the queue.
 **/
contract QueueManager is Initializable {
// ============ Libraries ============

using QueueLib for QueueLib.Queue;
QueueLib.Queue internal queue;

// ============ Upgrade Gap ============

// gap for upgrade safety
uint256[49] private __GAP;

// ============ Initializer ============

function __QueueManager_initialize() internal initializer {
queue.initialize();
}

// ============ Public Functions ============

/**
 * @notice Returns number of elements in queue
 */
function queueLength() external view returns (uint256) {
return queue.length();
}

/**
 * @notice Returns TRUE iff `_item` is in the queue
 */
function queueContains(bytes32 _item) external view returns (bool) {
return queue.contains(_item);
}

/**
 * @notice Returns last item enqueued to the queue
 */
function queueEnd() external view returns (bytes32) {
return queue.lastItem();
}
}


// File @celo-org/optics-sol/interfaces/[email protected]

//
pragma solidity >=0.6.11;

interface IUpdaterManager {
function slashUpdater(address payable _reporter) external;

function updater() external view returns (address);
}


// File @openzeppelin/contracts/utils/[email protected]

//

pragma solidity >=0.6.2 <0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
/**
 * @dev Returns true if `account` is a contract.
 *
 * [IMPORTANT]
 * ====
 * It is unsafe to assume that an address for which this function returns
 * false is an externally-owned account (EOA) and not a contract.
 *
 * Among others, `isContract` will return false for the following
 * types of addresses:
 *
 *  - an externally-owned account
 *  - a contract in construction
 *  - an address where a contract will be created
 *  - an address where a contract lived, but was destroyed
 * ====
 */
function isContract(address account) internal view returns (bool) {
// This method relies on extcodesize, which returns 0 for contracts in
// construction, since the code is only stored at the end of the
// constructor execution.

uint256 size;
// solhint-disable-next-line no-inline-assembly
assembly { size := extcodesize(account) }
return size > 0;
}

/**
 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
 * `recipient`, forwarding all available gas and reverting on errors.
 *
 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
 * of certain opcodes, possibly making contracts go over the 2300 gas limit
 * imposed by `transfer`, making them unable to receive funds via
 * `transfer`. {sendValue} removes this limitation.
 *
 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
 *
 * IMPORTANT: because control is transferred to `recipient`, care must be
 * taken to not create reentrancy vulnerabilities. Consider using
 * {ReentrancyGuard} or the
 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
 */
function sendValue(address payable recipient, uint256 amount) internal {
require(address(this).balance >= amount, "Address: insufficient balance");

// solhint-disable-next-line avoid-low-level-calls, avoid-call-value
(bool success, ) = recipient.call{ value: amount }("");
require(success, "Address: unable to send value, recipient may have reverted");
}

/**
 * @dev Performs a Solidity function call using a low level `call`. A
 * plain`call` is an unsafe replacement for a function call: use this
 * function instead.
 *
 * If `target` reverts with a revert reason, it is bubbled up by this
 * function (like regular Solidity function calls).
 *
 * Returns the raw returned data. To convert to the expected return value,
 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
 *
 * Requirements:
 *
 * - `target` must be a contract.
 * - calling `target` with `data` must not revert.
 *
 * _Available since v3.1._
 */
function functionCall(address target, bytes memory data) internal returns (bytes memory) {
return functionCall(target, data, "Address: low-level call failed");
}

/**
 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
 * `errorMessage` as a fallback revert reason when `target` reverts.
 *
 * _Available since v3.1._
 */
function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
return functionCallWithValue(target, data, 0, errorMessage);
}

/**
 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
 * but also transferring `value` wei to `target`.
 *
 * Requirements:
 *
 * - the calling contract must have an ETH balance of at least `value`.
 * - the called Solidity function must be `payable`.
 *
 * _Available since v3.1._
 */
function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
}

/**
 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
 * with `errorMessage` as a fallback revert reason when `target` reverts.
 *
 * _Available since v3.1._
 */
function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
require(address(this).balance >= value, "Address: insufficient balance for call");
require(isContract(target), "Address: call to non-contract");

// solhint-disable-next-line avoid-low-level-calls
(bool success, bytes memory returndata) = target.call{ value: value }(data);
return _verifyCallResult(success, returndata, errorMessage);
}

/**
 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
 * but performing a static call.
 *
 * _Available since v3.3._
 */
function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
return functionStaticCall(target, data, "Address: low-level static call failed");
}

/**
 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
 * but performing a static call.
 *
 * _Available since v3.3._
 */
function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
require(isContract(target), "Address: static call to non-contract");

// solhint-disable-next-line avoid-low-level-calls
(bool success, bytes memory returndata) = target.staticcall(data);
return _verifyCallResult(success, returndata, errorMessage);
}

/**
 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
 * but performing a delegate call.
 *
 * _Available since v3.4._
 */
function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
return functionDelegateCall(target, data, "Address: low-level delegate call failed");
}

/**
 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
 * but performing a delegate call.
 *
 * _Available since v3.4._
 */
function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
require(isContract(target), "Address: delegate call to non-contract");

// solhint-disable-next-line avoid-low-level-calls
(bool success, bytes memory returndata) = target.delegatecall(data);
return _verifyCallResult(success, returndata, errorMessage);
}

function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
if (success) {
return returndata;
} else {
// Look for revert reason and bubble it up if present
if (returndata.length > 0) {
// The easiest way to bubble the revert reason is using memory via assembly

// solhint-disable-next-line no-inline-assembly
assembly {
let returndata_size := mload(returndata)
revert(add(32, returndata), returndata_size)
}
} else {
revert(errorMessage);
}
}
}
}


// File @openzeppelin/contracts-upgradeable/utils/[email protected]

//

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
function __Context_init() internal initializer {
__Context_init_unchained();
}

function __Context_init_unchained() internal initializer {
}
function _msgSender() internal view virtual returns (address payable) {
return msg.sender;
}

function _msgData() internal view virtual returns (bytes memory) {
this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
return msg.data;
}
uint256[50] private __gap;
}


// File @openzeppelin/contracts-upgradeable/access/[email protected]

//

pragma solidity >=0.6.0 <0.8.0;


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
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
address private _owner;

event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

/**
 * @dev Initializes the contract setting the deployer as the initial owner.
 */
function __Ownable_init() internal initializer {
__Context_init_unchained();
__Ownable_init_unchained();
}

function __Ownable_init_unchained() internal initializer {
address msgSender = _msgSender();
_owner = msgSender;
emit OwnershipTransferred(address(0), msgSender);
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
emit OwnershipTransferred(_owner, address(0));
_owner = address(0);
}

/**
 * @dev Transfers ownership of the contract to a new account (`newOwner`).
 * Can only be called by the current owner.
 */
function transferOwnership(address newOwner) public virtual onlyOwner {
require(newOwner != address(0), "Ownable: new owner is the zero address");
emit OwnershipTransferred(_owner, newOwner);
_owner = newOwner;
}
uint256[49] private __gap;
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============








// ============ External Imports ============


/**
 * @title Home
 * @author Celo Labs Inc.
 * @notice Accepts messages to be dispatched to remote chains,
 * constructs a Merkle tree of the messages,
 * and accepts signatures from a bonded Updater
 * which notarize the Merkle tree roots.
 * Accepts submissions of fraudulent signatures
 * by the Updater and slashes the Updater in this case.
 */
contract Home is
Version0,
QueueManager,
MerkleTreeManager,
Common,
OwnableUpgradeable
{
// ============ Libraries ============

using QueueLib for QueueLib.Queue;
using MerkleLib for MerkleLib.Tree;

// ============ Constants ============

// Maximum bytes per message = 2 KiB
// (somewhat arbitrarily set to begin)
uint256 public constant MAX_MESSAGE_BODY_BYTES = 2 * 2**10;

// ============ Public Storage Variables ============

// domain => next available nonce for the domain
mapping(uint32 => uint32) public nonces;
// contract responsible for Updater bonding, slashing and rotation
IUpdaterManager public updaterManager;

// ============ Upgrade Gap ============

// gap for upgrade safety
uint256[48] private __GAP;

// ============ Events ============

/**
 * @notice Emitted when a new message is dispatched via Optics
 * @param leafIndex Index of message's leaf in merkle tree
 * @param destinationAndNonce Destination and destination-specific
 * nonce combined in single field ((destination << 32) & nonce)
 * @param messageHash Hash of message; the leaf inserted to the Merkle tree for the message
 * @param committedRoot the latest notarized root submitted in the last signed Update
 * @param message Raw bytes of message
 */
event Dispatch(
bytes32 indexed messageHash,
uint256 indexed leafIndex,
uint64 indexed destinationAndNonce,
bytes32 committedRoot,
bytes message
);

/**
 * @notice Emitted when proof of an improper update is submitted,
 * which sets the contract to FAILED state
 * @param oldRoot Old root of the improper update
 * @param newRoot New root of the improper update
 * @param signature Signature on `oldRoot` and `newRoot
 */
event ImproperUpdate(bytes32 oldRoot, bytes32 newRoot, bytes signature);

/**
 * @notice Emitted when the Updater is slashed
 * (should be paired with ImproperUpdater or DoubleUpdate event)
 * @param updater The address of the updater
 * @param reporter The address of the entity that reported the updater misbehavior
 */
event UpdaterSlashed(address indexed updater, address indexed reporter);

/**
 * @notice Emitted when Updater is rotated by the UpdaterManager
 * @param updater The address of the new updater
 */
event NewUpdater(address updater);

/**
 * @notice Emitted when the UpdaterManager contract is changed
 * @param updaterManager The address of the new updaterManager
 */
event NewUpdaterManager(address updaterManager);

// ============ Constructor ============

constructor(uint32 _localDomain) Common(_localDomain) {} // solhint-disable-line no-empty-blocks

// ============ Initializer ============

function initialize(IUpdaterManager _updaterManager) public initializer {
// initialize owner & queue
__Ownable_init();
__QueueManager_initialize();
// set Updater Manager contract and initialize Updater
_setUpdaterManager(_updaterManager);
address _updater = updaterManager.updater();
__Common_initialize(_updater);
emit NewUpdater(_updater);
}

// ============ Modifiers ============

/**
 * @notice Ensures that function is called by the UpdaterManager contract
 */
modifier onlyUpdaterManager() {
require(msg.sender == address(updaterManager), "!updaterManager");
_;
}

// ============ External: Updater & UpdaterManager Configuration  ============

/**
 * @notice Set a new Updater
 * @param _updater the new Updater
 */
function setUpdater(address _updater) external onlyUpdaterManager {
_setUpdater(_updater);
}

/**
 * @notice Set a new UpdaterManager contract
 * @dev Home(s) will initially be initialized using a trusted UpdaterManager contract;
 * we will progressively decentralize by swapping the trusted contract with a new implementation
 * that implements Updater bonding & slashing, and rules for Updater selection & rotation
 * @param _updaterManager the new UpdaterManager contract
 */
function setUpdaterManager(address _updaterManager) external onlyOwner {
_setUpdaterManager(IUpdaterManager(_updaterManager));
}

// ============ External Functions  ============

/**
 * @notice Dispatch the message it to the destination domain & recipient
 * @dev Format the message, insert its hash into Merkle tree,
 * enqueue the new Merkle root, and emit `Dispatch` event with message information.
 * @param _destinationDomain Domain of destination chain
 * @param _recipientAddress Address of recipient on destination chain as bytes32
 * @param _messageBody Raw bytes content of message
 */
function dispatch(
uint32 _destinationDomain,
bytes32 _recipientAddress,
bytes memory _messageBody
) external notFailed {
require(_messageBody.length <= MAX_MESSAGE_BODY_BYTES, "msg too long");
// get the next nonce for the destination domain, then increment it
uint32 _nonce = nonces[_destinationDomain];
nonces[_destinationDomain] = _nonce + 1;
// format the message into packed bytes
bytes memory _message = Message.formatMessage(
localDomain,
bytes32(uint256(uint160(msg.sender))),
_nonce,
_destinationDomain,
_recipientAddress,
_messageBody
);
// insert the hashed message into the Merkle tree
bytes32 _messageHash = keccak256(_message);
tree.insert(_messageHash);
// enqueue the new Merkle root after inserting the message
queue.enqueue(root());
// Emit Dispatch event with message information
// note: leafIndex is count() - 1 since new leaf has already been inserted
emit Dispatch(
_messageHash,
count() - 1,
_destinationAndNonce(_destinationDomain, _nonce),
committedRoot,
_message
);
}

/**
 * @notice Submit a signature from the Updater "notarizing" a root,
 * which updates the Home contract's `committedRoot`,
 * and publishes the signature which will be relayed to Replica contracts
 * @dev emits Update event
 * @dev If _newRoot is not contained in the queue,
 * the Update is a fraudulent Improper Update, so
 * the Updater is slashed & Home is set to FAILED state
 * @param _committedRoot Current updated merkle root which the update is building off of
 * @param _newRoot New merkle root to update the contract state to
 * @param _signature Updater signature on `_committedRoot` and `_newRoot`
 */
function update(
bytes32 _committedRoot,
bytes32 _newRoot,
bytes memory _signature
) external notFailed {
// check that the update is not fraudulent;
// if fraud is detected, Updater is slashed & Home is set to FAILED state
if (improperUpdate(_committedRoot, _newRoot, _signature)) return;
// clear all of the intermediate roots contained in this update from the queue
while (true) {
bytes32 _next = queue.dequeue();
if (_next == _newRoot) break;
}
// update the Home state with the latest signed root & emit event
committedRoot = _newRoot;
emit Update(localDomain, _committedRoot, _newRoot, _signature);
}

/**
 * @notice Suggest an update for the Updater to sign and submit.
 * @dev If queue is empty, null bytes returned for both
 * (No update is necessary because no messages have been dispatched since the last update)
 * @return _committedRoot Latest root signed by the Updater
 * @return _new Latest enqueued Merkle root
 */
function suggestUpdate()
external
view
returns (bytes32 _committedRoot, bytes32 _new)
{
if (queue.length() != 0) {
_committedRoot = committedRoot;
_new = queue.lastItem();
}
}

// ============ Public Functions  ============

/**
 * @notice Hash of Home domain concatenated with "OPTICS"
 */
function homeDomainHash() public view override returns (bytes32) {
return _homeDomainHash(localDomain);
}

/**
 * @notice Check if an Update is an Improper Update;
 * if so, slash the Updater and set the contract to FAILED state.
 *
 * An Improper Update is an update building off of the Home's `committedRoot`
 * for which the `_newRoot` does not currently exist in the Home's queue.
 * This would mean that message(s) that were not truly
 * dispatched on Home were falsely included in the signed root.
 *
 * An Improper Update will only be accepted as valid by the Replica
 * If an Improper Update is attempted on Home,
 * the Updater will be slashed immediately.
 * If an Improper Update is submitted to the Replica,
 * it should be relayed to the Home contract using this function
 * in order to slash the Updater with an Improper Update.
 *
 * An Improper Update submitted to the Replica is only valid
 * while the `_oldRoot` is still equal to the `committedRoot` on Home;
 * if the `committedRoot` on Home has already been updated with a valid Update,
 * then the Updater should be slashed with a Double Update.
 * @dev Reverts (and doesn't slash updater) if signature is invalid or
 * update not current
 * @param _oldRoot Old merkle tree root (should equal home's committedRoot)
 * @param _newRoot New merkle tree root
 * @param _signature Updater signature on `_oldRoot` and `_newRoot`
 * @return TRUE if update was an Improper Update (implying Updater was slashed)
 */
function improperUpdate(
bytes32 _oldRoot,
bytes32 _newRoot,
bytes memory _signature
) public notFailed returns (bool) {
require(
_isUpdaterSignature(_oldRoot, _newRoot, _signature),
"!updater sig"
);
require(_oldRoot == committedRoot, "not a current update");
// if the _newRoot is not currently contained in the queue,
// slash the Updater and set the contract to FAILED state
if (!queue.contains(_newRoot)) {
_fail();
emit ImproperUpdate(_oldRoot, _newRoot, _signature);
return true;
}
// if the _newRoot is contained in the queue,
// this is not an improper update
return false;
}

// ============ Internal Functions  ============

/**
 * @notice Set the UpdaterManager
 * @param _updaterManager Address of the UpdaterManager
 */
function _setUpdaterManager(IUpdaterManager _updaterManager) internal {
require(
Address.isContract(address(_updaterManager)),
"!contract updaterManager"
);
updaterManager = IUpdaterManager(_updaterManager);
emit NewUpdaterManager(address(_updaterManager));
}

/**
 * @notice Set the Updater
 * @param _updater Address of the Updater
 */
function _setUpdater(address _updater) internal {
updater = _updater;
emit NewUpdater(_updater);
}

/**
 * @notice Slash the Updater and set contract state to FAILED
 * @dev Called when fraud is proven (Improper Update or Double Update)
 */
function _fail() internal override {
// set contract to FAILED
_setFailed();
// slash Updater
updaterManager.slashUpdater(msg.sender);
emit UpdaterSlashed(updater, msg.sender);
}

/**
 * @notice Internal utility function that combines
 * `_destination` and `_nonce`.
 * @dev Both destination and nonce should be less than 2^32 - 1
 * @param _destination Domain of destination chain
 * @param _nonce Current nonce for given destination chain
 * @return Returns (`_destination` << 32) & `_nonce`
 */
function _destinationAndNonce(uint32 _destination, uint32 _nonce)
internal
pure
returns (uint64)
{
return (uint64(_destination) << 32) | _nonce;
}
}


// File @celo-org/optics-sol/interfaces/[email protected]

//
pragma solidity >=0.6.11;

interface IMessageRecipient {
function handle(
uint32 _origin,
bytes32 _sender,
bytes memory _message
) external;
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============





// ============ External Imports ============

/**
 * @title Replica
 * @author Celo Labs Inc.
 * @notice Track root updates on Home,
 * prove and dispatch messages to end recipients.
 */
contract Replica is Version0, Common {
// ============ Libraries ============

using MerkleLib for MerkleLib.Tree;
using TypedMemView for bytes;
using TypedMemView for bytes29;
using Message for bytes29;

// ============ Enums ============

// Status of Message:
//   0 - None - message has not been proven or processed
//   1 - Proven - message inclusion proof has been validated
//   2 - Processed - message has been dispatched to recipient
enum MessageStatus {
None,
Proven,
Processed
}

// ============ Immutables ============

// Minimum gas for message processing
uint256 public immutable PROCESS_GAS;
// Reserved gas (to ensure tx completes in case message processing runs out)
uint256 public immutable RESERVE_GAS;

// ============ Public Storage ============

// Domain of home chain
uint32 public remoteDomain;
// Number of seconds to wait before root becomes confirmable
uint256 public optimisticSeconds;
// re-entrancy guard
uint8 private entered;
// Mapping of roots to allowable confirmation times
mapping(bytes32 => uint256) public confirmAt;
// Mapping of message leaves to MessageStatus
mapping(bytes32 => MessageStatus) public messages;

// ============ Upgrade Gap ============

// gap for upgrade safety
uint256[44] private __GAP;

// ============ Events ============

/**
 * @notice Emitted when message is processed
 * @param messageHash Hash of message that failed to process
 * @param success TRUE if the call was executed successfully, FALSE if the call reverted
 * @param returnData the return data from the external call
 */
event Process(
bytes32 indexed messageHash,
bool indexed success,
bytes indexed returnData
);

// ============ Constructor ============

// solhint-disable-next-line no-empty-blocks
constructor(
uint32 _localDomain,
uint256 _processGas,
uint256 _reserveGas
) Common(_localDomain) {
require(_processGas >= 850_000, "!process gas");
require(_reserveGas >= 15_000, "!reserve gas");
PROCESS_GAS = _processGas;
RESERVE_GAS = _reserveGas;
}

// ============ Initializer ============

function initialize(
uint32 _remoteDomain,
address _updater,
bytes32 _committedRoot,
uint256 _optimisticSeconds
) public initializer {
__Common_initialize(_updater);
entered = 1;
remoteDomain = _remoteDomain;
committedRoot = _committedRoot;
confirmAt[_committedRoot] = 1;
optimisticSeconds = _optimisticSeconds;
}

// ============ External Functions ============

/**
 * @notice Called by external agent. Submits the signed update's new root,
 * marks root's allowable confirmation time, and emits an `Update` event.
 * @dev Reverts if update doesn't build off latest committedRoot
 * or if signature is invalid.
 * @param _oldRoot Old merkle root
 * @param _newRoot New merkle root
 * @param _signature Updater's signature on `_oldRoot` and `_newRoot`
 */
function update(
bytes32 _oldRoot,
bytes32 _newRoot,
bytes memory _signature
) external notFailed {
// ensure that update is building off the last submitted root
require(_oldRoot == committedRoot, "not current update");
// validate updater signature
require(
_isUpdaterSignature(_oldRoot, _newRoot, _signature),
"!updater sig"
);
// Hook for future use
_beforeUpdate();
// set the new root's confirmation timer
confirmAt[_newRoot] = block.timestamp + optimisticSeconds;
// update committedRoot
committedRoot = _newRoot;
emit Update(remoteDomain, _oldRoot, _newRoot, _signature);
}

/**
 * @notice First attempts to prove the validity of provided formatted
 * `message`. If the message is successfully proven, then tries to process
 * message.
 * @dev Reverts if `prove` call returns false
 * @param _message Formatted message (refer to Common.sol Message library)
 * @param _proof Merkle proof of inclusion for message's leaf
 * @param _index Index of leaf in home's merkle tree
 */
function proveAndProcess(
bytes memory _message,
bytes32[32] calldata _proof,
uint256 _index
) external {
require(prove(keccak256(_message), _proof, _index), "!prove");
process(_message);
}

/**
 * @notice Given formatted message, attempts to dispatch
 * message payload to end recipient.
 * @dev Recipient must implement a `handle` method (refer to IMessageRecipient.sol)
 * Reverts if formatted message's destination domain is not the Replica's domain,
 * if message has not been proven,
 * or if not enough gas is provided for the dispatch transaction.
 * @param _message Formatted message
 * @return _success TRUE iff dispatch transaction succeeded
 */
function process(bytes memory _message) public returns (bool _success) {
bytes29 _m = _message.ref(0);
// ensure message was meant for this domain
require(_m.destination() == localDomain, "!destination");
// ensure message has been proven
bytes32 _messageHash = _m.keccak();
require(messages[_messageHash] == MessageStatus.Proven, "!proven");
// check re-entrancy guard
require(entered == 1, "!reentrant");
entered = 0;
// update message status as processed
messages[_messageHash] = MessageStatus.Processed;
// A call running out of gas TYPICALLY errors the whole tx. We want to
// a) ensure the call has a sufficient amount of gas to make a
//    meaningful state change.
// b) ensure that if the subcall runs out of gas, that the tx as a whole
//    does not revert (i.e. we still mark the message processed)
// To do this, we require that we have enough gas to process
// and still return. We then delegate only the minimum processing gas.
require(gasleft() >= PROCESS_GAS + RESERVE_GAS, "!gas");
// get the message recipient
address _recipient = _m.recipientAddress();
// set up for assembly call
uint256 _toCopy;
uint256 _maxCopy = 256;
uint256 _gas = PROCESS_GAS;
// allocate memory for returndata
bytes memory _returnData = new bytes(_maxCopy);
bytes memory _calldata = abi.encodeWithSignature(
"handle(uint32,bytes32,bytes)",
_m.origin(),
_m.sender(),
_m.body().clone()
);
// dispatch message to recipient
// by assembly calling "handle" function
// we call via assembly to avoid memcopying a very large returndata
// returned by a malicious contract
assembly {
_success := call(
_gas, // gas
_recipient, // recipient
0, // ether value
add(_calldata, 0x20), // inloc
mload(_calldata), // inlen
0, // outloc
0 // outlen
)
// limit our copy to 256 bytes
_toCopy := returndatasize()
if gt(_toCopy, _maxCopy) {
_toCopy := _maxCopy
}
// Store the length of the copied bytes
mstore(_returnData, _toCopy)
// copy the bytes from returndata[0:_toCopy]
returndatacopy(add(_returnData, 0x20), 0, _toCopy)
}
// emit process results
emit Process(_messageHash, _success, _returnData);
// reset re-entrancy guard
entered = 1;
}

// ============ Public Functions ============

/**
 * @notice Check that the root has been submitted
 * and that the optimistic timeout period has expired,
 * meaning the root can be processed
 * @param _root the Merkle root, submitted in an update, to check
 * @return TRUE iff root has been submitted & timeout has expired
 */
function acceptableRoot(bytes32 _root) public view returns (bool) {
uint256 _time = confirmAt[_root];
if (_time == 0) {
return false;
}
return block.timestamp >= _time;
}

/**
 * @notice Attempts to prove the validity of message given its leaf, the
 * merkle proof of inclusion for the leaf, and the index of the leaf.
 * @dev Reverts if message's MessageStatus != None (i.e. if message was
 * already proven or processed)
 * @dev For convenience, we allow proving against any previous root.
 * This means that witnesses never need to be updated for the new root
 * @param _leaf Leaf of message to prove
 * @param _proof Merkle proof of inclusion for leaf
 * @param _index Index of leaf in home's merkle tree
 * @return Returns true if proof was valid and `prove` call succeeded
 **/
function prove(
bytes32 _leaf,
bytes32[32] calldata _proof,
uint256 _index
) public returns (bool) {
// ensure that message has not been proven or processed
require(messages[_leaf] == MessageStatus.None, "!MessageStatus.None");
// calculate the expected root based on the proof
bytes32 _calculatedRoot = MerkleLib.branchRoot(_leaf, _proof, _index);
// if the root is valid, change status to Proven
if (acceptableRoot(_calculatedRoot)) {
messages[_leaf] = MessageStatus.Proven;
return true;
}
return false;
}

/**
 * @notice Hash of Home domain concatenated with "OPTICS"
 */
function homeDomainHash() public view override returns (bytes32) {
return _homeDomainHash(remoteDomain);
}

// ============ Internal Functions ============

/**
 * @notice Moves the contract into failed state
 * @dev Called when a Double Update is submitted
 */
function _fail() internal override {
_setFailed();
}

/// @notice Hook for potential future use
// solhint-disable-next-line no-empty-blocks
function _beforeUpdate() internal {}
}


// File @openzeppelin/contracts/utils/[email protected]

//

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
function _msgSender() internal view virtual returns (address payable) {
return msg.sender;
}

function _msgData() internal view virtual returns (bytes memory) {
this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
return msg.data;
}
}


// File @openzeppelin/contracts/access/[email protected]

//

pragma solidity >=0.6.0 <0.8.0;

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
constructor () {
address msgSender = _msgSender();
_owner = msgSender;
emit OwnershipTransferred(address(0), msgSender);
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
emit OwnershipTransferred(_owner, address(0));
_owner = address(0);
}

/**
 * @dev Transfers ownership of the contract to a new account (`newOwner`).
 * Can only be called by the current owner.
 */
function transferOwnership(address newOwner) public virtual onlyOwner {
require(newOwner != address(0), "Ownable: new owner is the zero address");
emit OwnershipTransferred(_owner, newOwner);
_owner = newOwner;
}
}


// File @celo-org/optics-sol/contracts/[email protected]

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============



// ============ External Imports ============


/**
 * @title XAppConnectionManager
 * @author Celo Labs Inc.
 * @notice Manages a registry of local Replica contracts
 * for remote Home domains. Accepts Watcher signatures
 * to un-enroll Replicas attached to fraudulent remote Homes
 */
contract XAppConnectionManager is Ownable {
// ============ Public Storage ============

// Home contract
Home public home;
// local Replica address => remote Home domain
mapping(address => uint32) public replicaToDomain;
// remote Home domain => local Replica address
mapping(uint32 => address) public domainToReplica;
// watcher address => replica remote domain => has/doesn't have permission
mapping(address => mapping(uint32 => bool)) private watcherPermissions;

// ============ Events ============

/**
 * @notice Emitted when a new Replica is enrolled / added
 * @param domain the remote domain of the Home contract for the Replica
 * @param replica the address of the Replica
 */
event ReplicaEnrolled(uint32 indexed domain, address replica);

/**
 * @notice Emitted when a new Replica is un-enrolled / removed
 * @param domain the remote domain of the Home contract for the Replica
 * @param replica the address of the Replica
 */
event ReplicaUnenrolled(uint32 indexed domain, address replica);

/**
 * @notice Emitted when Watcher permissions are changed
 * @param domain the remote domain of the Home contract for the Replica
 * @param watcher the address of the Watcher
 * @param access TRUE if the Watcher was given permissions, FALSE if permissions were removed
 */
event WatcherPermissionSet(
uint32 indexed domain,
address watcher,
bool access
);

// ============ Modifiers ============

modifier onlyReplica() {
require(isReplica(msg.sender), "!replica");
_;
}

// ============ Constructor ============

// solhint-disable-next-line no-empty-blocks
constructor() Ownable() {}

// ============ External Functions ============

/**
 * @notice Un-Enroll a replica contract
 * in the case that fraud was detected on the Home
 * @dev in the future, if fraud occurs on the Home contract,
 * the Watcher will submit their signature directly to the Home
 * and it can be relayed to all remote chains to un-enroll the Replicas
 * @param _domain the remote domain of the Home contract for the Replica
 * @param _updater the address of the Updater for the Home contract (also stored on Replica)
 * @param _signature signature of watcher on (domain, replica address, updater address)
 */
function unenrollReplica(
uint32 _domain,
bytes32 _updater,
bytes memory _signature
) external {
// ensure that the replica is currently set
address _replica = domainToReplica[_domain];
require(_replica != address(0), "!replica exists");
// ensure that the signature is on the proper updater
require(
Replica(_replica).updater() == TypeCasts.bytes32ToAddress(_updater),
"!current updater"
);
// get the watcher address from the signature
// and ensure that the watcher has permission to un-enroll this replica
address _watcher = _recoverWatcherFromSig(
_domain,
TypeCasts.addressToBytes32(_replica),
_updater,
_signature
);
require(watcherPermissions[_watcher][_domain], "!valid watcher");
// remove the replica from mappings
_unenrollReplica(_replica);
}

/**
 * @notice Set the address of the local Home contract
 * @param _home the address of the local Home contract
 */
function setHome(address _home) external onlyOwner {
home = Home(_home);
}

/**
 * @notice Allow Owner to enroll Replica contract
 * @param _replica the address of the Replica
 * @param _domain the remote domain of the Home contract for the Replica
 */
function ownerEnrollReplica(address _replica, uint32 _domain)
external
onlyOwner
{
// un-enroll any existing replica
_unenrollReplica(_replica);
// add replica and domain to two-way mapping
replicaToDomain[_replica] = _domain;
domainToReplica[_domain] = _replica;
emit ReplicaEnrolled(_domain, _replica);
}

/**
 * @notice Allow Owner to un-enroll Replica contract
 * @param _replica the address of the Replica
 */
function ownerUnenrollReplica(address _replica) external onlyOwner {
_unenrollReplica(_replica);
}

/**
 * @notice Allow Owner to set Watcher permissions for a Replica
 * @param _watcher the address of the Watcher
 * @param _domain the remote domain of the Home contract for the Replica
 * @param _access TRUE to give the Watcher permissions, FALSE to remove permissions
 */
function setWatcherPermission(
address _watcher,
uint32 _domain,
bool _access
) external onlyOwner {
watcherPermissions[_watcher][_domain] = _access;
emit WatcherPermissionSet(_domain, _watcher, _access);
}

/**
 * @notice Query local domain from Home
 * @return local domain
 */
function localDomain() external view returns (uint32) {
return home.localDomain();
}

/**
 * @notice Get access permissions for the watcher on the domain
 * @param _watcher the address of the watcher
 * @param _domain the domain to check for watcher permissions
 * @return TRUE iff _watcher has permission to un-enroll replicas on _domain
 */
function watcherPermission(address _watcher, uint32 _domain)
external
view
returns (bool)
{
return watcherPermissions[_watcher][_domain];
}

// ============ Public Functions ============

/**
 * @notice Check whether _replica is enrolled
 * @param _replica the replica to check for enrollment
 * @return TRUE iff _replica is enrolled
 */
function isReplica(address _replica) public view returns (bool) {
return replicaToDomain[_replica] != 0;
}

// ============ Internal Functions ============

/**
 * @notice Remove the replica from the two-way mappings
 * @param _replica replica to un-enroll
 */
function _unenrollReplica(address _replica) internal {
uint32 _currentDomain = replicaToDomain[_replica];
domainToReplica[_currentDomain] = address(0);
replicaToDomain[_replica] = 0;
emit ReplicaUnenrolled(_currentDomain, _replica);
}

/**
 * @notice Get the Watcher address from the provided signature
 * @return address of watcher that signed
 */
function _recoverWatcherFromSig(
uint32 _domain,
bytes32 _replica,
bytes32 _updater,
bytes memory _signature
) internal view returns (address) {
bytes32 _homeDomainHash = Replica(TypeCasts.bytes32ToAddress(_replica))
.homeDomainHash();
bytes32 _digest = keccak256(
abi.encodePacked(_homeDomainHash, _domain, _updater)
);
_digest = ECDSA.toEthSignedMessageHash(_digest);
return ECDSA.recover(_digest, _signature);
}
}


// File contracts/XAppConnectionClient.sol

//
pragma solidity >=0.6.11;

// ============ External Imports ============



abstract contract XAppConnectionClient is OwnableUpgradeable {
// ============ Mutable Storage ============

XAppConnectionManager public xAppConnectionManager;
uint256[49] private __GAP; // gap for upgrade safety

// ============ Modifiers ============

/**
 * @notice Only accept messages from an Optics Replica contract
 */
modifier onlyReplica() {
require(_isReplica(msg.sender), "!replica");
_;
}

// ======== Initializer =========

function __XAppConnectionClient_initialize(address _xAppConnectionManager)
internal
initializer
{
xAppConnectionManager = XAppConnectionManager(_xAppConnectionManager);
__Ownable_init();
}

// ============ External functions ============

/**
 * @notice Modify the contract the xApp uses to validate Replica contracts
 * @param _xAppConnectionManager The address of the xAppConnectionManager contract
 */
function setXAppConnectionManager(address _xAppConnectionManager)
external
onlyOwner
{
xAppConnectionManager = XAppConnectionManager(_xAppConnectionManager);
}

// ============ Internal functions ============

/**
 * @notice Get the local Home contract from the xAppConnectionManager
 * @return The local Home contract
 */
function _home() internal view returns (Home) {
return xAppConnectionManager.home();
}

/**
 * @notice Determine whether _potentialReplcia is an enrolled Replica from the xAppConnectionManager
 * @return True if _potentialReplica is an enrolled Replica
 */
function _isReplica(address _potentialReplica)
internal
view
returns (bool)
{
return xAppConnectionManager.isReplica(_potentialReplica);
}

/**
 * @notice Get the local domain from the xAppConnectionManager
 * @return The local domain
 */
function _localDomain() internal view virtual returns (uint32) {
return xAppConnectionManager.localDomain();
}
}


// File contracts/Router.sol

//
pragma solidity >=0.6.11;

// ============ Internal Imports ============

// ============ External Imports ============

abstract contract Router is XAppConnectionClient, IMessageRecipient {
// ============ Mutable Storage ============

mapping(uint32 => bytes32) public remotes;
uint256[49] private __GAP; // gap for upgrade safety

// ============ Modifiers ============

/**
 * @notice Only accept messages from a remote Router contract
 * @param _origin The domain the message is coming from
 * @param _router The address the message is coming from
 */
modifier onlyRemoteRouter(uint32 _origin, bytes32 _router) {
require(_isRemoteRouter(_origin, _router), "!remote router");
_;
}

// ============ External functions ============

/**
 * @notice Register the address of a Router contract for the same xApp on a remote chain
 * @param _domain The domain of the remote xApp Router
 * @param _router The address of the remote xApp Router
 */
function enrollRemoteRouter(uint32 _domain, bytes32 _router)
external
onlyOwner
{
remotes[_domain] = _router;
}

// ============ Virtual functions ============

function handle(
uint32 _origin,
bytes32 _sender,
bytes memory _message
) external virtual override;

// ============ Internal functions ============
/**
 * @notice Return true if the given domain / router is the address of a remote xApp Router
 * @param _domain The domain of the potential remote xApp Router
 * @param _router The address of the potential remote xApp Router
 */
function _isRemoteRouter(uint32 _domain, bytes32 _router)
internal
view
returns (bool)
{
return remotes[_domain] == _router;
}

/**
 * @notice Assert that the given domain has a xApp Router registered and return its address
 * @param _domain The domain of the chain for which to get the xApp Router
 * @return _remote The address of the remote xApp Router on _domain
 */
function _mustHaveRemote(uint32 _domain)
internal
view
returns (bytes32 _remote)
{
_remote = remotes[_domain];
require(_remote != bytes32(0), "!remote");
}
}


// File @openzeppelin/contracts/token/ERC20/[email protected]

//

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
/**
 * @dev Returns the amount of tokens in existence.
 */
function totalSupply() external view returns (uint256);

/**
 * @dev Returns the amount of tokens owned by `account`.
 */
function balanceOf(address account) external view returns (uint256);

/**
 * @dev Moves `amount` tokens from the caller's account to `recipient`.
 *
 * Returns a boolean value indicating whether the operation succeeded.
 *
 * Emits a {Transfer} event.
 */
function transfer(address recipient, uint256 amount) external returns (bool);

/**
 * @dev Returns the remaining number of tokens that `spender` will be
 * allowed to spend on behalf of `owner` through {transferFrom}. This is
 * zero by default.
 *
 * This value changes when {approve} or {transferFrom} are called.
 */
function allowance(address owner, address spender) external view returns (uint256);

/**
 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
 *
 * Returns a boolean value indicating whether the operation succeeded.
 *
 * IMPORTANT: Beware that changing an allowance with this method brings the risk
 * that someone may use both the old and the new allowance by unfortunate
 * transaction ordering. One possible solution to mitigate this race
 * condition is to first reduce the spender's allowance to 0 and set the
 * desired value afterwards:
 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
 *
 * Emits an {Approval} event.
 */
function approve(address spender, uint256 amount) external returns (bool);

/**
 * @dev Moves `amount` tokens from `sender` to `recipient` using the
 * allowance mechanism. `amount` is then deducted from the caller's
 * allowance.
 *
 * Returns a boolean value indicating whether the operation succeeded.
 *
 * Emits a {Transfer} event.
 */
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

/**
 * @dev Emitted when `value` tokens are moved from one account (`from`) to
 * another (`to`).
 *
 * Note that `value` may be zero.
 */
event Transfer(address indexed from, address indexed to, uint256 value);

/**
 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
 * a call to {approve}. `value` is the new allowance.
 */
event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File @openzeppelin/contracts/math/[email protected]

//



// File contracts/token-ping-pong/ERC20.sol

//

pragma solidity >=0.6.0 <0.8.0;

// This is modified from "@openzeppelin/contracts/token/ERC20/IERC20.sol"
// Modifications were made to make the tokenName, tokenSymbol, and
// tokenDecimals fields internal instead of private. Getters for them were
// removed to silence solidity inheritance issues


/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is IERC20 {
using SafeMath for uint256;

mapping(address => uint256) private balances;

mapping(address => mapping(address => uint256)) private allowances;

uint256 private supply;

struct Token {
string name;
string symbol;
uint8 decimals;
}

Token internal token;

function mint(address _recepient, uint256 _amount) public {
_mint(_recepient, _amount);
}

function burn(address _recepient, uint256 _amount) public {
_burn(_recepient, _amount);
}

/**
 * @dev See {IERC20-transfer}.
 *
 * Requirements:
 *
 * - `_recipient` cannot be the zero address.
 * - the caller must have a balance of at least `_amount`.
 */
function transfer(address _recipient, uint256 _amount)
public
virtual
override
returns (bool)
{
_transfer(msg.sender, _recipient, _amount);
return true;
}

/**
 * @dev See {IERC20-approve}.
 *
 * Requirements:
 *
 * - `_spender` cannot be the zero address.
 */
function approve(address _spender, uint256 _amount)
public
virtual
override
returns (bool)
{
_approve(msg.sender, _spender, _amount);
return true;
}

/**
 * @dev See {IERC20-transferFrom}.
 *
 * Emits an {Approval} event indicating the updated allowance. This is not
 * required by the EIP. See the note at the beginning of {ERC20}.
 *
 * Requirements:
 *
 * - `_sender` and `recipient` cannot be the zero address.
 * - `_sender` must have a balance of at least `amount`.
 * - the caller must have allowance for ``_sender``'s tokens of at least
 * `amount`.
 */
function transferFrom(
address _sender,
address _recipient,
uint256 _amount
) public virtual override returns (bool) {
_transfer(_sender, _recipient, _amount);
_approve(
_sender,
msg.sender,
allowances[_sender][msg.sender].sub(
_amount,
"ERC20: transfer amount exceeds allowance"
)
);
return true;
}

/**
 * @dev Atomically increases the allowance granted to `spender` by the caller.
 *
 * This is an alternative to {approve} that can be used as a mitigation for
 * problems described in {IERC20-approve}.
 *
 * Emits an {Approval} event indicating the updated allowance.
 *
 * Requirements:
 *
 * - `_spender` cannot be the zero address.
 */
function increaseAllowance(address _spender, uint256 _addedValue)
public
virtual
returns (bool)
{
_approve(
msg.sender,
_spender,
allowances[msg.sender][_spender].add(_addedValue)
);
return true;
}

/**
 * @dev Atomically decreases the allowance granted to `spender` by the caller.
 *
 * This is an alternative to {approve} that can be used as a mitigation for
 * problems described in {IERC20-approve}.
 *
 * Emits an {Approval} event indicating the updated allowance.
 *
 * Requirements:
 *
 * - `_spender` cannot be the zero address.
 * - `_spender` must have allowance for the caller of at least
 * `_subtractedValue`.
 */
function decreaseAllowance(address _spender, uint256 _subtractedValue)
public
virtual
returns (bool)
{
_approve(
msg.sender,
_spender,
allowances[msg.sender][_spender].sub(
_subtractedValue,
"ERC20: decreased allowance below zero"
)
);
return true;
}

/**
 * @dev See {IERC20-totalSupply}.
 */
function totalSupply() public view override returns (uint256) {
return supply;
}

/**
 * @dev See {IERC20-balanceOf}.
 */
function balanceOf(address _account)
public
view
virtual
override
returns (uint256)
{
return balances[_account];
}

/**
 * @dev See {IERC20-allowance}.
 */
function allowance(address _owner, address _spender)
public
view
virtual
override
returns (uint256)
{
return allowances[_owner][_spender];
}

/**
 * @dev Moves tokens `amount` from `_sender` to `_recipient`.
 *
 * This is internal function is equivalent to {transfer}, and can be used to
 * e.g. implement automatic token fees, slashing mechanisms, etc.
 *
 * Emits a {Transfer} event.
 *
 * Requirements:
 *
 * - `_sender` cannot be the zero address.
 * - `_recipient` cannot be the zero address.
 * - `_sender` must have a balance of at least `amount`.
 */
function _transfer(
address _sender,
address _recipient,
uint256 amount
) internal virtual {
require(_sender != address(0), "ERC20: transfer from the zero address");
require(
_recipient != address(0),
"ERC20: transfer to the zero address"
);

_beforeTokenTransfer(_sender, _recipient, amount);

balances[_sender] = balances[_sender].sub(
amount,
"ERC20: transfer amount exceeds balance"
);
balances[_recipient] = balances[_recipient].add(amount);
emit Transfer(_sender, _recipient, amount);
}

/** @dev Creates `_amount` tokens and assigns them to `_account`, increasing
 * the total supply.
 *
 * Emits a {Transfer} event with `from` set to the zero address.
 *
 * Requirements:
 *
 * - `to` cannot be the zero address.
 */
function _mint(address _account, uint256 _amount) internal virtual {
require(_account != address(0), "ERC20: mint to the zero address");

_beforeTokenTransfer(address(0), _account, _amount);

supply = supply.add(_amount);
balances[_account] = balances[_account].add(_amount);
emit Transfer(address(0), _account, _amount);
}

/**
 * @dev Destroys `_amount` tokens from `_account`, reducing the
 * total supply.
 *
 * Emits a {Transfer} event with `to` set to the zero address.
 *
 * Requirements:
 *
 * - `_account` cannot be the zero address.
 * - `_account` must have at least `_amount` tokens.
 */
function _burn(address _account, uint256 _amount) internal virtual {
require(_account != address(0), "ERC20: burn from the zero address");

_beforeTokenTransfer(_account, address(0), _amount);

balances[_account] = balances[_account].sub(
_amount,
"ERC20: burn amount exceeds balance"
);
supply = supply.sub(_amount);
emit Transfer(_account, address(0), _amount);
}

/**
 * @dev Sets `_amount` as the allowance of `_spender` over the `_owner` s tokens.
 *
 * This internal function is equivalent to `approve`, and can be used to
 * e.g. set automatic allowances for certain subsystems, etc.
 *
 * Emits an {Approval} event.
 *
 * Requirements:
 *
 * - `_owner` cannot be the zero address.
 * - `_spender` cannot be the zero address.
 */
function _approve(
address _owner,
address _spender,
uint256 _amount
) internal virtual {
require(_owner != address(0), "ERC20: approve from the zero address");
require(_spender != address(0), "ERC20: approve to the zero address");

allowances[_owner][_spender] = _amount;
emit Approval(_owner, _spender, _amount);
}

/**
 * @dev Sets {decimals_} to a value other than the default one of 18.
 *
 * WARNING: This function should only be called from the constructor. Most
 * applications that interact with token contracts will not expect
 * {decimals_} to ever change, and may work incorrectly if it does.
 */
function _setupDecimals(uint8 decimals_) internal {
token.decimals = decimals_;
}

/**
 * @dev Hook that is called before any transfer of tokens. This includes
 * minting and burning.
 *
 * Calling conditions:
 *
 * - when `_from` and `_to` are both non-zero, `_amount` of ``_from``'s tokens
 * will be to transferred to `_to`.
 * - when `_from` is zero, `_amount` tokens will be minted for `_to`.
 * - when `_to` is zero, `_amount` of ``_from``'s tokens will be burned.
 * - `_from` and `_to` are never both zero.
 *
 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
 */
function _beforeTokenTransfer(
address _from,
address _to,
uint256 _amount
) internal virtual {}
}


// File contracts/token-ping-pong/TokenRouter.sol

//
pragma solidity >=0.6.11;

// ============ External Imports ============

// ============ Internal Imports ============




/*
============ Overview: Building a xApp ============
To implement a xApp, define the actions you would like to execute across chains.
For each type of action,
- in the xApp Router
    - implement a function like doTypeA to initiate the action from one domain to another (add your own parameters and logic)
    - implement a corresponding _handle function to receive, parse, and execute this type of message on the remote domain
    - add logic to the handle function to route incoming messages to the appropriate _handle function
- in the Message library,
    - implement functions to *format* the message to send to the other chain (encodes all necessary information for the action)
    - implement functions to *parse* the message once it is received on the other chain (decode all necessary information for the action)
*/
contract TokenRouter is Router {
ERC20 token;

// ============ Libraries ============

using TypedMemView for bytes;
using TypedMemView for bytes29;
//    using Message for bytes29;

// ============ Events ============

event MintReceived(uint256 amount, address to);
event BurnReceived(uint256 amount, address to);

// ============ Constructor ============

constructor(address _xAppConnectionManager, address _token) {
__XAppConnectionClient_initialize(_xAppConnectionManager);
token = ERC20(_token);
}

// ============ Handle message functions ============

/**
 * @notice Receive messages sent via Optics from other remote xApp Routers;
 * parse the contents of the message and enact the message's effects on the local chain
 * @dev Called by an Optics Replica contract while processing a message sent via Optics
 * @param _origin The domain the message is coming from
 * @param _sender The address the message is coming from
 * @param _message The message in the form of raw bytes
 */
function handle(
uint32 _origin,
bytes32 _sender,
bytes calldata _message
) external override onlyReplica onlyRemoteRouter(_origin, _sender) {
//        bytes29 _msg = _message.ref(0);
// route message to appropriate _handle function
// based on what type of message is encoded
if (TokenMessage.isTypeMint(_message)) {
_handleTypeMint(_message);
} else {
if (TokenMessage.isTypeBurn(_message)) {
_handleTypeBurn(_message);
}
// if _message doesn't match any valid actions, revert
require(false, "!valid action");
}
}

/**
 * @notice Once the Router has parsed a message in the handle function and determined it is Type A,
 * call this internal function to parse specific information from the message,
 * and enact the message's action on this chain
 * @param _message The message in the form of raw bytes
 */
function _handleTypeMint(bytes calldata _message) internal {
// parse the information from the message
uint256 _amount = TokenMessage.amount(_message);
address to = TokenMessage.to(_message);
// implement the logic for executing the action
// (in this example case, emit an event with the number that was sent)
token.mint(to, _amount);
emit MintReceived(_amount, to);
}

function _handleTypeBurn(bytes calldata _message) internal {
// parse the information from the message
uint256 _amount = TokenMessage.amount(_message);
address to = TokenMessage.to(_message);
// implement the logic for executing the action
// (in this example case, emit an event with the number that was sent)
token.burn(to, _amount);
emit BurnReceived(_amount, to);
}

// ============ Dispatch message functions ============

/**
 * @notice Send a message of "Type A" to a remote xApp Router via Optics;
 * this message is called to take some action in the cross-chain context
 * Example message types:
 * Sending tokens from this chain to the destination chain;
 * params would be the address of the token, the amount of the token to send, and the address of the recipient
 * @param _destinationDomain The domain to send the message to
 * @param _amount Example parameter used in message TypeA - a number to send to another chain
 */
function dispatchTypeMint(
uint32 _destinationDomain,
uint32 _amount,
address to
) external {
// get the xApp Router at the destinationDomain
bytes32 _remoteRouterAddress = _mustHaveRemote(_destinationDomain);
// encode a message to send to the remote xApp Router
bytes memory _outboundMessage = TokenMessage.formatTypeMint(
_amount,
to
);
// send the message to the xApp Router
token.burn(to, _amount);
_home().dispatch(
_destinationDomain,
_remoteRouterAddress,
_outboundMessage
);
}

function dispatchTypeBurn(
uint32 _destinationDomain,
uint32 _amount,
address to
) external {
// get the xApp Router at the destinationDomain
bytes32 _remoteRouterAddress = _mustHaveRemote(_destinationDomain);
// encode a message to send to the remote xApp Router
bytes memory _outboundMessage = TokenMessage.formatTypeBurn(
_amount,
to
);
// send the message to the xApp Router
token.mint(to, _amount);
_home().dispatch(
_destinationDomain,
_remoteRouterAddress,
_outboundMessage
);
}
}