import React from "react";
import Card from "react-bootstrap/Card";
import BounceLoader from "react-spinners/BounceLoader";
import Sharepopup from "./Sharepopup.js";
import queryString from "query-string";
import Row from "react-bootstrap/Row";
import Container from "react-bootstrap/Container";
import Col from "react-bootstrap/Col";
import TextTruncate from 'react-text-truncate'
import Badge from 'react-bootstrap/Badge'


import _ from "lodash";
var results1 = [];
var results2 = [];
export default class QuerySearch extends React.Component {
  state = { resultsNY: [], isLoading: true, resultsGa: [], queryValue: null };
  async componentWillReceiveProps(props) {
    const query = queryString.parse(props.location.search).q;
    this.setState({ queryValue: query });
    this.setState({ isLoading: true });
    fetch(
      "https://mustoori.azurewebsites.net/keywordg?id=" +
        query 
    ).then(res =>{return res.json()})
    .then(data =>{
        results1 = data;
        this.setState({ resultsGa: results1 });
        
    }
    )
   
    fetch(
      "https://mustoori.azurewebsites.net/keywordny?id=" +
        query 
    ).then(res =>{return res.json()})
    .then(data =>{
        results2 = data;
        this.setState({ resultsNY: results2 });
        this.setState({ isLoading: false });
    }
    )

  }
  handleNYChange = (id, section) => {
    this.props.history.push("/article?id=" + id);
  };
  handleGaChange = (id, section) => {
    this.props.history.push("/article?id=" + id);
  };

  handleEventChange = function (e) {
    e.stopPropagation();
    e.stopPropagation();
  };

  async componentDidMount() {
  const query = queryString.parse(this.props.location.search).q;
    this.setState({ queryValue: query });
    this.setState({ isLoading: true });
    fetch(
      "https://mustoori.azurewebsites.net/keywordg?id=" +
        query 
    ).then(res =>{return res.json()})
    .then(data =>{
        results1 = data;
        this.setState({ resultsGa: results1 });
        
    }
    )
   
    fetch(
      "https://mustoori.azurewebsites.net/keywordny?id=" +
        query 
    ).then(res =>{return res.json()})
    .then(data =>{
        results2 = data;
        this.setState({ resultsNY: results2 });
        this.setState({ isLoading: false });
    }
    )

  }

