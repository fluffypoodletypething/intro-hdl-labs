#!/usr/bin/env python3

import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--out')
    args = parser.parse_args()

    print(f"Writing hello world message to {args.out}.")
    message = b"Hello world\r\n"
    with open(args.out, 'w') as f:
        for b in message:
            f.write(f"{b:02x}\n")
    print(f"Wrote {len(message)} bytes to {args.out}.")
