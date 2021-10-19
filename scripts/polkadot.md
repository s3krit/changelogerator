{% set_global commits = changes[0].commits %}
# This is a test


Our changelog has {{ commits | length }} commits.



## Native runtimes

⚠️ Need a hash of runtime/version

## Rust version

This release was tested against the following versions of `rustc`. Other versions may work.

- Rust Stable: {{ env.RUST_STABLE }}
- Rust Nightly: {{ env.RUST_NIGHTLY }}

{# B1-releasenotes #}
## Changes

{#
{% set_global hit = false %}
{%- set target = 'B1-releasenotes' -%}

{%- for pr in commits -%}
    {%- for label in pr.labels -%}
        {% if pr.title is containing ("ompanion") %}
            {%- if label.name == target
                and label.name is containing("silent") -%}
                {%- set_global hit = true -%}
            {%- endif -%}
        {%- endif -%}
    {%- endfor -%}
{%- if hit == true -%}
- {{ pr.label.label }}:
     [#{{ pr.number }}]({{ pr.html_url }})
    {{ pr.title }}
{% endif -%}
{% endfor -%}
#}

{# B5-clientnoteworthy #}
## Client

{# B7-runtimenoteworthy #}
## Runtime



## TESTS

{%- for pr in commits %}
    {{ pr.labels | filter(attribute="name", value="B0-silent") | not | json_encode() }}
{%- endfor -%}