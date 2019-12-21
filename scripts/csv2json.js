const { readdir, writeFileSync } = require('fs');
const { join } = require('path');
const csv = require('csvtojson');

const home = __dirname.match(/\/Users\/[a-z]+/g);
const source = join(home[0], 'csv2json');

readdir(source, (err, files) => {
  if (err) {
    throw err;
  }

  files.forEach(src => {
    const json = src.replace(/csv/g, 'json');

    csv()
      .fromFile(`${source}/${src}`)
      .then(newFile =>
        writeFileSync(
          join(source, json),
          JSON.stringify(newFile, undefined, 2),
          'utf8'
        )
      );
  });
});
