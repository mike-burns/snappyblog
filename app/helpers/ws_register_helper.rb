module WsRegisterHelper
  def ws_register
    javascript_tag do
      %{
        $(document).ready(function(){
          ws_register(#{session[:connection_id].to_json}, eventHandler);
        });
      }.html_safe
    end
  end
end
