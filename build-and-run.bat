@echo off
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