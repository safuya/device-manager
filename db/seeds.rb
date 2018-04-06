admin = Group.create(name: 'admin', privilege: 'admin')
User.create(name: 'Administrator',
            username: 'admin',
            email: 'admin@temp.com',
            password: 'Ch@ngeM3now',
            group: admin)
