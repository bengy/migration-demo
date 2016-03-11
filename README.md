## Refugee app

Link to app: [http://flucht.herokuapp.com](http://flucht.herokuapp.com)

### Install instructions MacOSX
```bash
# Deps Mac
brew install node npm

# then...
npm install -g ionic@beta

# install the dependencies.
cd frontend && npm install

# Run in dev mode
cd frontend && ionic serve --platform android
```


### Deploy as App
```bash
# Make app
cd frontend
ionic platform add ios
ionic build ios
```

### Wiki
[API-Docs](https://github.com/bengy/migration-demo/wiki)

[Heroku-Info](https://github.com/bengy/migration-demo/wiki/Heroku-Preview)
