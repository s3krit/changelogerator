{%- macro upgrade(priority) -%}

{%- if priority >= 3 %}
| Low | Medium | High | Critical |
|:---:|:------:|:----:|:--------:|
|     |    ▲   |      |          |

{%- elif priority >= 5 %}
| Low | Medium | High | Critical |
|:---:|:------:|:----:|:--------:|
|     |        |   ▲  |          |
{%- elif priority >= 7 %}
| Low | Medium | High | Critical |
|:---:|:------:|:----:|:--------:|
|     |        |      |    ▲     |

{%- endif %}

{%- endmacro upgrade %}
