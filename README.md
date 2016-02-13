
Priorities
===========

A text message based priority tracker built around the Twilio API.

The goal is to give you information about where you're spending your focus.

We have a finite amount of concentration in a day, and where we spend it matters.

This project in particular isn't about tracking time. There are a lot of good
apps for that.

But since I can spend an hour in traffic or on the subway concentrating hard on
solving a problem, or daydreaming about butterflies, or studying for a test,
I would like to track what I'm concentrating on, regardless of the time it takes.

It is absolutely 100% guesstimation, since I don't really know of a way I could
actually track my concious thought.

But it's kind of fun to try.

So this will collect daily samples of approximations of what you were concentrating
on in a day, and give you the average on command.

# USAGE

It will send you a text message with a list of projects you've setup, like:

```
Please rank the following projects:

a: Project A
b: Project B
c: Project C
```

And you respond with where you spent your time that day, like:

```
ab    | Divided your time equally between projects A and B
aab   | Spend 66% of your time on project A, and 33% on B
ac    | Divided equally between A and C

# You can get as complicated as you want, your projects will be marked as the
# percentage of the string their assigned character takes up:

aabbc | 40% A, 40% B, 20% C

# Order doesn't matter:

aac is the same as caa.

```

If you just send that, you will receive a text back asking if you worked a full
day or not. You can respond with a number 1-9 or a float (0.1-0.9). The percentages
marked for your projects will be multiplied by that, and it will be reflected in
your day count.

You can also specify a day modifier in your original checkin, like so:

```
ab 5      | Divided your time equally between projects A and B, but you worked a half day.
aab 0.5   | Spend 66% of your time on project A, and 33% on B, working a half day.
ac  7     | Divided equally between A and C, worked most of a day.
```

### Viewing stats

is as easy as sending `!stats`. you'll get a message back like:

```
Your priorities are:

75.00% : Project A
25.00% : Project B
0.00% : Project C
```

Because of rounding and weird percentages, those numbers might not add up to
100%, which is an outcome I'm find with. If you aren't, submit a pull request.

And yes, the formatting is off. And it's infuriating. But my messaging app
doesn't use fixed width fonts, so it's off no matter what I do.

### Getting help.

send `!help` for a list of commands, or `!help <command>` for help with a
specific command.

# SETUP

You need to specify the ENV vars in `config/initializers/twilio.rb`

There's currently 0 web frontend supplied by the app.

You also need to setup a heroku scheduled job that runs

```
bundle exec rake environment send_checkins
```

On a daily timer whenever you want to be reminded.
