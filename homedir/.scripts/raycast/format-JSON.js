#!/usr/bin/env node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Format JSON
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 🤖
// @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }

// Documentation:
// @raycast.description Format JSON
// @raycast.author fourjuaneight
// @raycast.authorURL https://raycast.com/fourjuaneight

const { exec } = require("child_process");

const input = process.argv[2];
const output = JSON.stringify(JSON.parse(input), null, 2);

exec(`echo "${output}" | pbcopy`);

console.log("Formatted JSON copied to clipboard!");
