# github_invaders

Fun pixel art on the Github contributions wall.

This repo allows you to add pixel art to your Github contributions wall, by letting
you use or define "generators" that'll create the pattern you like, and then creating 
fake commits on a "dummy" repo, with the correct dates to generate the image you want.

It's run by invoking a couple of rake tasks, and it's designed to be either run once 
and set the full picture on your wall, which over time will scroll left into oblivion,
or to run continuously, on a daily cron, and every day add new commits to continue
filling in your pretty picture forever.

The generators are designed to scroll your pattern if it is wider than the 53 columns
Github provides, and eventually loop if you run out of pattern, continuing forever.


## Configuration / Initial Setup / Running locally

In order to run `github_invaders`, you will need to follow several initial 
configuration steps:

1. Clone this repo to your computer.
1. `bundle install`
1. Create a Github repo to contain your `dummy_commits`. 
    - Give it a suitable `README`, just for your own reference.
    - Create a tag called `before_dummy_commits`. Make sure it's pushed to Github!
      We'll use this tag if you want to reset your wall to a new picture.
1. Create a [personal access token](https://github.com/settings/tokens).
    Give it `public_repo` scope.
    NOTE: you may not need to do this if you'll only run locally. You can remove 
    the token from the repo URL you'll configure next, and if it works, it works.  
1. Copy `.env.template` to `.env`
1. Modify the `GITHUB_DUMMY_REPO` environment variable, replacing the `your_*` bits
    with the relevant information to point to your dummy repo.
    
You're now ready to run:

1. Pick a generator you like (see the section below on which come bundled in), and 
   the right parameter if the generator requires one.
1. Test the generator by outputting to your terminal: `rake test_pattern[Generator,params]`.
    - E.g: `rake test_pattern[FilePattern,invaders]`
    - E.g: `rake test_pattern[Piano]`
    - You can also see what a wider version looks like, to test looping/etc, with a third parameter: 
    `rake test_pattern[Piano,,100]`
1. Backfill your wall with `fill_once`, passing the same parameters as for test_pattern (minus the column count):
    - `rake fill_once[FilePattern,invaders]`
    - This will clone your dummy repo to `/tmp`, generate thousands of dummy commits, and push back to Github.
    - We push the repo for every day's worth of commits, which is highly inefficient, but otherwise Github seems 
      to ignore older commits when we push too many at once.
    - Spoiler alert: This will take approximately forever.

That should do it for a first backfill.
If you want to continuously update your wall, see the "Running Continuously" section below.


## Included Generators

The repo comes with several generators and patterns pre-loaded: 

- `FilePattern`: The one you most likely want. It will load a text file that defines a pattern, 
    and put that on your wall.
  - Takes the name of the pattern as a parameter. Patterns are stored in `/patterns` in this repo.
  - To make your own custom pattern, simply add a `.txt` file to `/patterns`.
    If you are on a Mac, you can use the [Numbers spreadsheet](pixel_patterns.numbers) to play around
    with patterns easily. Set cells to 1 to turn them black. 
  - See the rules for pattern files in the [generator file comments](lib/pattern_generators/file_pattern.rb).
  - If you will be running this continuously on a server, adding the file would require forking the repo and pushing
    the new file to your own fork. Instead, you can specify a URL to anything that'll return a plain text
    file. Github's Gist is probably the easiest. Make sure to use the "raw" URL.
    E.g: `rake test_pattern[FilePattern,https://gist.githubusercontent.com/dmagliola/ec93e4b67edcf9f39ce63b235a5fea37/raw/dfcb0c10a731cc9bf525c1c72c5454cd37d67093/pacman.txt]`  
    
- `Piano`: Will render a pattern that looks like the keys of a piano. Takes no parameters.
  It's a good example of how to generate looping patterns programatically (as opposed to loading a bitmap).
  
- `Random`: This is mostly a noise generator. Days will be randomly turned on or off.
  It takes a "probability" as a parameter (0 to 1). The higher the probability, the more days will be on.
  Mostly written as the simplest possible generator, as a template to write your own. 

- `RockstarDeveloper`: When you are a Rockstar developer, every day is a full-on day!

You can also make your own generators with any logic you want (read next section).
 
If you do, or you create a nice text pattern, I'd appreciate if you'd open a PR to contribute it to the cause! 


## Defining your own generator

Generators are simple classes that map a coordinate pair to a 1/0 result, determining whether
a given pixel in the wall is on (1) or off (0).

They need two methods:

- An (optional) `initialize`: Define this if your generator takes parameters. Sadly, it can only take one 
  parameter and it's a string. This kind of sucks, but it's generally better than over-engineering it.
- `generate(point)`: Receives a `Point` struct (which just has `.x` and `.y` fields), with `y` ranging 
  from 0 to 6, and `x` from 0 to anything (the wall has 53 columns, but we support scrolling the content
  forever as the years go by), and returns 0 or 1.
  As per usual screen coordinate conventions, `(0,0)` is the top-left corner.
  
The easiest way to start with your generator is to check out the existing ones. 
[`Random`](lib/pattern_generators/rockstar.rb) is the simplest possible one that takes a parameter. 
[`Piano`](lib/pattern_generators/piano.rb) is a simple one that defines the image with logic instead of
following a bitmap.
`FilePattern` spends most of its time loading the bitmaps from file, it's probably not the most instructive.

Once you've made an attempt, test it on your console:

`rake test_pattern[Generator,params]`


## Running continuously

If you are willing to do a bit more setup, this is the recommended way to run `github_invaders`, 
as it'll automatically keep your wall always up to date.

TODO: Make this work 


## Common maintenance tasks:

### Switch drawings

If you want to keep your current wall contents, but switch graphics, just switch the generator
on your command line / cron command, ideally on a Sunday, and you'll start slowly getting the 
new drawing from now on, the old one will eventually scroll out of view.  

If you want to start over, keep reading.

### Clear your wall / reset the drawing

Your contributions wall is "add only". The only way to reset a day is to delete the dummy repo.
If you want to get rid of the picture forever, just delete your dummy repo and you're done.

If, however, you'd like to start over with a new picture: 

1. Clone your `dummy_commits` repo locally.
1. `git reset --hard before_dummy_commits` (kill all the dummy commits)
1. Delete the `dummy_commits` repo in Github.
1. Create it again, with the same name. Don't initialize with `README` / anything.
1. In your local copy of the repo, `git push -u --tags --force origin master`
1. If you have been running in continous mode in your server, reset your database.


## FAQ

- Why does this only support on/off? Why not grayscale?
    - `github_invaders` is meant to be used on your real Github account. This means
      that in addition to the dummy commits to make your wall pretty, there will 
      (hopefully) be actual contributions you're making. If we were making gradual
      amounts of commits to get different shade levels, your actual contributions 
      would generate a background radiation noise that would make your wall a mess.
      Instead, we opt for clarity, and make an obnoxious number of commits on "on"
      days, to fade your real contributions down and have a hope of making the image
      understandable.
 
 - How do I contribute my generators / patterns?
    - Please open a PR or issue in this repo. I'd love to see what you come up with.
      
