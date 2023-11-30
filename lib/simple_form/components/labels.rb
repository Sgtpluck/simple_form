# frozen_string_literal: true

module SimpleForm
  module Components
    module Labels
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def translate_required_html
          I18n.t(:"required.html", scope: i18n_scope, default:
            %(<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr>))
        end

        def translate_required_text
          I18n.t(:"required.text", scope: i18n_scope, default: 'required')
        end

        def translate_required_mark
          I18n.t(:"required.mark", scope: i18n_scope, default: '*')
        end

        private

        def i18n_scope
          SimpleForm.i18n_scope
        end
      end

      def label(wrapper_options = nil)
        label_options = merge_wrapper_options(label_html_options, wrapper_options)

        if generate_label_for_attribute?
          @builder.label(label_target, label_text, label_options)
        else
          template.label_tag(nil, label_text, label_options)
        end
      end

      def label_text(_wrapper_options = nil)
        label_text = options[:label_text] || SimpleForm.label_text
        label_text.call(html_escape(raw_label_text), required_label_text, options[:label].present?).strip.html_safe
      end

      def label_target
        attribute_name
      end

      def label_html_options
        label_html_classes = SimpleForm.additional_classes_for(:label) do
          [input_type, required_class, disabled_class, SimpleForm.label_class].compact
        end

        label_options = html_options_for(:label, label_html_classes)
        label_options[:for] = options[:input_html][:id] if options.key?(:input_html) && options[:input_html].key?(:id)

        label_options
      end

      protected

      def raw_label_text # :nodoc:
        options[:label] || label_translation
      end

      # Default required text when attribute is required.
      def required_label_text # :nodoc:
        required_field? ? self.class.translate_required_html.dup : ''
      end

      # First check labels translation and then human attribute name.
      def label_translation # :nodoc:
        if SimpleForm.translate_labels && (translated_label = translate_from_namespace(:labels))
          translated_label
        elsif object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(reflection_or_attribute_name.to_s)
        else
          attribute_name.to_s.humanize
        end
      end

      def generate_label_for_attribute?
        true
      end
    end
  end
end
