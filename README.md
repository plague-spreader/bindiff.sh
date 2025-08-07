# Description:

This program uses an external program to produce a file dump (set by the -u
option) which is then compared using another external program (set by the -d
option)

For setting options to the external programs just quote the argument following
the -u and -d options and place the options there (check the examples)

This program accept POSIX-compliant options

This program requires two files, if more are provided they are ignored, if less
an error will be shown

# Usage:
```
./bindiff.sh [-h | --help] [-k | --keep]
    [(-d | --diff-cmd) <cmd> (default "diff")]
    [(-u | --dump-cmd) <cmd> (default "xxd")] <file 1> <file 2>
```

## Usage examples:

> Print the usage help (with a more accurate description):
`./bindiff.sh -h`
`./bindiff.sh --help`

> Compute the binary diff of two files
`./bindiff.sh <file 1> <file 2>`

> Compute the binary diff of two files and keep the xxd dumps
   (the xxd dump location will be printed to stdout)
`./bindiff.sh -k <file 1> <file 2>`
`./bindiff.sh --keep <file 1> <file 2>`

> Compute the binary diff of two files using "od -b" as a file dumper
  (i.e. use the "od" program with the -b flag)
`./bindiff.sh -u "od -b" <file 1> <file 2>`
`./bindiff.sh --dump-cmd "od-b" <file 1> <file 2>`

> Compute the binary diff of two files using "xxd -c32" (32-bit words) as a
  dumper and compare the two dumps with vimdiff
`./bindiff.sh -d vimdiff -u "xxd -c32" <file 1> <file 2>`
