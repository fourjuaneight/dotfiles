#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Format Name
# @raycast.mode silent
# @raycast.refreshTime 1h

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Enter text to cleanup" }

# Documentation:
# @raycast.description Format string to no-space style
# @raycast.author fourjuaneight
# @raycast.authorURL https://raycast.com/fourjuaneight

echo $1 | ~/.cargo/bin/sd ' x ' '-x-' | ~/.cargo/bin/sd ' - ' '-' | ~/.cargo/bin/sd ' ' '_' | pbcopy &&
echo "Formatted string copied to clipboard!"
