# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
Sinatra has been used for building out the application and all the routes.
- [x] Use ActiveRecord for storing information in a database
ActiveRecord is being used for all database records.
- [x] Include more than one model class (list of model class names e.g. User, Post, Category)
Three main model classes have been used. User, Group and Device.
- [x] Include at least one has_many relationship on your User model (x has_many y, e.g. User has_many Posts)
A group has many users. A group and device also have and belong to many of each other.
- [x] Include at least one belongs_to relationship on another model (x belongs_to y, e.g. Post belongs_to User)
A user belongs to a group.
- [x] Include user accounts
User accounts are within the user table.
- [x] Ensure that users can't modify content created by other users
Only users can modify their own profile. Only members of the administrator group can create devices.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
For the new user, the belongs to resource has routes for /sessions/apply, which is the creation. This
has been moved to a separate file because it also logs the user in, and it felt like it belongs in the
sessions. There is then an approvals page which shows all users not yet assigned a group. Once they
are assigned a group, they are then allowed into the rest of the website.
The reading, updating and destroying have all been created as standard.
There are also standard new routes provided within groups and devices. Both of these have a belongs
to relationship with each other.
- [x] Include user input validations
The presence of device serial number and model have been validated. The serial number uniqueness has
also been validated.
The presence of a group name has been validated.
The presence of a users name, username and email have been validated. Passwords have been validated to
be longer than 7 characters, and to have 3 of 4 of a lowercase, uppercase, digit and symbol.
- [x] Display validation failures to user with error message (example form URL e.g. /posts/new)
All validations provide feedback when they are not met through flash messages.
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code
The readme has a description, install instructions, a contributors guide and a link to the MIT license.
It also has a code of conduct for contributors.

Confirm
- [x] You have a large number of small Git commits
Some commits are larger than they should have been, but there are no commits that contain more
than three changes.
- [x] Your commit messages are meaningful
All commit messages have been carefully chosen.
- [x] You made the changes in a commit that relate to the commit message
All commit messages relate to the changes that have been made.
- [x] You don't include changes in a commit that aren't related to the commit message
All changes in the commits are related to their commit messages
