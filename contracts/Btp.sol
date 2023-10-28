// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

/// Node Not Found. Needed `nodeId`
/// @param nodeId node id.
error NodeNotFound(uint256 nodeId);

/// Node Not Owned By Host. Needed `nodeId`
/// @param nodeId node id.
error NodeNotOwned(uint256 nodeId);

/// Node Not Found. Needed `nodeId`
/// @param nodeId node id.
error NodeNotAvailable(uint256 nodeId);

contract Btp {
    struct Node {
        uint256 nodeId;
        string provider;
        string api;
        string key;
        address host;
        bool isAvailable;
    }

    uint256 nodeCount = 0;

    mapping(uint256 => Node) mapNode;

    event NodeCreated(
        address host,
        uint256 nodeId,
        string provider,
        string api,
        string key
    );
    event NodeUpdated(
        address host,
        uint256 nodeId,
        string provider,
        string api,
        string key
    );
    event NodeDeleted(address host, uint256 nodeId);

    function createNode(
        string memory provider,
        string memory api,
        string memory key
    ) public {
        nodeCount++;
        Node memory newNode = Node(
            nodeCount,
            provider,
            api,
            key,
            msg.sender,
            true
        );
        mapNode[nodeCount] = newNode;
        emit NodeCreated(msg.sender, nodeCount, provider, api, key);
    }

    function updateNode(
        uint256 nodeId,
        string memory provider,
        string memory api,
        string memory key
    ) public nodeOwned(nodeId) {
        Node storage node = mapNode[nodeId];

        if (bytes(provider).length > 0) {
            node.provider = provider;
        }
        if (bytes(api).length > 0) {
            node.api = api;
        }
        if (bytes(key).length > 0) {
            node.key = key;
        }

        emit NodeUpdated(msg.sender, nodeId, provider, api, key);
    }

    function deleteNode(uint256 nodeId) public nodeOwned(nodeId) {
        Node storage node = mapNode[nodeId];
        node.isAvailable = false;
        emit NodeDeleted(msg.sender, nodeId);
    }

    modifier nodeOwned(uint256 nodeId) {
        Node storage node = mapNode[nodeId];
        if (node.nodeId == 0) revert NodeNotFound({nodeId: nodeId});
        if (!node.isAvailable) revert NodeNotAvailable({nodeId: nodeId});
        if (node.host != msg.sender) revert NodeNotOwned({nodeId: nodeId});
        _;
    }

    function getNodeById(uint256 nodeId) public view returns (Node memory) {
        Node memory node = mapNode[nodeId];
        if (node.nodeId == 0) revert NodeNotFound(nodeId);
        return node;
    }

    function getNodesByIds(
        uint256[] calldata ids
    ) public view returns (Node[] memory) {
        uint256 n = ids.length;
        Node[] memory nodes = new Node[](n);

        for (uint256 i = 0; i < n; i++) {
            uint256 id = ids[i];
            Node memory node = mapNode[id];
            if (node.nodeId == 0) revert NodeNotFound(id);
            nodes[i] = node;
        }
        return nodes;
    }
}
