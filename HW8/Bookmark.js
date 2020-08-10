import Card from "react-bootstrap/Card";
import ReactTooltip from 'react-tooltip'

import React from 'react';
import SharePopupQuery from './SharePopupQuery.js';
import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'
import Col from 'react-bootstrap/Col'
import {MdDelete} from 'react-icons/md'
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import TextTruncate from 'react-text-truncate'
import Badge from 'react-bootstrap/Badge'
import { Zoom } from 'react-toastify';

toast.configure()


export default class BookMark extends React.Component{
    state ={refresh:false}
    handleChange = id => {
        this.props.history.push("/article?id=" + id);
    };
   
    componentWillMount(){
        ReactTooltip.rebuild()
        this.props.onToggle(false)
    }
    
    handleEventChange = function(e) {
        e.stopPropagation();
        e.preventDefault();
    };
    handleDeleteChange = (e,id,title1) =>{
        e.stopPropagation();
        e.preventDefault();
        toast("Removing "+ title1.title1,{
            position :"top-center",
            hideProgressBar : true,
            transition :Zoom,
            autoClose :2000
        });
        var bookMarks = []
        var changedBookMarks =[]
        var flag = false;
        if(!localStorage.getItem("cards").includes('[object Object]')){
            bookMarks = JSON.parse(localStorage.getItem("cards"))
        for(var bookmark of bookMarks){
            if(bookmark.id == id.id){
                {
                    flag = true
                }
                
            }else{
            changedBookMarks.push(bookmark)   
            } 
        }
    }
    
    this.setState({refresh : true})
    
    localStorage.setItem("cards",JSON.stringify(changedBookMarks))
   
    };



render(){
var bookMarkCards  =[]
var cardItem = []
if(localStorage.getItem("cards") != null && !localStorage.getItem("cards").includes('[object Object]') && localStorage.getItem("cards") != "[]"){
var bookMarkCards = JSON.parse(localStorage.getItem("cards"));
   for ( var result of bookMarkCards ){

       let section = result.section
       let mainSection;
       let divStyle = {

       }
       if (section == "business") {
           divStyle = {
               backgroundColor: "deepskyblue",
               color: "white",
               marginRight: '0.2em',
               paddingLeft: '0.4em',
               paddingRight: '0.4em',
               fontWeight: "bold",
               borderRadius: "5px",
               fontSize: '130%',
               textAlign: "right",
               whiteSpace: "noWrap"
           }
           mainSection = "BUSINESS"
       } else if (section == "world")   {
           divStyle = {
               backgroundColor: "blueviolet",
               color: "white",
               marginRight: '0.2em',
               paddingLeft: '0.4em',
               paddingRight: '0.4em',
               fontWeight: "bold",
               borderRadius: "5px",
               fontSize: '130%',
               whiteSpace: "noWrap"
           }
           mainSection = "WORLD"
       }
       else if (section == "sports"|| section == "sport") {
           divStyle = {
               backgroundColor: "gold",
               color: "black",
               marginRight: '0.2em',
               paddingLeft: '0.4em',
               paddingRight: '0.4em',
               fontWeight: "bold",
               borderRadius: "5px",
               fontSize: '130%',
               whiteSpace: "noWrap"

           }
           mainSection = section.toUpperCase()
       }
       else if (section == "technology") {
           divStyle = {
               backgroundColor: "yellowgreen",
               color: "black",
               marginRight: '0.2em',
               paddingLeft: '0.4em',
               paddingRight: '0.4em',
               fontWeight: "bold",
               borderRadius: "5px",
               fontSize: '130%',
               whiteSpace: "noWrap"

           }
           mainSection = "TECHNOLOGY"
       }
       else if (section == "politics") {

           mainSection = "POLITICS"
           divStyle = {
               backgroundColor: "darkcyan",
               color: "white",
               marginRight: '0.2em',
               paddingLeft: '0.4em',
               paddingRight: '0.4em',
               fontWeight: "bold",
               borderRadius: "5px",
               fontSize: '130%',
               whiteSpace: "noWrap"

           }
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
            
            
       }
        let divStyle1 ={}
        let mainSwitch = result.switch;
        if(mainSwitch == "NYTIMES"){
              divStyle1 = {
            backgroundColor: "lightGray",
            color: "white",
            marginRight: 'auto',
            paddingLeft: '0.4em',
            paddingRight: '0.4em',
            fontWeight: "bold",
            borderRadius: "5px",
            fontSize: '130%',
            whiteSpace: "noWrap"}
        }else{
            divStyle1 = {
                backgroundColor: "darkblue",
                color: "white",
                marginRight: 'auto',
                paddingLeft: '0.4em',
                paddingRight: '0.4em',
                fontWeight: "bold",
                borderRadius: "5px",
                fontSize: '130%',
                whiteSpace: "noWrap"
            }
        }
        let id = result.id
        let title1 = result.title
    cardItem.push(
        <Col onClick = {()=>this.handleChange(id)} style ={{paddingLeft:'0px'}}>
                        <div style={{marginRight: '0.5%', marginTop: '0px', marginBottom: '1%'}}>
                            <Card style={{ boxShadow: '4px 4px 8px 4px rgba(192,192,192,0.6)', margin: '2% ', width: '100%', padding: '4%' }}>
        <Card.Title
                    style={{
                      textAlign: "left",
                      paddingBottom: "2%",
                      fontSize: "15px",
                      fontStyle: 'italic',
                      fontWeight :'bold'

                    }}
                  >
                  <span>
                     <TextTruncate  element="span" line={2} truncateText="…" text={result.title} >
                     
                      </TextTruncate>
                      
                      <span style ={{marginLeft :'2%'}}>
                         <SharePopupQuery where = {result.switch} title={result.title} url={result.url} />
                                   
                                    </span>
                                    <span onClick ={(e) => {
                                            this.handleDeleteChange(e, {id},{title1})}} > 
                                    <MdDelete/>
                                    </span></span></Card.Title>
                                <div className="img" style={{  border: "1px solid thin grey" }}>
                                    <Card.Img src={result.img} style={{ width: '100%' }}></Card.Img>
                                </div>
                                <Card.Text>
                                   
                                <div style = {{paddingTop :'5%',width:"100%"}}>
                                        <span style={{ fontSize :'15px',float:'left' }}>
                                            <Card.Text><i>{result.date}</i></Card.Text>
                                        </span>
                                  <Container fluid>  
                                    <Row style ={{ float:'right',textAlign :"end"}} >
                                        <Col style={{padding:'0px',marginTop :'2%'}} >
                                        
                                            <Badge style={divStyle}>{mainSection}</Badge>
                                        </Col>
                                        <Col style={{padding :'0px',marginTop :'2%'}} >
                                            
                                            <Badge style={divStyle1}>{result.switch}</Badge>
                                        
                                        </Col>
                                        </Row>
                                        </Container>    
                            </div>                                       
                              </Card.Text>
                            </Card></div>
                    </Col>
    )
}
}else{
   return <center><div ><h2> You have no saved articles</h2></div></center>
}
return <div style = {{ margin :'1%'}}><Container fluid > <div style={{ fontWeight: 'bold', fontSize: '21px' }}>Favorites</div><Row xs={1} lg={3} sm={1} md={2} xl ={4}>{cardItem}</Row></Container></div>

}

}