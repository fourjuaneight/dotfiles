const fs = require('fs');
const { join } = require('path');
const { add, commit, statusMatrix } = require('isomorphic-git');

const dir = join(process.cwd(), '/');
const FILE = 0;
const WORKDIR = 2;
const STAGE = 3;
const changes = {
  hazel: {
    glob: 'hazel/*',
    cm: 'Updated hazel preferences.',
  },
  pref: {
    glob: 'preferences/*',
    cm: 'Updated utilities preferences.',
  },
  tmux: {
    glob: 'tmux/*',
    cm: 'Updated tmux config.',
  },
  vim: {
    glob: 'vim/*',
    cm: 'Updated vim config.',
  },
  zsh: {
    glob: 'zsh/*',
    cm: 'Updated zsh config.',
  },
};

Object.keys(changes).forEach(section => {
  const sec = changes[section];

  statusMatrix({ fs, dir, pattern: sec.glob })
    .then(status =>
      status.filter(row => row[WORKDIR] !== row[STAGE]).map(row => row[FILE])
    )
    .then(modified => {
      if (modified.length !== 0) {
        modified.forEach(file => add({ fs, dir, filepath: file }));

        return true;
      }
      return false;
    })
    .then(stuff => {
      if (stuff) {
        commit({
          fs,
          dir,
          author: {
            name: 'Juan Villela',
            email: 'juan@villela.co',
          },
          message: sec.cm,
        });
      }
    });
});
