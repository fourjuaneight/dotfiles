const { exec } = require('child_process');
const { isatty } = require('tty');
const { join } = require('path');

const folders = ['Files', 'Music', 'Photos'];
const media = '/mnt/sdb';
const b2 = 'b2:helms-deep';
const rclone = ['rclone', 'sync', '--ignore-existing'];
if (isatty(1)) {
  rclone.splice(2, 0, '-P');
}

const backup = dirs => {
  dirs.forEach(dir =>
    exec(
      `${rclone.join(' ')} ${join(media, dir, '/')} ${join(
        b2,
        dir.toLowerCase()
      )}`,
      (err, stdout, stderr) => {
        if (err) {
          console.error(`exec error: ${err}`);
        }
        if (stderr) {
          console.error(`rclone error: ${stderr}`);
        }
        console.log(stdout);
      }
    )
  );
};

backup(folders);