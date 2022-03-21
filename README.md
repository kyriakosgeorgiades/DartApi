# Table of contents

- [General info](#general-info)
- [Setup](#setup)

## General Info

This is the API for the mobile development course using dart. The API and MySQL server are both hosted on the cloud so there is no need for local configuration other than the configuration settings of the database connection. Due to this being a coursework and there is a chance the project would be run the `.env` file is included. The API is hosted on <https://games-reviews-coursework.herokuapp.com>

## Setup

git clone <https://github.coventry.ac.uk/7052CEM-2122/georgiadek-sem2-api.git>
Install the plugin on Visual studio code "Dart". Install MySQL on your device if you want to local version instead of the cloud one. Once the project has been clone run:

```powershell
cd georgiadek-sem2-api
dart pub get
dart run ./server.dart -> This is not required as its run on the cloud. Use it for local testing
```
