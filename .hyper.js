module.exports = {
  config: {
    bell: false,
    borderColor: 'rgb(189,147,249)',
    copyOnSelect: false,
    cursorColor: 'rgb(87,236,135)',
    cursorShape: 'BLOCK',
    defaultSSHApp: true,
    fontFamily: '"Fira Code", "IBM Plex Mono", Menlo, monospace',
    fontSize: 14,
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    padding: '10px',
    shell: 'C:\\Windows\\System32\\bash.exe',
    shellArgs: ['--login'],
    updateChannel: 'stable',
    wickedBorder: true,
    windowSize: [1230, 1230],
    hyperTabs: {
      border: true,
      closeAlign: 'right',
      tabIconsColored: true,
      trafficButtons: true
    }
  },
  plugins: [
    'hyperterm-cobalt2-theme',
    'hyper-tabs-enhanced'
  ],
  updateChannel: 'canary'
};