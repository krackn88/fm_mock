@echo off
echo Setting up the project directory...

REM Check for necessary files
IF NOT EXIST "package.json" (
    echo ERROR: package.json is missing.
    exit /b 1
)

IF NOT EXIST "webpack.config.js" (
    echo ERROR: webpack.config.js is missing.
    echo Creating default webpack.config.js...
    echo const path = require('path'); > webpack.config.js
    echo module.exports = { >> webpack.config.js
    echo     entry: './src/index.js', >> webpack.config.js
    echo     output: { >> webpack.config.js
    echo         filename: 'bundle.js', >> webpack.config.js
    echo         path: path.resolve(__dirname, 'dist') >> webpack.config.js
    echo     }, >> webpack.config.js
    echo     mode: 'development', >> webpack.config.js
    echo     module: { >> webpack.config.js
    echo         rules: [ >> webpack.config.js
    echo             { >> webpack.config.js
    echo                 test: /\.js$/, >> webpack.config.js
    echo                 exclude: /node_modules/, >> webpack.config.js
    echo                 use: { >> webpack.config.js
    echo                     loader: 'babel-loader', >> webpack.config.js
    echo                     options: { >> webpack.config.js
    echo                         presets: ['@babel/preset-env'] >> webpack.config.js
    echo                     } >> webpack.config.js
    echo                 } >> webpack.config.js
    echo             } >> webpack.config.js
    echo         ] >> webpack.config.js
    echo     } >> webpack.config.js
    echo }; >> webpack.config.js
    echo Created default webpack.config.js.
)

IF NOT EXIST "netlify.toml" (
    echo ERROR: netlify.toml is missing.
    echo Creating default netlify.toml...
    echo [build] > netlify.toml
    echo command = "npm run build" >> netlify.toml
    echo publish = "dist" >> netlify.toml
    echo ignore = "git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF ." >> netlify.toml
    echo [functions] >> netlify.toml
    echo node_bundler = "esbuild" >> netlify.toml
    echo [[redirects]] >> netlify.toml
    echo from = "/telemetry/*" >> netlify.toml
    echo to = "/.netlify/functions/telemetry" >> netlify.toml
    echo status = 200 >> netlify.toml
    echo force = true >> netlify.toml
    echo [[redirects]] >> netlify.toml
    echo from = "/report-error" >> netlify.toml
    echo to = "/.netlify/functions/error-reporting" >> netlify.toml
    echo status = 200 >> netlify.toml
    echo force = true >> netlify.toml
    echo Created default netlify.toml.
)

IF NOT EXIST "server.js" (
    echo ERROR: server.js is missing.
    exit /b 1
)

IF NOT EXIST "clients.json" (
    echo ERROR: clients.json is missing.
    exit /b 1
)

REM Check for necessary directories
IF NOT EXIST "dist" (
    echo Creating dist directory...
    mkdir dist
)

IF NOT EXIST "src" (
    echo Creating src directory...
    mkdir src
    echo Creating default index.js...
    echo console.log('Hello, world!'); > src/index.js
    echo Created default index.js in src directory.
)

echo Installing dependencies...
npm install

if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies.
    exit /b %errorlevel%
)

echo Building the project...
npm run build

if %errorlevel% neq 0 (
    echo Error: Failed to build the project.
    exit /b %errorlevel%
)

echo Starting the server...
npm start

if %errorlevel% neq 0 (
    echo Error: Failed to start the server.
    exit /b %errorlevel%
)