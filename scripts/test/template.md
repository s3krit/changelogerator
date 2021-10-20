sdfgfd

{{ env.USER }}


{% if meta.C.max >= 7 %}
 important sutff:

 {% for commit in changes %}
    +++++
         {% if commit.foo is containing("C7") or commit.foo is containing("C8") or commit.foo is containing("C9") %}
            - {{commit.commit}}: {{ commit.foo | json_encode() }}
        {% endif %}

         {% if commit.meta.C %}
            {% if commit.meta.C.value >= 7  %}
                # {{commit.commit}}: {{ commit.foo | json_encode() }}
            {% endif %}
        {% endif %}
{% endfor %}
{% endif%}

===========

{% for commit in changes %}
    ****
         {% if commit.foo is containing("D0") %}
            {{commit.commit}}: {{ commit.foo | json_encode() }}
        {% endif%}
{% endfor %}


1- {{ "2019-09-19T13:18:48.731Z" | date(format="%Y-%m-%d %H:%M", timezone="Europe/Berlin") }}
2- {{ "2019-09-19 13:18:48 UTC" | date(format="%Y-%m-%d %H:%M", timezone="Europe/Berlin")  }}
