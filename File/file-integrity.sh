#!/bin/bash

declare HASH_A_FILE=
declare SEE_INTEGRITY=
declare FILE=

# Function to display usage information
function usage() {
    echo "Options:  "
    echo " [-h  --help]     Display this help message                               "
    echo " [-f  --file]  the file that we want to hash/see integrity                "
    echo " [-v  --version]  Display version information                             "
    echo " [-hf --hash_a_file]  Boolean [either 1 or 0] integrates a new hash       "
    echo " [-s  --see_integrity]  Boolean [either 1 or 0] see given file integrity  "

}

while [[ $# -gt 0 ]]; do
    case "$1" in

        -hf|--hash_a_file)
            # Handle the greeting tag
            HASH_A_FILE="$2"
            shift 2 
            ;;

        -h|--help)
            # help tag
            help
            shift 2 
            ;;
        -s|--see_integrity)
            # Handle the command tag
            SEE_INTEGRITY="$2"
            shift 2 
            ;;

        -f|--file)
            FILE="$2"
            shift 2  
            ;;

        *)
            # Handle unknown tags or invalid usage
            echo "Unknown tag or usage: $1"
            shift  # Move to the next argument
            ;;
    esac
done

HASH_DIRECTORY="./file_monitor/"

# Check if the directory doesn't exist
if [ ! -d "$HASH_DIRECTORY" ]; then
    mkdir -p "$HASH_DIRECTORY"
else
    :
fi


function INSERT_NEW_FILE() {
    read -s "enter the password for the hash" PASSWORD

    local ENCRYPTION_FILE="$FULL_PATH_FILE.enc"
    local FULL_PATH_HASH_FILE="$FULL_PATH_FILE.md5"

    touch                       $FULL_PATH_HASH_FILE
    touch                       $ENCRYPTION_FILE

    md5sum "$FULL_PATH_FILE" >> $FULL_PATH_HASH_FILE

    # Encrypt hash file: 
    openssl enc -aes-256-cbc -in $FULL_PATH_HASH_FILE -out $ENCRYPTION_FILE -pass pass:"$PASSWORD"
    if [[ $? > 0 ]]; then
        echo "Wrong password. Try again"
        exit 1
    fi

    mv $ENCRYPTION_FILE         $HASH_DIRECTORY
    mv $FULL_PATH_HASH_FILE     $HASH_DIRECTORY
    chattr +i                   $FULL_PATH_HASH_FILE
    chattr +i                   $ENCRYPTION_FILE
}
def check_network_bottleneck(interval=5, threshold=1000000):  # Adjust threshold as needed
    while True:
        sent_bytes, recv_bytes = calculate_bandwidth(interval)
        sent_kbps = sent_bytes / 1024 / interval
        recv_kbps = recv_bytes / 1024 / interval

        print(f"Sent: {sent_kbps:.2f} KB/s, Received: {recv_kbps:.2f} KB/s")

        # Check if any of the bandwidth exceeds the threshold
        if sent_kbps > threshold or recv_kbps > threshold:

            current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            filename = f"traffic_capture_{current_time}.pcap"
            capture_and_save(filename,  iface=iface, filter=target_host, count=count)

            print("Potential network bottleneck detected!")

if [ -n "$HASH_A_FILE" ]; then
    INSERT_NEW_FILE
fi

if [ -n "$SEE_INTEGRITY" ]; then
elif [ -n "$file" ]; then
    SEE_FILE_INTEGRITY
else 
    echo "You forgot to include the file name [FULL PATH]." 
fi

