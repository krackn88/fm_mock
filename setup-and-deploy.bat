@echo off
echo Setting up the project directory...

REM Check for necessary files
IF NOT EXIST "package.json" (
    echo ERROR: package.json is missing.
    exit /b 1
)

IF NOT EXIST "webpack.config.js" (
    echo ERROR: webpack.config.js is missing.
    exit /b 1
)

IF NOT EXIST "netlify.toml" (
    echo ERROR: netlify.toml is missing.
    exit /b 1
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

echo Deploying to Netlify...
netlify deploy --prod

if %errorlevel% neq 0 (
    echo Error: Failed to deploy the project.
    exit /b %errorlevel%
)