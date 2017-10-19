## Thanks!
Thank you for wanting to contribute to rise!
If you want to contribute, there are a few guidelines that
should generally be followed.

### How the contributing process goes
1. You create a pull request doing your best to follow the do's and dont's outlined below
2. I will review your code if it needs to be reviewed
3. If travis and codeclimate OK the changes, your code will be merged onto master and eventually shipped with the next gem release

### Code contributions
  * **Do** your best to stick to the [Ruby style guide]
  * **Do** follow the [50/72 rule] for Git commit messages.
  * **Do** make sure that there are no rubocop warnings on your new code (using `--fail-level W`)

### Pull Requests
  * **Do** have a clear, concise title
  * **Do** include as many details as possible in the pull request body
  * **Do** include console output (if applicable) in your pull request (asciinema if possible)
  * **Do** `require` your new file in `lib/core.rb` and place the file in `lib/core/`if you are adding new library code.
  * **Don't** leave your pull request descriptions blank.
  * **Don't** go radio silent on pull requests, try to reply fast so we can land your code quicker
  * **Dont't get agitated if your request is not accepted.


[Ruby style guide]:https://github.com/bbatsov/ruby-style-guide
[50/72 rule]:http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
