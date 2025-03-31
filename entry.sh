#!/bin/bash
# 🚀 Check and generate key if SURI or ACCOUNT is not provided
if [ -z "${SURI+x}" ] || [ -z "$SURI" ] || [ -z "${ACCOUNT+x}" ] || [ -z "$ACCOUNT" ]; then
    echo -e "🔑 \033[1;33mSURI or ACCOUNT is not passed. Generating one for you...\033[0m"
    KEYSTORE_PASSWORD='secret'
    output=$(aggregator-node key generate --password "$KEYSTORE_PASSWORD")
    
    # 📋 Extract values from the generated output
    SECRET_PHRASE=$(echo "$output" | grep "Secret phrase:" | cut -d ':' -f2- | xargs)
    SURI=$(echo "$output" | grep "Secret seed:" | cut -d ':' -f2- | xargs)
    ACCOUNT=$(echo "$output" | grep "SS58 Address:" | cut -d ':' -f2- | xargs)
    
else
    echo -e "🔐 \033[1;32mUsing provided SURI and ACCOUNT.\033[0m"
fi
    echo -e "🪪 \033[1;32mOwner Address: $ACCOUNT.\033[0m"

# Wait for IPFS to start...
echo -e "😴 \033[1;35mWaiting for IPFS to start...\033[0m"
sleep 5

# 🗂️ Insert key into keystore
echo -e "🗝️ \033[1;36mInserting key into keystore...\033[0m"
if [ -z "${KEYSTORE_PASSWORD+x}" ] || [ -z "$KEYSTORE_PASSWORD" ]; then
    echo -e "⚠️ \033[1;33mNo password provided. Proceeding without password...\033[0m"
    if ! /usr/local/bin/aggregator-node key insert --suri "$SURI"; then
        echo -e "❌ \033[1;31mFailed to insert key into keystore. Exiting for now...\033[0m"
        exit 1
    fi
    # 🌐 Run the Aggregator Node
    echo -e "⚡ \033[1;35mStarting Aggregator Node...\033[0m"
    if ! /usr/local/bin/aggregator-node run --dev --listen-addr "${LISTEN_ADDR}" --listen-port "${LISTEN_PORT}" --address "${ACCOUNT}" --chain-rpc "${CHAIN_RPC}" --tmp-storage-dir "/tmp/vola/" --ipfs-rpc-addr "192.168.1.4" --ipfs-gateway-addr "192.168.1.4"; then
        echo -e "❌ \033[1;31mFailed to start the Aggregator Node. Please check your configuration and try again.\033[0m"
        exit 1
    fi
else
    echo -e "🔐 \033[1;32mPassword provided. Proceeding with password...\033[0m"
    if ! /usr/local/bin/aggregator-node key insert --suri "$SURI" --password "$KEYSTORE_PASSWORD"; then
        echo -e "❌ \033[1;31mFailed to insert key into keystore. Exiting for now...\033[0m"
        exit 1
    fi
    # 🌐 Run the Aggregator Node
    echo -e "⚡ \033[1;35mStarting Aggregator Node...\033[0m"
    if ! /usr/local/bin/aggregator-node run --dev --listen-addr "${LISTEN_ADDR}" --listen-port "${LISTEN_PORT}" --address "${ACCOUNT}" --password "$KEYSTORE_PASSWORD" --chain-rpc "$CHAIN_RPC" --tmp-storage-dir "/tmp/vola/" --ipfs-rpc-addr "192.168.1.4" --ipfs-gateway-addr "192.168.1.4"; then
        echo -e "❌ \033[1;31mFailed to start the Aggregator Node. Please check your configuration and try again.\033[0m"
        exit 1
    fi
fi



# ✅ Success message
echo -e "✅ \033[1;32mAggregator Node is running successfully!\033[0m"
