require 'pp'
module ActiveAdmin
  module Views
    module Pages
      class Base < Arbre::HTML::Document
        private
        def build_title_tag
          controller_name = params[:controller].gsub("/",".")
          action_name = params[:action]
          logger.info("--------titles.controller.#{controller_name}.#{action_name}--------")
          begin
            h2( I18n.translate!("titles.controller.#{controller_name}.#{action_name}") , :id => 'page_title')
          rescue 
            h2(title, :id => 'page_title')
          end
        end

      end
    end
  end
end
