# circleci-cancel-draft-pr
**An orb to check your pull request status and cancel whole CircleCI workflow which is created by commit of GitHub draft PR automatically.**

The orb is a fork of [artsy/skip-wip-ci](https://github.com/artsy/orbs/blob/master/src/skip-wip-ci/skip-wip-ci.yml). The mose part of code is base on skip-wip-ci. It just remain `check-skippable-pr` job only.

## Usage
1. Ensure that enable **Allow Uncertified Orbs** in Organization Settings.
```
Organization Settings > Security
```

2. Create **Personal API Tokens** and copy the token.
```
User Settings > Personal API Tokens
```


3. Add a envrionment variable whose **Name** is `CIRCLE_TOKEN` and **Value** is the token you copied. 
```
Project > Project Settings > Environment Variables
```

4. Go to GitHub, And add a token which contains `repo` scope.
```
GitHub > Settings > Developer Settings > Personal access tokens
```

5. Copy GitHub Personal Access Token

6. Back to CircleCI, And add a envrionment variable whose **Name** is `GITHUB_TOKEN` and **Value** is the token you just copied.

7. Use `bye-github-draft` orb to your existing project, please read: 
[Start Guide](https://circleci.com/developer/orbs/orb/whyayen/bye-github-draft#quick-start)
