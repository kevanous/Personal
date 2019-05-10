# Overview

This project setup describes the basic boilerplate setup of WebdriverIO v5 / Mocha+Chai / Babel / pageObjects

## Getting started

1. Clone the repo
2. Run the command to grab latest dependencies specified in package.json

- `npm install` 

## Few options how to run the tests
To run all the tests specs in `./tests/specs/` folder. Exclusions specified in `wdio.conf.js`:
- `npm run test` 

To run the Smoke test suite. Other test suite can be added in `wdio.conf.js`:
- `npm run test -- --suite smoke` 

To run individual test spec:
- `npm run test -- --spec ./tests/specs/main.spec.js` 



## Debugging
### via VS Code debugger
1. Add a new configuration in VS Code:
```
{
      "type": "node",
      "request": "launch",
      "protocol": "inspector",
      "address": "localhost",
      "port": 5859,
      "timeout": 10000,
      "name": "WebdriverIO",
      "runtimeExecutable": "${workspaceRoot}/node_modules/.bin/wdio",
      "windows": {
        "runtimeExecutable": "${workspaceRoot}/node_modules/.bin/wdio.cmd"
      },
      "cwd": "${workspaceRoot}",
      "console": "integratedTerminal",
      // This args config runs only the file that's open and displayed
      // (e.g., a file in test/spec/):
      "args": [
        "wdio.conf.js",
        "--spec",
        "${relativeFile}",
        "--mochaOpts.timeout",
        "999999999"
        // To run a specific file, you can use:
        //"--spec", "test/specs/foo.spec.js"
      ],
      "skipFiles": [
        "lib/**/*.js"
      ],
      "sourceMaps": true
    }
```
2. Make sure the line `execArgv: ['--inspect-brk=127.0.0.1:5859']` is added to config file `wdio.conf.js`.
3. Add a breakpoint on certain line in any of the spec files.
4. Open Debug tab in VS Code (CMND + Shift + D).
5. Run the test.

### via CLI interface
1. Make sure the line `execArgv: ['--inspect-brk=127.0.0.1:5859']` is commented out in `wdio.conf.js`. This is only for VS Code debugger.
2. Add `browser.debug();` line in any test of the spec file
3. Run the test via `DEBUG=true npm run test -- --spec ./tests/specs/about.spec.js`.
DEBUG=true overwrites the default Mocha timeout so the test won't end early.
4. On the certain line the execution will stop and we can access browser instance in the terminal.
Use it to check if certain element isDisplayed(), how many elements return certain selector, etc: 
```
[0-0] › $('span=About').isDisplayed();
true
[0-0] › 
```