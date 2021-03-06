ActiveAdmin.register_page "Dashboard" do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end

  # section "Your Cases", :priority => 1 do
  #   table(:class => "birds_list") do 
  #     current_user.updated_birds.collect do |b|
  #       tr(:id => "bird_#{b.id}")do
  #         td(:width=>"25%") do
  #           div(:style=>"height:20px") do 
  #             link_to(image_tag(b.logo.asset.url(:sq300),:height=>"20px"), admin_bird_path(b)) unless b.logo.nil?
  #           end
  #         end
  #         td b.name
  #       end
  #     end
  #   end
  # end    
  
  # section "Recently Updated", :priority => 2 do
  #   table(:class => "birds_list") do 
  #     Bird.recently_updated(10).collect do |b|
  #       tr(:id => "bird_#{b.id}")do
  #         td(:width=>"25%") do
  #           div(:style=>"height:20px") do 
  #             link_to(image_tag(b.logo.asset.url(:sq100),:height=>"20px"), admin_bird_path(b)) unless b.logo.nil?
  #           end
  #         end
  #         td b.name
  #       end
  #     end
  #   end
  # end
  

  
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
