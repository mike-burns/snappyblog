function handle(payload) {
  if (payload[0] == "article_id") {
    $('ul#event-alerts').
      append('<li>An article has been created. <a href="/articles/'+payload[1]+'">Jump to it</a> now if you wish.</li>');
  }
}
