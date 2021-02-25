macro publicize(call_definition)
  {% klass = call_definition.receiver.id %}
  {% method = call_definition.stringify.split('.')[-1].id %}
  {% args = [] of ASTNode %}
  {% if call_definition.args %} {% args = args + call_definition.args %} {% end %}
  {% named_args = [] of ASTNode %}
  {% if call_definition.named_args %} {% named_args = named_args + call_definition.named_args %} {% end %}
  class {{klass}}
    def {{method}}{% if args.size > 0 %}({{args.join(", ")}}{% if named_args.size > 0 %}, *, {{named_args.join(", ")}}{% end %}){% end %}
      previous_def
    end
  end
end
