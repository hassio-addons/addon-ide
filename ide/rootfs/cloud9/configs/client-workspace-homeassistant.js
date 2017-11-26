
// Copyright © 2017 Franck Nijhof, Community Hass.io Add-ons.

'use strict';

module.exports = function (options) {
  delete options.runners['C (make)'];
  delete options.runners['C (simple)'];
  delete options.runners['C++ (simple)'];
  delete options.runners['CoffeeScript'];
  delete options.runners['go'];
  delete options.runners['io.js'];
  delete options.runners['Java (single-file)'];
  delete options.runners['Java (workspace)'];
  delete options.runners['Meteor'];
  delete options.runners['Mocha'];
  delete options.runners['Node.js'];
  delete options.runners['PHP (built-in web server)'];
  delete options.runners['PHP (cli)'];
  delete options.runners['Python (interactive mode)'];
  delete options.runners['Python 2'];
  delete options.runners['Python'];
  delete options.runners['Ruby on Rails'];
  delete options.runners['Ruby'];

  var config = require('./client-default')(options);
  var includes = [
  ];
  var excludes = {
    'plugins/c9.ide.collab/share/share': true,
    'plugins/c9.ide.dialog.login/login': true,
    'plugins/c9.ide.immediate': true,
    'plugins/c9.ide.installer/gui': true,
    'plugins/c9.ide.language.go/go': true,
    'plugins/c9.ide.login/login': true,
    'plugins/c9.ide.preview': true,
    'plugins/c9.ide.processlist/processlist': true,
    'plugins/c9.ide.run.build': true,
    'plugins/c9.ide.run.debug': true,
    'plugins/c9.ide.welcome/welcome': true,
  };

  config = config.concat(includes).map(function(p) {
    return (typeof p === 'string') ? { packagePath: p } : p;
  }).filter(function(p) {

    if (p.dashboardUrl && p.dashboardUrl.includes('c9.io')) {
      p.dashboardUrl = 'https://home-assistant.io/';
    }

    if (p.accountUrl && p.accountUrl.includes('c9.io')) {
      p.accountUrl = 'https://community.home-assistant.io/?u=frenck';
    }

    if (p.bashBin) {
        p.bashBin = '/bin/zsh';
    }

    switch (p.packagePath) {
      case 'plugins/c9.core/c9':
        break;

      case 'plugins/c9.ide.layout.classic/preload':
        break;

      case 'plugins/c9.core/settings':
        if (p.settings) {
          p.settings.user = {
            ace: {
              '@theme': 'ace/theme/monokai',
              '@fontFamily': 'Monaco, Menlo, Ubuntu Mono, Consolas, source-code-pro, monospace',
              '@showInvisibles': true,
              '@showLineNumbers': true,
              '@printMarginColumn': 120,
            },
            general: {
              '@preview-navigate': false,
              '@preview-tree': false,
              '@revealfile': true,
              '@skin': 'flat-light',
            },
            projecttree: {
              '@hiddenFilePattern': '*.db,*.pyc, __pycache__, .*',
              '@scope': false,
              '@showhidden': false,
            },
            tabs: {
              '@asterisk': true,
              '@show': true,
            },
            terminal: {
              '@backgroundColor': '#000000',
              '@blinking': true,
              '@foregroundColor': '#d7dde4',
              '@scrollback': 10000,
              '@selectionColor': '#97a8b6',
            },
            welcome: {
               '@first': false,
            }
          };

          p.settings.project = {
            ace: {
                '@tabSize': 2,
            },
            run: {
                configs: {
                    '@inited': true,
                    "json()": {
                        'Check configuration': {
                            'command': 'hassio homeassistant check',
                            'default': true,
                            'name': 'Check Configuration',
                            'runner': 'Shell command',
                            'toolbar': true,
                        },
                        'Restart Home Assistant': {
                            'command': 'hassio homeassistant restart',
                            'name': 'Restart Home Assistant',
                            'runner': 'Shell command',
                            'toolbar': true,
                        },                        
                    },
                },
            }
          };
        }
        break;
    }

    return !excludes[p.packagePath];
  });

  return config;
};
