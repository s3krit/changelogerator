
{% for commit in changes %}
    ****
        {%- if commit.meta and commit.meta is containing("C") %}
            we have a C
            {{commit.commit}}: {{ commit.foo | json_encode() }}
        {% endif -%}

        {%- if commit.meta and commit.meta is containing("C") and commit.meta.C.value == 7 %}
            we have a C7
            {{commit.commit}}: {{ commit.foo | json_encode() }}
        {% endif -%}

{% endfor %}
