# Changelog-erator :)

This utility is written in Ruby. It uses the Octokit gem to connect to:
- connect to Github
- retrieve the list of changes between 2 references

While 0.x versions were rather specific to the [Polkadot](https://github.com/paritytech/polkadot) repository, those limitations have been removed starting with 1.x versions.

The only requirement if you want to benefit from filtering labels in a better way that just comparing label names if to name your labels using the following generic pattern as see [here](https://github.com/paritytech/polkadot/labels):

`<letter><number(s)>-<arbitrary text>``

For instance:

- `B0-Silent 😎`
- `C1-Important ❗️`

Running the `changelogerator` will fetch all your changes from Github. You should set a value for the ENV `GITHUB_TOKEN` if you want to avoid being rate limited.

The produce json will be formatted as:
```
{
    "cl": {
        "meta": {
            "C": {
                "min": 3,
                "max": 9,
                "count": 3
            }, ...
        },
        "changes": [
            {
                "meta": {
                    "C": {
                        "value": 7
                    },
                    "D": { "value": 8 }
                },
                ... Github information ...
                "number": 1234,
                ... way more information about the commit
                ... coming from Github
            }
        ]
    }
}
```

The produced json output can then easily reprocessed into a beatiful changelog using tools such as [`tera`](https://github.com/chevdor/tera-cli).

## Usage

You can check out the [tests](./test) to see it in action.
