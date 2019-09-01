module.exports = {
  config: {
    bell: false,
    borderColor: '#FF79C6',
    copyOnSelect: false,
    cursorColor: 'rgb(87,236,135)',
    cursorShape: 'BLOCK',
    defaultSSHApp: true,
    fontFamily: '"Fira Code", "IBM Plex Mono", Menlo, monospace',
    fontSize: 14,
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    padding: '10px',
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
    'hyper-dracula',
    'hyper-tabs-enhanced'
  ]
};