/// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

// Contracts
import "../../types/LiquidityTypes.sol";
import "../../types/DataTypes.sol";

// Test Utils
import "../utils/ProtocolActions.sol";
import "../utils/AmbParams.sol";

contract SDSVD4626SwapTokenInputSlippageL1 is ProtocolActions {
    function setUp() public override {
        super.setUp();
        /*//////////////////////////////////////////////////////////////
                !! WARNING !!  DEFINE TEST SETTINGS HERE
    //////////////////////////////////////////////////////////////*/
        AMBs = [2, 3];

        CHAIN_0 = OP;
        DST_CHAINS = [OP];

        /// @dev define vaults amounts and slippage for every destination chain and for every action
        TARGET_UNDERLYINGS[OP][0] = [1];

        TARGET_VAULTS[OP][0] = [0]; /// @dev id 0 is normal 4626

        TARGET_FORM_KINDS[OP][0] = [0];

        AMOUNTS[OP][0] = [31245];

        MAX_SLIPPAGE[OP][0] = [1000];

        /// @dev 1 for socket, 2 for lifi
        LIQ_BRIDGES[OP][0] = [1];

        actions.push(
            TestAction({
                action: Actions.Deposit,
                multiVaults: false, //!!WARNING turn on or off multi vaults
                user: 0,
                testType: TestType.Pass,
                revertError: "",
                revertRole: "",
                slippage: 852, // 0% <- if we are testing a pass this must be below each maxSlippage,
                multiTx: false,
                ambParams: generateAmbParams(DST_CHAINS.length, 2),
                msgValue: 50 * 10 ** 18,
                externalToken: 0 /// @dev input token != vault underlying - swap involved
            })
        );
    }

    /*///////////////////////////////////////////////////////////////
                        SCENARIO TESTS
    //////////////////////////////////////////////////////////////*/

    function test_scenario() public {
        for (uint256 act = 0; act < actions.length; act++) {
            TestAction memory action = actions[act];
            MultiVaultsSFData[] memory multiSuperFormsData;
            SingleVaultSFData[] memory singleSuperFormsData;
            MessagingAssertVars[] memory aV;
            StagesLocalVars memory vars;
            bool success;

            _runMainStages(action, act, multiSuperFormsData, singleSuperFormsData, aV, vars, success);
        }
    }
}
