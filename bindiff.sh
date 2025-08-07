#!/bin/bash

description() {
    cat <<EOF
# Description:

This program uses an external program to produce a file dump (set by the -u
option) which is then compared using another external program (set by the -d
option)

For setting options to the external programs just quote the argument following
the -u and -d options and place the options there (check the examples)

This program accept POSIX-compliant options

This program requires two files, if more are provided they are ignored, if less
an error will be shown
EOF
}

usage() {
    cat <<EOF
# Usage: $0 [-h | --help] [-k | --keep]
         [(-d | --diff-cmd) <cmd> (default "diff")]
         [(-u | --dump-cmd) <cmd> (default "xxd")] <file 1> <file 2>

## Usage examples:

> Print the usage help (with a more accurate description):
$0 -h
$0 --help

> Compute the binary diff of two files
$0 <file 1> <file 2>

> Compute the binary diff of two files and keep the xxd dumps
   (the xxd dump location will be printed to stdout)
$0 -k <file 1> <file 2>
$0 --keep <file 1> <file 2>

> Compute the binary diff of two files using "od -b" as a file dumper
  (i.e. use the "od" program with the -b flag)
$0 -u "od -b" <file 1> <file 2>
$0 --dump-cmd "od-b" <file 1> <file 2>

> Compute the binary diff of two files using "xxd -c32" (32-bit words) as a
  dumper and compare the two dumps with vimdiff
$0 -d vimdiff -u "xxd -c32" <file 1> <file 2>
EOF
}

DUMP_CMD=xxd
DIFF_CMD=diff

OPTS=$(getopt -o 'hkd:u:' -l 'help,keep,diff-cmd:,dump-cmd:' -n "$0" -- "$@")\
    || {
        echo >&2
        usage >&2
        exit 1
}

eval set -- "$OPTS"
unset OPTS

while true; do
    case "$1" in
        -u | --dump-cmd)
            DUMP_CMD="$2"
            shift 2
            ;;
        -d | --diff-cmd)
            DIFF_CMD="$2"
            shift 2
            ;;
        -k | --keep)
            KEEP=1
            shift
            ;;
        -h | --help)
            description
            echo
            usage
            exit
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error" >&2
            exit 1
            ;;
    esac
done

if [ ! -e "$1" -o ! -e "$2" ]; then
    echo "Both \"$1\" and \"$2\" must be non-empty," \
        "existing regular file names" >&2
    exit 1
fi

tmp1=$(mktemp --tmpdir "bindiff.$1.XXXXXXXXXX")
tmp2=$(mktemp --tmpdir "bindiff.$2.XXXXXXXXXX")

if [ "${KEEP}" ]; then
    echo "Dump of file \"$1\" in \"${tmp1}\""
    echo "Dump of file \"$2\" in \"${tmp2}\""
    echo
fi

${DUMP_CMD} "$1" > "${tmp1}"
${DUMP_CMD} "$2" > "${tmp2}"

${DIFF_CMD} "${tmp1}" "${tmp2}"

if [ ! "${KEEP}" ]; then
    rm "${tmp1}" "${tmp2}"
fi
