#!/bin/bash

# Parse options to the 'colony' command
while getopts ":h" opt; do
    case ${opt} in
        h | help )
            echo "Usage: colony COMMAND"
            echo "    swarmer -h                     Display this help message."
            echo "    swarmer worker <operation>     Perform operations on a worker node"
            echo "    swarmer service <operation>    Envoke service commands"
            echo "    swarmer deploy <operation>     Deploy a swarm composed of worker nodes"
            exit 0
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

subcommand=$1; shift  # Remove 'swarmer' from the argument list
case "$subcommand" in
    # Parse options to the worker sub command
    worker )
        while getopts ":h" opt; do
            case ${opt} in
                h | help )
                    echo "Usage: swarmer worker COMMAND"
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
            "" )
                echo "Usage: swarmer worker COMMAND"
                    echo "    create    Create a worker node"
                    echo "    add       Adds worker node to swarm"
                    echo "    stop      Stops worker node"
                    echo "    rm        Removes worker node"
                    echo "    start     Starts worker node"
                    exit 0
                    ;;
            create )
                while getopts ":ht:l:d:p:e:-:" opt; do
                    case ${opt} in
                        -)
                            case "${OPTARG}" in
                                type)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

                                    if [[ -z "${val}" ]]
                                    then
                                        echo "Option --${OPTARG} requires an argument." >&2
                                        exit 1
                                    fi

                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    TYPE=${val} >&2
                                    ;;
                                label)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

                                    if [[ -z "${val}" ]]
                                    then
                                        echo "Option --${OPTARG} requires an argument." >&2
                                        exit 1
                                    fi

                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    LABEL=${val} >&2
                                    ;;
                                num_workers)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

                                    if [[ -z "${val}" ]]
                                    then
                                        echo "Option --${OPTARG} requires an argument." >&2
                                        exit 1
                                    fi

                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    NUM_WORKERS=${val} >&2
                                    ;;
                                deployment)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

                                    if [[ -z "${val}" ]]
                                    then
                                        echo "Option --${OPTARG} requires an argument." >&2
                                        exit 1
                                    fi

                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    DEPLOYMENT=${val} >&2
                                    ;;
                                provider)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

                                    if [[ -z "${val}" ]]
                                    then
                                        echo "Option --${OPTARG} requires an argument." >&2
                                        exit 1
                                    fi

                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    provider=${val} >&2
                                    ;;
                                environment)
                                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))

                                    if [[ -z "${val}" ]]
                                    then
                                        echo "Option --${OPTARG} requires an argument." >&2
                                        exit 1
                                    fi

                                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                                    ENV=${val} >&2
                                    ;;
                                *)
                                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                                        echo "Unknown option --${OPTARG}" >&2
                                    fi
                                    ;;
                            esac;;
                        h )
                            echo "Usage: swarmer worker create [OPTIONS]"
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
                        l )
                            echo "Parsing option: '-${opt}', value: '${OPTARG}'" >&2;
                            LABEL=${OPTARG} >&2
                            ;;
                        d )
                            echo "Parsing option: '-${opt}', value: '${OPTARG}'" >&2;
                            DEPLOYMENT=${OPTARG} >&2
                            ;;
                        p )
                            echo "Parsing option: '-${opt}', value: '${OPTARG}'" >&2;
                            PROVIDER=${OPTARG} >&2
                            ;;
                        e )
                            echo "Parsing option: '-${opt}', value: '${OPTARG}'" >&2;
                            ENV=${OPTARG} >&2
                            ;;
                        :)
                            echo "Option -$OPTARG requires an argument." >&2
                            exit 1
                            ;;
                    esac
                done
                echo "TYPE: $TYPE"
                echo "LABEL: $LABEL"
                echo "NUM_WORKERS: $NUM_WORKERS"
                echo "DEPLOYMENT: $DEPLOYMENT"
                echo "PROVIDER: $PROVIDER"
                echo "ENV: $ENV"
                echo "Calling create function..."
                ;;
        esac
esac