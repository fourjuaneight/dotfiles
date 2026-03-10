#!/usr/bin/env node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Format String
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 🤖
// @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }

// Documentation:
// @raycast.description Format string to no-space style
// @raycast.author fourjuaneight
// @raycast.authorURL https://raycast.com/fourjuaneight

const { exec } = require("child_process");

/**
 * Convert record name into a filename ready for upload.
 * @function
 *
 * @param {string} name record name
 * @returns {string} record filename
 */
const fileNameFmt = (name) => {
  const cleanName = name
    .replace(/^\s/g, "")
    .replace(/([a-zA-Z0-9])\.([a-zA-Z0-9])/g, "$1_$2")
    .replace(/\.$/g, "")
    .replace(/\?$/g, "")
    .replace(/!$/g, "")
    .replace(/\.\s/g, "-")
    .replace(/,\s/g, "-")
    .replace(/\s::\s/g, "-")
    .replace(/\s:\s/g, "-")
    .replace(/:\s/g, "-")
    .replace(/\s-\s/g, "-")
    .replace(/\s--\s/g, "-")
    .replace(/\s–\s/g, "-")
    .replace(/\s––\s/g, "-")
    .replace(/\s—\s/g, "-")
    .replace(/\s——\s/g, "-")
    .replace(/…\s/g, "_")
    .replace(/[-|\\]+/g, "-")
    .replace(/\s&\s/g, "_and_")
    .replace(/&/g, "_and_")
    .replace("?", "")
    .replace(/[!@#$%^*()+=[\]{};'’‘:"”“,.<>/?]+/g, "")
    .replace(/\s/g, "_")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]+/g, "")
    .replace(/[\u202a-\u202c]+/g, "");

  return cleanName;
};

const input = process.argv[2];
const output = fileNameFmt(input);

exec(`echo "${output}" | pbcopy`);

console.log("Formatted string copied to clipboard!");
