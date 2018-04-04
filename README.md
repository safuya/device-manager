# Device Manager
## Summary
This website allows you to manage devices.

## Running the Server
You must first set a session secret in your environment.
```
export session_secret='my_really_long_random_secret'
```

You can use bundle to install the required gems, and run the required
migrations.
```
bundle
rake db:migrate
```

After this, you can bring up the server with shotgun. You can seed the database
beforehand.
```
rake db:seed
shotgun
```

## Running the Tests
Run all tests using rspec.
```
rspec
```

## Installing in Production
Work in progress

## Using the Application
### Users
Anyone can request to become a user on the front page. Users must be approved
by an administrator. Each user belongs to one group. That approval process
requires for the user to be assigned to a group. A users profile can only be
edited by that user.

Passwords are required to be at least 8 characters long and have 3 of 4 of an
uppercase, lowercase, digit and symbol.

The username, name and email are required.

### Devices
Devices can only be created by administrators. They can be viewed by any
approved user. They can only be updated by an administrator.

A device has and belongs to many groups and has many users through groups.

A serial number and model are required. The serial number must be unique.

### Groups
A group has many users. A group has and belongs to many devices.

A name is required.
