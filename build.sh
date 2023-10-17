#!/usr/bin/env bash

jpm clean && jpm build --local && strip build/alas
