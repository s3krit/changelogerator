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

{% set_global hit = false %}
{%- set target = 'B1-releasenotes' -%}
{%- for pr in commits -%}
    {%- for label in pr.labels -%}
    {%- if label.name == target -%}
    {%- set_global hit = true -%}
    {%- endif -%}
    {%- endfor -%}
{%- if hit == true -%}
- {{ pr.priority.label }}: {# [#{{ pr.number }}]({{ pr.html_url }}) #} {{ pr.title }}
{% endif -%}
{% endfor -%}

{# B5-clientnoteworthy #}
## Client

{# B7-runtimenoteworthy #}
## Runtime

