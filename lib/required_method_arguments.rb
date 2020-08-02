module RequiredMethodArguments
  class RequirementsFailed < StandardError; end
  class WrongDataTypeError < StandardError; end
  class NoBindingError < StandardError; end

  def required!(caller_binding, params)
    raise NoBindingError.new("No binding passed for method using required!") unless caller_binding.is_a? Binding
    caller_method = caller_locations(1,1).first.label
    arguments = _method_attributes(caller_binding, caller_method, params)
    evaluations = []
    arguments.each do |param_name, param_details|
      evaluations << _validate_param(param_name, param_details)
    end
    evaluations.compact!
    return if evaluations.empty?
    raise RequirementsFailed.new(_build_failure_error(evaluations))
  end

  private def _build_failure_error(evaluations)
    evaluations_formatted = evaluations.inject("") do |final_string, evaluation|
      "#{final_string} #{evaluation.class}: #{evaluation.message}\n"
    end
    "Requirements failed with the following errors: \n#{evaluations_formatted}"
  end

  private def _validate_param(param_name, param_details)
    param_value = param_details[:value]
    param_constraint = param_details[:constraint]
    if param_details[:required]
      return if param_constraint.nil?
      unless _requirement_passed?(param_value, param_constraint, param_name)
        _build_required_param_error(param_name, param_constraint)
      end
    else
      return if param_value.nil? || param_constraint.nil?
      unless _requirement_passed?(param_value, param_constraint, param_name)
        _optional_param_error(param_name, param_constraint)
      end
    end
  end

  private def _requirement_passed?(param_value, param_constraint, param_name)
    if param_constraint.is_a? Proc
      param_constraint.call(param_value, param_name)
    elsif param_constraint.is_a? Symbol
      public_send(param_constraint, param_value, param_name)
    else
      param_value.is_a?(param_constraint)
    end
  end

  private def _build_required_param_error(param_name, param_constraint)
    if param_constraint.is_a?(Proc) || param_constraint.is_a?(Symbol)
      message = "#{param_name} failed required validation it does not meet set constraint"
    else
      message = "#{param_name} failed required validation as it is not off type #{param_constraint}"
    end
    WrongDataTypeError.new(message)
  end

  private def _optional_param_error(param_name, param_constraint)
    if param_constraint.is_a?(Proc) || param_constraint.is_a?(Symbol)
      message = "#{param_name} failed required validation it does not meet set constraint"
    else
      message = "#{param_name} failed optional param validation as it is not off type #{param_constraint} or set to nil"
    end
    WrongDataTypeError.new(message)
  end

  private def _method_attributes(method_binding, method_name, constraints)
    method(method_name).parameters.each_with_object({}) do |parameter, attributes|
      required_or_optional = parameter.first
      name = parameter.last
      attributes[name] = {
        required: (required_or_optional == :req),
        value: method_binding.local_variable_get(name),
        constraint: constraints.dig(name)
      }
    end
  end
end

Object.include RequiredMethodArguments
