const express = require("express");
const app = express();
var fetch = require("node-fetch");
var cors = require("cors");

const PORT = process.env.PORT || 3010;
app.use(cors());

app.get("/sectionsg", async (req, res) => {
  var section = req.query.section;
  if (section == "home") {
    var response = await fetch(
      "https://content.guardianapis.com/search?api-key=fd3b8d4d-698f-46d9-bc8f-c32144c8bea9&section=(sport|business|technology|politics)&show-blocks=all"
    );

    var json = await response.json();
    res.send(json);
  } else {
    var response = await fetch(
      "https://content.guardianapis.com/" +
        section +
        "?api-key=fd3b8d4d-698f-46d9-bc8f-c32144c8bea9&show-blocks=all"
    );

    var json = await response.json();
    res.send(json);
  }
});

app.get("/sectionsny", async (req, res) => {
  var section = req.query.section;
  if (section == "home") {
    var response = await fetch(
      "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=nMEpMDZejr2iCp0R11GtfGgVuWgObPzV"
    );

    var json = await response.json();
    res.send(json);
  } else {
    var response = await fetch(
      "https://api.nytimes.com/svc/topstories/v2/" +
        section +
        ".json?api-key=nMEpMDZejr2iCp0R11GtfGgVuWgObPzV"
    );
    var json = await response.json();
    res.send(json);
  }
});
app.get("/articleg", async (req, res) => {
  var id = req.query.id;
  var response = await fetch(
    "https://content.guardianapis.com/" +
      id +
      "?api-key=fd3b8d4d-698f-46d9-bc8f-c32144c8bea9&show-blocks=all"
  );
  var json = await response.json();
  res.send(json);
});

app.get("/articleny", async (req, res) => {
  var id = req.query.id;

  var response = await fetch(
    'https://api.nytimes.com/svc/search/v2/articlesearch.json?fq=web_url:("' +
      id +
      '") &api-key=nMEpMDZejr2iCp0R11GtfGgVuWgObPzV'
  );

  var json = await response.json();
  res.send(json);
});
app.get("/keywordny", async (req, res) => {
  var keyword = req.query.id;

  var response = await fetch(
    "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=" +
      keyword +
      "&api-key=nMEpMDZejr2iCp0R11GtfGgVuWgObPzV"
  );

  var json = await response.json();
  res.send(json);
});
app.get("/keywordg", async (req, res) => {
  var keyword = req.query.id;

  var response = await fetch(
    "https://content.guardianapis.com/search?q=" +
      keyword +
      "&api-key=fd3b8d4d-698f-46d9-bc8f-c32144c8bea9&show-blocks=all"
  );
  var json = await response.json();
  res.send(json);
});

app.listen(PORT);
