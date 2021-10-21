{%- macro change(c) -%}

{%- if c.meta.C and c.meta.C.value >= 7-%}
{%- set prio = "❗️HIGH" -%}
{%- elif c.meta.C and c.meta.C.value >= 5 -%}
{%- set prio = "📣 Medium" -%}
{%- elif c.meta.C and c.meta.C.value >= 3 -%}
{%- set prio = "📌 Low" -%}
{%- else -%}
{%- set prio = "" -%}
{%- endif -%}

[`#{{c.number}}`]({{c.html_url}}) {{ prio }} - {{ c.title | capitalize }}
{%- endmacro change %}
