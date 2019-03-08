# Node Packages
echo "Installing global npm packages..."
NPM_PACKAGES=(
    @babel/core
    @slack/client
    babel-cli
    babel-eslint
    branch-diff
    fkill-cli
    eslint
    eslint-config-airbnb
    eslint-config-prettier
    gatsby
    gatsby-cli
    glyphhanger
    graphiql
    graphql
    graphql-tools
    gtop
    gulp
    localtunnel
    node-sass
    postcss-cli
    prettier
    rgb-hex-cli
    react
    react-dom
    speed-test
    simple-node-logger
    trash
    webpack
    webpack-cli
)
npm install -g ${NPM_PACKAGES[@]}