  render() {
  
    if (!this.state.isLoading) {
      let cardItem = [];
      let ga;
      let ny;
      if(results2.response !=null){
       ny = results2.response.docs;
      }
      if(results1.response!=null){
      ga = results1.response.results;
      }
      let j;
      let k;
      let i1;
      let i2;
      if (ny != null && ny.length > 5 && ga != null && ga.length > 5) {
        i1 = 5;
        i2 = 5;
      } else if (ny != null && ny.length > 5 && ga != null && ga.length < 5) {
        j = ny.length;
        k = ga.length;
        if (j + k >= 10) {
          i1 = 10 - ga.length;
          i2 = ga.length;
        } else {
          i1 = ny.length;
          i2 = ga.length;
        }
      } else if (ny != null && ny.length < 5 && ga != null && ga.length > 5) {
        j = ny.length;
        k = ga.length;
        if (j + k >= 10) {
          i2 = 10 - i1;
          i1 = ny.length;
        } else {
          i1 = ny.length;
          i2 = ga.length;
        }
      } else {
        if(ny!=null){
        j = ny.length;
        }else{
          j=0
        }
        if(ga!=null){
        k = ga.length;
        }else{
          k=0
        }
        i1 = j;
        i2 = k;
      }
      if (ny != null) {
        for (var i = 0; i < i1; i++) {
          let result = ny[i];
          let section = result.news_desk;
          let mainSection;
          let divStyle = {};
          if(section != null && section != "None"){
            section = section.toLowerCase()
          if (section == "business") {
            divStyle = {
              backgroundColor: "deepskyblue",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              textAlign: "right",
              
            };
            mainSection = "BUSINESS";
          } else if (section == "world") {
            divStyle = {
              backgroundColor: "blueviolet",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            mainSection = "WORLD";
          } else if (section == "sports") {
            divStyle = {
              backgroundColor: "gold",
              color: "black",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            mainSection = "SPORTS";
          } else if (section == "technology") {
            divStyle = {
              backgroundColor: "yellowgreen",
              color: "black",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            mainSection = "TECHNOLOGY";
          } else if (section == "politics") {
            mainSection = "POLITICS";
            divStyle = {
              backgroundColor: "darkcyan",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
          } else {
            divStyle = {
              backgroundColor: "grey",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            if(section!=null){
            mainSection = section.toUpperCase();
            }
          }}
          let date = ""
          if(result.pub_date!=null){
            date = result.pub_date.split("T")[0];
          }
          let url;
          if (result.multimedia != null) {
            for (var media of result.multimedia) {
              if (media.url != null && media.width >= 2000) {
                url = "http://www.nytimes.com/" + media.url;
                break;
              }
            }
            if (url == null) {
              url =
                "https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg";
            }
          } else {
            url =
              "https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg";
          }
          let title = "";
          if (result.headline != null && result.headline.main != null) {
            title = result.headline.main;
          }

          let webU = result.web_url;
          cardItem.push(
            <Col
              onClick={() => this.handleNYChange(result.web_url)}
              style={{ paddingLeft: "0px" }}
            >
              <div
                style={{
                  marginRight: "0.5%",
                  marginTop: "0px",
                  marginBottom: "1%",
                }}
              >
                <Card
                  style={{
                    boxShadow: "4px 4px 8px 4px rgba(192,192,192,0.6)",
                    margin: "2% ",
                    width: "100%",
                    padding: "4%",
                  }}
                >
                  <Card.Title
                    style={{
                      textAlign: "left",
                      paddingBottom: "2%",
                      fontSize: "15px",
                      fontStyle: 'italic',
                      fontWeight :'bold'

                    }}
                  >
                  <span style={{marginLeft:'2%'}}>
                     <TextTruncate  element="span" line={2} truncateText="…" text={title} >
                     
                      </TextTruncate>
                      <span onClick={this.handleEventChange}>
                        <Sharepopup title={title} url={result.web_url} />
                      </span>
                      
                    </span>
                  </Card.Title>
                  <div
                    className="img"
                    style={{
                      width: "100%",
                      border: "1px solid  lightgrey",
                      padding: "1%",
                    }}
                  >
                    <Card.Img src={url} style={{ width: "100%" }}></Card.Img>
                  </div>
                  <Card.Text>
                    <div
                      style={{
                        display: "flex",
                        width: "100%",
                        paddingTop: "5%",
                      }}
                    >
                      <Container fluid>
                      <Row >
                        <Col>
                        <Card.Text style={{ fontSize: "15px" }}>
                          <i>{date}</i>
                        </Card.Text>
                        </Col>
                      <Col style = {{textAlign : "end",marginTop :"1%",paddingRight :'0px'}}>
                        <Badge style={divStyle}>{mainSection}</Badge>
                      </Col>
                    </Row>
                    </Container>
                    </div>
                  </Card.Text>
                </Card>
              </div>
            </Col>
          );
        }
      }
      if (ga != null) {
        for (var i = 0; i < i2; i++) {
          let result = ga[i];
          let section = result.sectionId;
          let mainSection;
          let divStyle = {};
          if(section != null &&  section != "None"){
            section = section.toLowerCase()
          if (section == "business") {
            divStyle = {
              backgroundColor: "deepskyblue",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              textAlign: "right",
              
            };
            mainSection = "BUSINESS";
          } else if (section == "world") {
            divStyle = {
              backgroundColor: "blueviolet",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            mainSection = "WORLD";
          } else if (section == "sport") {
            divStyle = {
              backgroundColor: "gold",
              color: "black",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            mainSection = section.toUpperCase();
          } else if (section == "technology") {
            divStyle = {
              backgroundColor: "yellowgreen",
              color: "black",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
            mainSection = "TECHNOLOGY";
          } else if (section == "politics") {
            mainSection = "POLITICS";
            divStyle = {
              backgroundColor: "darkcyan",
              color: "white",
              marginRight: "auto",
              paddingLeft: "0.4em",
              paddingRight: "0.4em",
              fontWeight: "bold",
              borderRadius: "5px",
              fontSize: "130%",
              
            };
          } else {
            
            if(section!=null){
              mainSection = section.toUpperCase();
              }

   
                divStyle = {
                    backgroundColor: "grey",
                    color: "white",
                    marginRight: '0.2em',
                    paddingLeft: '0.4em',
                    paddingRight: '0.4em',
                    fontWeight: "bold",
                    borderRadius: "5px",
                    fontSize: '130%',
                    textAlign :'center'
                }
               
        }}
          let date = ""
          if(result.webPublicationDate!=null){
            date = result.webPublicationDate.split("T")[0];
          }
          let url;
          if (
            result.blocks != null &&
            result.blocks.main != null &&
            result.blocks.main.elements != null &&
            result.blocks.main.elements[0] != null &&
            result.blocks.main.elements[0].assets != null &&
            result.blocks.main.elements[0].assets[
              result.blocks.main.elements[0].assets.length - 1
            ] != null &&
            result.blocks.main.elements[0].assets[
              result.blocks.main.elements[0].assets.length - 1
            ].file != null
          ) {
            url =
              result.blocks.main.elements[0].assets[
                result.blocks.main.elements[0].assets.length - 1
              ].file;
          } else {
            url =
              "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png";
          }
          cardItem.push(
            <Col
              onClick={() => this.handleGaChange(result.id)}
              style={{ paddingLeft: "0px" }}
            >
              <div
                style={{
                  marginRight: "0.5%",
                  marginTop: "0px",
                  marginBottom: "1%",
                }}
              >
                <Card
                  style={{
                    boxShadow: "4px 4px 8px 4px rgba(192,192,192,0.6)",
                    margin: "2% ",
                    width: "100%",
                    padding: "4%",
                  }}
                >
                  <Card.Title
                    style={{
                      textAlign: "left",
                      paddingBottom: "2%",
                      fontSize: "15px",
                      fontStyle: 'italic',
                      fontWeight :'bold'

                    }}
                  >
                  <span style ={{marginLeft :'2%'}}>
                     <TextTruncate  element="span" line={2} truncateText="…" text={result.webTitle} >
                     
                      </TextTruncate>
                      <span onClick={this.handleEventChange}>
                        <Sharepopup title={result.webTitle} url={result.webUrl} />
                      </span>
                      
                    </span>
                  </Card.Title>
                  <div
                    className="img"
                    style={{
                      width: "100%",
                      margin: "0px",
                      border: "1px solid  lightgrey",
                      padding: "1%",
                    }}
                  >
                    <Card.Img src={url} style={{ width: "100%" }}></Card.Img>
                  </div>
                  <Card.Text>
                    <div
                      style={{
                        display: "flex",
                        width: "100%",
                        paddingTop: "5%",
                      }}
                    >
                      <Container fluid>
                      <Row >
                        <Col>
                        <Card.Text style={{ fontSize: "15px" }}>
                          <i>{date}</i>
                        </Card.Text>
                        </Col>
                      <Col style = {{textAlign : "end",marginTop :"1%",paddingRight :'0px'}}>
                        <Badge style={divStyle}>{mainSection}</Badge>
                      </Col>
                    </Row>
                    </Container>
                    </div>
                  </Card.Text>
                </Card>
              </div>
            </Col>
          );
        }
      }

      return (
        <div style={{ margin: "1%" }}>
          <Container fluid>
            <div style={{ fontWeight: "bold", fontSize: "21px" }}>Results</div>
            <Row xs={1} lg={3} sm={1} md={2} xl={4}>
              {cardItem}
            </Row>
          </Container>
        </div>
      );
    } else {
      return (
        <center>
          <div style={{ marginTop: "20%" }}>
            <BounceLoader size="3.5em" color="darkblue" />
            <h3>Loading</h3>
          </div>
        </center>
      );
    }
  }
}
