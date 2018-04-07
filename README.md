# Device Manager
## Summary
This website allows you to manage devices.

## Running the Development Server
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
Set up an AWS account. You then need to
[install](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
the AWS CLI.

Next, [install](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html)
the Elastic Beanstalk CLI.

Set up and record your session secret.

```
export session_secret=$(ruby -e "require 'sysrandom/securerandom'; puts SecureRandom.hex(64)")
echo $session_secret
```

Configure your production database. Edit the user in the seed if you want to
change the default user.

```
rake db:migrate SINATRA_ENV=production
rake db:seed
git add --all
git commit -m "deploy to production"
```

Initialize elastic beanstalk and create your environment. For the environment choose
Ruby 2.3 (Passenger Standalone).

```
eb init
eb create production -s --envvars SINATRA_ENV=production,session_secret=$session_secret
```

Visit your newly deployed website and change the username and password of the
initial user.
```
eb open
```

Future deployments can be carried out with the deploy command. Database
migrations for production must be carried out with your production session
secret. Unless you move your database to a separate EC2 instance, the database
will also be emptied on each deployment.
```
eb deploy
```

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

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/safuya/device-manager. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The code is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Device Manager project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/safuya/device-manager/blob/master/CODE_OF_CONDUCT.md).
