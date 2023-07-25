#!/usr/bin/env bash

jpm clean && jpm build && strip build/alas
