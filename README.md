# Table of contents

- [General info](#general-info)
- [Setup](#setup)
- [Methods](#methods)

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

## Methods

### Users

============================================================================================================

`POST` <https://games-reviews-coursework.herokuapp.com/users> *Register new user*

```json
Body
{
    "username":"user1",
    "password":"p455w0rd"
}
```

`POST` <https://games-reviews-coursework.herokuapp.com/users/user> *Login user*

```json
Body
{
    "username":"user1",
    "password":"p455w0rd"
}
```

============================================================================================================

### Games

============================================================================================================

`GET` <https://games-reviews-coursework.herokuapp.com/games> *View all games*

`GET` <https://games-reviews-coursework.herokuapp.com/games/Lost%20Ark> *View a single game* ->
***Headers: Authorization : Bearer token, authcheck : needAuth***

`GET` <https://games-reviews-coursework.herokuapp.com/games/Lost%20Ark/reviews> *View reviews of a game:* ->
***Headers: Authorization : Bearer token, authcheck : needAuth***

`POST` <https://games-reviews-coursework.herokuapp.com/games> *Add a new game:* ->
***Headers: Authorization : Bearer token, authcheck : needAuth***

```json
Body
{
    "name":"Test",
    "publisher":"Coventry",
    "description":"This game is so good! I love it",
    "year":2022,
    "user_id": 123,
    "fileName": "test.png",
    "cover": "base64String"
}
```

`POST` <https://games-reviews-coursework.herokuapp.com/games/Lost%20Ark/reviews> *Add a review on a game* ->
***Headers: Authorization : Bearer token, authcheck : needAuth***

```json
Body
{
    "userID":123,
    "rate": 4,
    "description": "It was a slow game. Not that much to play do not buy it!"

}
```

============================================================================================================
