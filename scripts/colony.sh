#!/bin/bash

# Parse options to the 'colony' command
while getopts ":h" opt; do
    case ${opt} in
        h | help )
            echo "Usage: colony COMMAND"
            echo "    colony -h                     Display this help message."
            echo "    colony worker <operation>     Perform operations on a worker node"
            echo "    colony service <operation>    Envoke service commands"
            echo "    colony deploy <operation>     Deploy a swarm composed of worker nodes"
            exit 0
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

subcommand=$1; shift  # Remove 'colony' from the argument list
case "$subcommand" in
    # Parse options to the worker sub command
    worker )
        while getopts ":h" opt; do
            case ${opt} in
                h | help )
                    echo "Usage: colony worker COMMAND"
                    echo "    create    Create a worker node"
                    echo "    add       Adds worker node to swarm"
                    echo "    stop      Stops worker node"
                    echo "    rm        Removes worker node"
                    echo "    start     Starts worker node"
                    exit 0
                    ;;
                \? )
                    echo "Invalid Option: -$OPTARG" 1>&2
                    exit 1
                    ;;
            esac
        done
        shift $((OPTIND -1))

        TYPE=512mb
        LABEL=
        NUM_WORKERS=1
        PROVIDER=aws
        ENV=dev
        DEPLOYMENT=blue

        subcommand=$1; shift  # Remove 'worker' from the argument list
        case "$subcommand" in
            create )
                while getopts ":ht:-:" opt; do
                    case ${opt} in
                        -)
                            case "${OPTARG}" in
                                type)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    TYPE=${val} >&2
                                    ;;
                                *)
                                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                                        echo "Unknown option --${OPTARG}" >&2
                                    fi
                                    ;;
                            esac;;
                        h )
                            echo "Usage: colony worker create [OPTIONS]"
                            echo -e "\nOptions:"
                            echo "          -t, --type string       TODO: add description"
                            echo "          -l, --label string      TODO: add description"
                            echo "              --num_workers int   TODO: add description"
                            echo "          -p, --provider string   TODO: add description"
                            echo "          -e, --env string        TODO: add description"
                            echo "          -d, --deployment string TODO: add description"
                            exit 0
                            ;;
                        t )
                            echo "Parsing option: '-${opt}', value: '${OPTARG}'" >&2;
                            TYPE=${OPTARG} >&2
                            ;;
                    esac
                done
                echo "TYPE: $TYPE"
                echo "Calling create function..."
                ;;
        esac
esac