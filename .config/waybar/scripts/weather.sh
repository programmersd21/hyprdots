#!/usr/bin/env bash
curl -s 'wttr.in/?format=1' | grep -v "Unknown" || echo "⛅"
