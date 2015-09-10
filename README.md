# Desperado

*Desperado* is a framework for league software for Android: Netrunner
using Ruby on Rails

## Deploying a new instance

- Sign up for free Heroku account  
https://signup.heroku.com  
Heroku's free option allows you to have 18 hours uptime in any 24 hour period.
Heroku has a paid option if you want higher uptime, or custom domains.

- Download the Heroku Toolbelt  
https://toolbelt.heroku.com

- Clone repo
```
git clone git@github.com:muyjohno/desperado.git
cd desperado
```

- Login to Heroku
```
heroku login
```

- Create Heroku instance
```
heroku create
```

- Set up instance
```
git push heroku master
heroku run rake db:migrate
heroku run rake db:seed
heroku ps:scale web=1
```

- Open instance in browser
```
heroku open
```

- This is now your own private version of this software so feel free to log in
and start using it ("Jack in" link in the footer). The default log in is "admin"
as username and password. You should change the password to something more secure
immediately.  
You can give out this URL to your players (or customise it through the Heroku panel).

## Applying updates

Once the instance is up, updates can be applied like so

- Get updates
```
git pull
```

- Push updates to instance
```
git push heroku master
heroku run rake db:migrate
```
Your instance should now have the latest updates. (No data should be lost during updates.)
