# Changelog-erator :)

This utility is written in Ruby. It uses the Octokit gem to connect to:
- connect to Github
- retrieve the list of changes between 2 references

While 0.x versions were rather specific to the [Polkadot](https://github.com/paritytech/polkadot) repository, those limitations have been removed starting with 0.9.x versions.

The only requirement if you want to benefit from filtering labels in a better way that just comparing label names if to name your labels using the following generic pattern as see [here](https://github.com/paritytech/polkadot/labels):

`<letter><number(s)>-<arbitrary text>`

For instance:

- `B0-Silent 😎`
- `C1-Important ❗️`

Each of your issues or PR can have any number of labels but you should avoid having multiple labels of the same category. For instance, you do not want to have both `B0` and `B7`.

Running the `changelogerator` will fetch all your changes from Github. You should set a value for the ENV `GITHUB_TOKEN` if you want to avoid being rate limited.

The produce json will be formatted as:

```jsonc
{
    "polkadot": {
        "meta": { // top-level metadata which aggregates the info for .changes[].meta
            "C": {
                "min": 1,
                "max": 1,
                "count": 1
            },
            "D": {
                "min": 2,
                "max": 2,
                "count": 1
            }
        },
        "repository": {
          /*
            Includes the fields from the GitHub Repositories REST API
            See https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#get-a-repository
          */
        },
        "changes": [
            /*
            Each entry corresponds to a pull request with the fields from the GitHub PR Rest API
            See https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28#get-a-pull-request
            In addition to the API fields, each entry has a "meta" field with
            information computed from its labels.
            */
            {
                "meta": {
                    "C": {
                        "C1": {
                          "value": 1,
                          "text": "needs-audit"
                        },
                        "agg": {
                          "min": 1,
                          "max": 1,
                          "count": 1
                        }
                    },
                    "D": {
                        "D2": {
                          "value": 2,
                          "text": "runtime"
                        },
                        "agg": {
                          "min": 2,
                          "max": 2,
                          "count": 1
                        }
                    }
                }
                // ... other fields from the REST API
            }
        ]
    }
}
```

The produced json output can then easily reprocessed into a beautiful changelog using tools such as [`tera`](https://github.com/chevdor/tera-cli).

## Testing

Some of the tests fetch data from GitHub. In case you do not have a
`$GITHUB_TOKEN` or simply do not wish to run them, set `GITHUB_TOKEN=disabled`
in your environment variables.

## Usage

You can check out the [tests](./test) to see it in action or query the help:

```
$ changelogerator --help

  Changelogerator helps you generate a template friendly context made of the changes
  between 2 references on your Github project.

  Usage:
  changelogerator [options]
    -v, --[no-]verbose               Run verbosely
    -f, --from=FROM                  From Ref.
    -t, --to=TO                      To Ref.
    -p, --[no-]prefix                Add (or not) a prefix for the repo
    -h, --help                       Prints this help
```

The key point to generate a custom changelog is to **slurp** all the json you need into a single one that can then be passed as context to your favorite templating engine.

Here is an example:

```
jq \
    --slurpfile srtool_kusama kusama-srtool-digest.json \
    --slurpfile srtool_polkadot polkadot-srtool-digest.json \
    --slurpfile polkadot polkadot.json \
    --slurpfile substrate substrate.json \
    -n '{
        polkadot: $polkadot[0],
        substrate: $substrate[0],
        srtool: [
            { name: "kusama", data: $srtool_kusama[0] },
            { name: "polkadot", data: $srtool_polkadot[0] }
        ] }' | tee context.json
```
