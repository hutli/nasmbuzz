# nasmbuzz

Someone asked me for a silly fizzbuzz and I need to get better at shellcode so this is the result.

## Requirements

This is 64 bit NASM so x86-64 machine is required.

Lib.c is dynamically linked so `/lib64/ld-linux-x86-64.so.2` is also required on your Linux machine (Maybe just changing the path in the `Makefile` works for Windows? I know nothing about Windows ¯\\\_(ツ)\_/¯).

`nasm` is required - probably installable through your favorite package manager as `nasm`.

## Build

`make build`

## Run (and build)

`make run`

## Usage

Wanna count to more than 100? Change the constant on line 53 in `fizzbuzz.asm`.

"But I want to be able to set that number in `argv`!" - I take pull-requests ;)
