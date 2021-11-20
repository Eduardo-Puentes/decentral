// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Media {
    uint256 internal numberOfPosts;
    address internal cUsdTokenAddress ;

    struct BasePost {
        address owner;
        string title;
        string content;
    }

    constructor(){
        cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
        numberOfPosts = 0;
    }

    mapping(uint256 => BasePost) internal basePosts;

    mapping(address => address[]) internal subscriptions;

    mapping(address => uint[]) internal myPosts;

    mapping(address => uint256) internal prices;

    function postPost(
        string memory _title,
        string memory _content,
        uint256 _price
    ) public {
        basePosts[numberOfPosts] = BasePost(msg.sender, _title, _content);
        prices[msg.sender] = _price;
        // ÷push the id of the post to the array
        myPosts[msg.sender].push(numberOfPosts);
        numberOfPosts++;
    }

    function getPost(uint256 _index)
        public
        view
        returns (
            address,
            string memory,
            string memory
        )
    {
        return (
            basePosts[_index].owner,
            basePosts[_index].title,
            basePosts[_index].content
        );
    }

    function subscribe(address _creator) public payable {
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
                msg.sender,
                _creator,
                prices[_creator]
            ),
            "Transfer failed."
        );
        subscriptions[msg.sender].push(_creator);
    }

    function getSubscriptions(address _profile)
        public
        view
        returns (address[] memory)
    {
        return (subscriptions[_profile]);
    }

    function getNumberOfPosts() public view returns (uint256) {
        return (numberOfPosts);
    }

    // get the posts a user created
    function getMyPosts() public view returns ( uint[] memory) {
        return (myPosts[msg.sender]);
    }


    function getPrice(address _profile) public view returns (uint256) {
        return (prices[_profile]);
    }
}
