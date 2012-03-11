function eventHandler(e) {
  e.on("article_id", function(payload) {
    $('ul#event-alerts').
      append('<li>An article has been created. <a href="/articles/'+
        payload+'">Jump to it</a> now if you wish.</li>');
    $('.throbber').last().remove();
  });

  e.on("invalid_article", function(payload) {
    $('ul#event-alerts').
      append('<li>An article has an error. <a href="/articles/new?json='+
        escape(JSON.stringify(payload))+
        '">Jump to it</a> now if you wish.</li>');
    $('.throbber').last().remove();
  });
}
