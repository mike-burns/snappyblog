function eventHandler(e) {
  e.on("article_id", function(payload) {
    $('ul#event-alerts').
      append('<li>An article has been created. <a href="/articles/'+payload+'">Jump to it</a> now if you wish.</li>');
  });
}
