module.exports = {
  config: {
    shell: 'C:\\Windows\\System32\\bash.exe',
    updateChannel: 'stable',
    fontSize: 14,
    fontFamily: '"IBM Plex Mono", Menlo, monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    padding: '0 14px',
    borderColor: 'rgb(189,147,249)',
    cursorColor: 'rgb(87,236,135)',
    shellArgs: ['--login'],
    bell: false,
    copyOnSelect: false,
    defaultSSHApp: true,
  },
  plugins: ['hyper-dracula'],
};