# Changelog-erator :)

This utility is written in Ruby. It uses the [Octokit](https://github.com/octokit) gem to:
- connect to Github
- retrieve the list of changes between 2 references

While `0.x` versions were rather specific to the [Polkadot](https://github.com/paritytech/polkadot) repository, those limitations have been removed starting with `0.9.x` versions.

The only requirement if you want to benefit from filtering labels in a better way that just comparing label names if to name your labels using the following generic pattern as see [here](https://github.com/paritytech/polkadot/labels):

`<letter><number(s)>[-<arbitrary text>]`

For instance:

- `B0-Silent 😎`
- `C1-Important ❗️`
- `Z12`

Each of your issues or PR can have any number of labels. Advanced rules for labels can be defined and enforced using [ruled_labels](https://github.com/chevdor/ruled_labels).

Running `changelogerator` will fetch all the changes for a given repository from Github. You should set a value for the ENV `GITHUB_TOKEN` if you want to avoid being rate limited.

The produce json will be formatted as:

```jsonc
{
    "polkadot": {
        "meta": { // top-level metadata which aggregates the info for .changes[].meta
            "C": {
                "min": 1,
                "max": 3,
                "count": 2
            },
            "D": {
                "min": 2,
                "max": 2,
                "count": 1
            }
        },
        "repository": {
          /*
            Includes the fields from the GitHub Repositories REST API.
            See: https://docs.github.com/en/rest/repos/repos#get-a-repository
          */
        },
        "changes": [
            /*
            Each entry corresponds to a pull request with the fields from the
            GitHub PR Rest API.
            See: https://docs.github.com/en/rest/pulls/pulls#get-a-pull-request
            In addition to the API fields, each entry has a "meta" field with
            information computed from its labels.
            */
            {
                "meta": {
                    "C": {
                        "C1": { // parsed from C1-needs_audit
                          "value": 1,
                          "text": "needs_audit"
                        },
                        "C3": { // parsed from C3-urgent
                          "value": 3,
                          "text": "urgent"
                        },
                        "agg": {
                          "min": 1,   // related to the value 1 of C1
                          "max": 3,   // related to the value 3 of C3
                          "count": 2  // two C-labels were parsed (C1 and C3)
                        }
                    },
                    "D": {
                        "D2": { // parsed from D2-runtime
                          "value": 2,
                          "text": "runtime"
                        },
                        "agg": {
                          "min": 2,   // related to the value 2 of D2
                          "max": 2,   // related to the value 2 of D2
                          "count": 1  // one D-label was parsed (D2)
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
    --slurpfile foo.json \
    --slurpfile bar.json \
    -n '{
        foo: $foo[0],
        bar: $bar[0],
        foobar: [
            { age: 12 },
            { name: "bob" }
        ] }' | tee context.json
```

## Dev notes

- install: `bundle install`
- test: `rake test` (some of the test appear to be UN responding for a good minute, see how to set `GITHUB_TOKEN` above to speed things up)
- run single test: `ruby -I test test/test_with_token.rb -n test_polkadot_1_commit`
- linting/formatting: `rubocop`
