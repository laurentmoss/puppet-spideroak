puppet-spideroak
================

Little module I whipped up to try and use [spideroak](https://spideroak.com/download/referral/7fa5378979f82475136544809950361c). In I decided it wasn't what I was looking for but this module does work on ubuntu

```puppet
class { 'spideroak': 
  username => 'halkeye',
  password => 'this-is-my-password',
}
```
