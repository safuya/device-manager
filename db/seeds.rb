admin = Group.create(name: 'admin', privilege: 'admin')
write = Group.create(name: 'room 210 lead', privilege: 'write')
Group.create(name: 'unused group')

Device.create(serial_number: '+084316+NQ62441787',
              model: 'hh6a',
              last_contact: '2018-03-31 10:11:00',
              last_activation: '2017-04-20 05:32:00',
              firmware_version: '5',
              groups: [admin, write])
Device.create(serial_number: '+076399+NQ51117342', model: 'hh5a')
Device.create(serial_number: '1549077609', model: 'hh3a')
Device.create(serial_number: '1528089354', model: 'hh3a')

User.create(name: 'rob',
            username: 'rob',
            email: 'rob@rob.com',
            password: 'P@ssword',
            group: admin)
User.create(name: 'jim',
            username: 'jim',
            email: 'jim@jim.com',
            password: 'P@ssw0rd',
            group: write)
User.create(name: 'jeremy',
            username: 'jeremy',
            email: 'jeremy@bt.com',
            password: 'L3tme!nn')
