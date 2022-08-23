// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { AaveAddressBookV2 } from 'aave-address-book/AaveAddressBookV2.sol';
import {AaveV2Helpers, ReserveConfig, ReserveTokens, InterestStrategyValues} from "./utils/AaveV2Helpers.sol";
import {AaveGovHelpers, IAaveGov} from "./utils/AaveGovHelpers.sol";

import {FeiRiskParamsUpdate} from "../FeiRiskParamsUpdate.sol";
import {IERC20} from "../interfaces/IERC20.sol";

contract Validation1InchListing is Test {
    address internal constant AAVE_WHALE =
        0x25F2226B597E8F9514B3F68F00f494cF4f286491;

    address internal constant AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;

    address internal constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;

    uint8 internal constant ONEINCH_DECIMALS = 18;

    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address internal constant POOL = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;

    address internal constant RESERVE_TREASURY_ADDRESS = 0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c;

    address internal constant LENDING_POOL_ADDRESSES_PROVIDER = 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5;

    address internal constant INCENTIVES_CONTROLLER = address(0);

    string internal constant ATOKEN_NAME = "Aave interest bearing 1INCH";

    string internal constant ATOKEN_SYMBOL = "a1INCH";

    string internal constant STABLE_DEBT_TOKEN_NAME = "Aave stable debt bearing 1INCH";

    string internal constant STABLE_DEBT_TOKEN_SYMBOL = "stableDebt1INCH";

    string internal constant VARIABLE_DEBT_TOKEN_NAME = "Aave variable debt bearing 1INCH";
    
    string internal constant VARIABLE_DEBT_TOKEN_SYMBOL = "variableDebt1INCH";

    address internal constant DAI_WHALE =
        0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;

    address public constant ONEINCH_WHALE =
        0x2f3Fa8b85fbD0e29BD0b4E68032F61421782BDF0;

    // can't be constant for some reason
    string internal MARKET_NAME = "AaveV2Ethereum";

    function setUp() public {}

    /// @dev Uses an already deployed payload on the target network
    function testProposalPostPayload() public {
        /// deploy payload
        FeiRiskParamsUpdate fei = new FeiRiskParamsUpdate();
        address payload = address(fei);
        _testProposal(payload);
    }

    function _testProposal(address payload) internal {
        ReserveConfig[] memory allConfigsBefore = AaveV2Helpers
            ._getReservesConfigs(false, MARKET_NAME);

        address[] memory targets = new address[](1);
        targets[0] = payload;
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        string[] memory signatures = new string[](1);
        signatures[0] = "execute()";
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";
        bool[] memory withDelegatecalls = new bool[](1);
        withDelegatecalls[0] = true;

        uint256 proposalId = AaveGovHelpers._createProposal(
            vm,
            AAVE_WHALE,
            IAaveGov.SPropCreateParams({
                executor: AaveGovHelpers.SHORT_EXECUTOR,
                targets: targets,
                values: values,
                signatures: signatures,
                calldatas: calldatas,
                withDelegatecalls: withDelegatecalls,
                ipfsHash: bytes32(0)
            })
        );

        AaveGovHelpers._passVote(vm, AAVE_WHALE, proposalId);

        ReserveConfig[] memory allConfigsAfter = AaveV2Helpers
            ._getReservesConfigs(false, MARKET_NAME);

        AaveV2Helpers._validateCountOfListings(
            1,
            allConfigsBefore,
            allConfigsAfter
        );

        ReserveConfig memory expectedConfig = ReserveConfig({
            symbol: "FEI",
            underlying: FEI,
            aToken: address(0), // Mock, as they don't get validated, because of the "dynamic" deployment on proposal execution
            variableDebtToken: address(0), // Mock, as they don't get validated, because of the "dynamic" deployment on proposal execution
            stableDebtToken: address(0), // Mock, as they don't get validated, because of the "dynamic" deployment on proposal execution
            decimals: 18,
            ltv: 0,
            liquidationThreshold: 0,
            liquidationBonus: 10000,
            reserveFactor: 2000,
            usageAsCollateralEnabled: true,
            borrowingEnabled: true,
            interestRateStrategy: address(0),
            stableBorrowRateEnabled: false,
            isActive: true,
            isFrozen: false
        });

        AaveV2Helpers._validateReserveConfig(
            expectedConfig,
            allConfigsAfter
        );

    }
}
