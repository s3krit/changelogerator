{%- import "change.md" as m_c -%}
{%- import "upgrade.md" as m_u -%}
{%- set changes =  polkadot.changes | concat(with=substrate.changes) -%}

# {{ env.REPO | capitalize }} {{ env.REF2 }}
This release contains the changes between {{ env.REF1 }} and {{ env.REF2 }}.

{# {%- set to_ignore = changes | filter(attribute="meta.B.value", value=0) %} #}
{# changes: {{ changes | length }} - {{ to_ignore | length }} silent #}

{%- if env.PRE_RELEASE and env.PRE_RELEASE == "true" -%}
<hr/>
⚠️ This version is a pre-release ⚠️
<hr/>
{%- endif -%}

{# --------------------------- #}
{% if polkadot.meta.C.max >= 3 %}
## Priority Upgrade:
    {%- set_global max_upgrade_prio = 0 -%}
    {%- for c in changes | sort(attribute="meta.C.value") | reverse -%}

    {%- if c.meta.C and c.meta.B %}
        {%- if c.meta.C.value >= 5 and c.meta.B.value != 7 %}
            {# We search for the max_upgrade_prio prio #}
            {%- if c.meta.C.value > max_upgrade_prio %}
                {%- set_global max_upgrade_prio = c.meta.C.value -%}
            {%- endif %}
- {{ m_c::change(c=c) }}
        {%- endif -%}
    {%- endif -%}
    {%- endfor -%}
{%- endif %}

{{ m_u::upgrade(priority=5) }}

{# --------------------------- #}
## Runtimes

{%- for runtime in srtool %}
- {{ runtime.name }}:
    - Metadata: `V{{runtime.data.runtimes.compressed.subwasm.metadata_version }}`
    - Size: `{{runtime.data.runtimes.compressed.subwasm.size | filesizeformat }}`
    - Version: `{{runtime.data.runtimes.compressed.subwasm.core_version }}`
    - Proposal hash: `{{runtime.data.runtimes.compressed.subwasm.proposal_hash }}`
{% endfor %}

{# --------------------------- #}
## Rust compiler version

This release was tested against the following versions of `rustc`. Other versions may work.

- Rust Stable: {{ env.RUST_STABLE }}
- Rust Nightly: {{ env.RUST_NIGHTLY }}

{# B5 #}
{# --------------------------- #}
## Client Changes
{% for c in changes | sort(attribute="meta.C.value") | reverse -%}
{%- if c.meta.B and c.meta.B.value == 5 -%}
{%- if not c.title is containing("ompanion") -%} {# Exclude companions #}
- {{ m_c::change(c=c) }}
{% endif -%}
{% endif -%}
{%- endfor -%}

{# B7 #}
## Runtime Changes
{% for c in changes | sort(attribute="meta.C.value") | reverse -%}
{%- if c.meta.B and c.meta.B.value == 7 -%}
{%- if not c.title is containing("ompanion") -%} {# Exclude companions #}
- {{ m_c::change(c=c) }}
{% endif -%}
{% endif -%}
{%- endfor -%}

{# B1 #}
## Other Changes
{% for c in changes | sort(attribute="meta.C.value") | reverse -%}
{%- if c.meta.B and c.meta.B.value == 1 -%}
{%- if not c.title is containing("ompanion") -%} {# Exclude companions #}
- {{ m_c::change(c=c) }}
{% endif -%}
{% endif -%}
{%- endfor -%}
