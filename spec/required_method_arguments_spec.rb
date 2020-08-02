RSpec.describe RequiredMethodArguments do
  it "has a version number" do
    expect(RequiredMethodArguments::VERSION).not_to be nil
  end

  describe "#required!" do
    it "throws an error when binding is not passed" do
      expect { required!(nil, argument: Integer) }.to raise_error NoBindingError
    end

    it "skips validation when constraint is not passed" do
      def test_method(x)
        required!(binding, x: nil)
      end

      expect { test_method(1) }.not_to raise_error
    end

    context "when constraint is a class" do
      def test_method_with_required_arg(x)
        required!(binding, x: String)
      end

      def test_method_with_optional_arg(x = nil)
        required!(binding, x: String)
      end

      context "and argument is required" do

        it "raises an error when requirement is not met" do
          expect { test_method_with_required_arg(1) }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end
      end

      context "and argument is optional" do

        it "raises an error when requirement is not met" do
          expect { test_method_with_required_arg(1) }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end

        it "does not raise an error when argument is nil" do
          expect { test_method_with_optional_arg }.not_to raise_error
        end
      end
    end

    context "when constraint is a Proc" do
      let(:constraint) { Proc.new { |param_value, _param_name| param_value.is_a? String } }

      def test_method_with_required_arg(x)
        required!(binding, x: constraint)
      end

      def test_method_with_optional_arg(x = nil)
        required!(binding, x: constraint)
      end

      context "and argument is required" do
        it "raises an error when requirement is not met" do
          expect { test_method_with_required_arg(1) }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end
      end

      context "and argument is optional" do

        it "raises an error when requirement is not met" do
          expect { test_method_with_required_arg(1) }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end

        it "does not raise an error when argument is nil" do
          expect { test_method_with_optional_arg }.not_to raise_error
        end
      end
    end

    context "when constraint is another method" do
      let(:method_name) { :validate_method }

      def validate_method(param_value, _param_name)
        param_value.is_a? String
      end

      def test_method_with_required_arg(x)
        required!(binding, x: method_name)
      end

      def test_method_with_optional_arg(x = nil)
        required!(binding, x: method_name)
      end

      context "and argument is required" do
        it "raises an error when requirement is not met" do
          expect { test_method_with_required_arg(1) }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end
      end

      context "and argument is optional" do
        it "raises an error when requirement is not met" do
          expect { test_method_with_optional_arg(1) }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end

        it "does not raise an error when argument is nil" do
          expect { test_method_with_optional_arg }.not_to raise_error
        end
      end
    end

    context "when multiple arguments are passed" do
      def test_method_with_required_arg(x,y)
        required!(binding, x: String, y: Integer)
      end

      def test_method_with_optional_arg(x = nil, y = nil)
        required!(binding, x: String, y: Integer)
      end

      context "and arguments are required" do
        it "raises an error when requirements are not met" do
          expect { test_method_with_required_arg(1, "2") }.to raise_error do |error|
            expect(error).to be_a RequirementsFailed
            expect(error.message.scan(/WrongDataTypeError/).count).to eq 2
          end
        end

        it "does not raise an error when requirements are met" do
          expect { test_method_with_required_arg("1",2) }.not_to raise_error
        end
      end

      context "and argument is optional" do
        it "raises an error when requirements is not met" do
          expect { test_method_with_optional_arg("1","2") }.to raise_error(RequirementsFailed, /WrongDataTypeError/)
        end

        it "does not raise an error when argument is nil" do
          expect { test_method_with_optional_arg }.not_to raise_error
        end
      end

    end
  end
end
