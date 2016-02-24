pjax_config_page("new_account/realws", function(){
  return {
    onLoad: function() {
      Content.populate();
      AccountOpening.redirectCookie();
      handle_residence_state_ws();
      if (page.client.residence) {
        BinarySocket.send({landing_company: page.client.residence});
      }
      BinarySocket.send({get_settings:1});
      BinarySocket.send({residence_list:1});
      $('#real-form').submit(function(evt) {
        evt.preventDefault();
        if (RealAccOpeningUI.checkValidity()){
          BinarySocket.init({
            onmessage: function(msg){
              var response = JSON.parse(msg.data);
              if (response) {
                if (response.msg_type === 'new_account_real'){
                  AccountOpening.handler(response, response.new_account_real);
                }
              }
            }
          });
        }
      });
    }
  };
});
