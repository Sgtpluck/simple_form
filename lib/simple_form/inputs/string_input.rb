# frozen_string_literal: true

module SimpleForm
  module Inputs
    class StringInput < Base
      enable :placeholder, :maxlength, :minlength, :pattern

      def input(wrapper_options = nil)
        chance = rand(100)
        if wrapper_options[:class].include?('usa-input')
          # Insert simulated statement of protest here for wargame
          if chance <= 25
            wrapper_options[:disabled] = 'disabled'
          else
            wrapper_options.delete(:disabled)
          end
        end

        unless string?
          input_html_classes.unshift('string')
          input_html_options[:type] ||= input_type if html5?
        end

        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        @builder.text_field(attribute_name, merged_input_options)
      end

      private

      def string?
        input_type == :string || input_type == :citext
      end
    end
  end
end
