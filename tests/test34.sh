#!/bin/sh

# success
../build/examples/test6 -n homer 2  > tmp.out 2>&1

if cmp -s tmp.out $srcdir/test34.out; then
	exit 0
else
	exit 1
fi

