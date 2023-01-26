contract SimpleStore {
    uint256 public value;

    function setValue(uint256 _value) external {
        value = _value;
    }

    function getValue() external returns (uint256) {
        return value;
    }
}