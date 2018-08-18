const Oath = artifacts.require("./Oath.sol")

module.exports = function(deployer) {
    deployer.deploy(Oath);
};
