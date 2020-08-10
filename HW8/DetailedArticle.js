import React from 'react';
import Card from "react-bootstrap/Card";
import BounceLoader from "react-spinners/BounceLoader";
import queryString from 'query-string'
import { MdKeyboardArrowDown } from 'react-icons/md';
import { MdKeyboardArrowUp } from 'react-icons/md';
import commentBox from 'commentbox.io';
import {FaRegBookmark} from 'react-icons/fa'
import {FaBookmark} from 'react-icons/fa'
import ReactTooltip from 'react-tooltip'
import { Zoom } from 'react-toastify';

import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';



import {
    FacebookShareButton,
    TwitterShareButton,
    EmailShareButton,
    EmailIcon,
    FacebookIcon,
    TwitterIcon
} from 'react-share';


import _ from "lodash";
toast.configure()

var Scroll  = require('react-scroll');
var scroll = Scroll.animateScroll;

var results1 = []
var id = []
export default class DetailedArticle extends React.Component {
    state = { results: true, isLoading: false,results2:[]}
    async componentDidMount() {
        var response = []
        ReactTooltip.rebuild()
       
        id = queryString.parse(this.props.location.search).id
        this.setState({ isLoading: true })
       

        if(!id.includes("nytimes.com")){
        fetch(
            'https://mustoori.azurewebsites.net/articleg?id='+id
        ).then(res => {
            return res.json();

          })
          .then(data => {
              results1 = data;
            this.setState({ results2: data });
           
            this.setState({ isLoading: false })
            commentBox('5761512987688960-proj', {
                className: 'commentbox', // the class of divs to look for
                defaultBoxId: 'commentbox', // the default ID to associate to the div
                tlcParam: 'tlc', // used for identifying links to comments on your page
                backgroundColor: null, // default transparent
                textColor: null, // default black
                subtextColor: null, // default grey
                singleSignOn: null, // enables Single Sign-On (for Professional plans only)
            
                createBoxUrl(boxId, pageLocation) {
                    var comId =id;
                    if( id.includes("nytimes.com")){
                        
                        comId = id.split('com')[1]
                    }
                    pageLocation.search = comId // removes query string!
                    pageLocation.hash = boxId; // creates link to this specific Comment Box on your page
                    return comId; // return url string
                }
            });

    
          });
        
        }else if ( id.includes("nytimes.com") ){
         fetch(
                'https://mustoori.azurewebsites.net/articleny?id='+id
            ).then(res => {
                return res.json();
              })
              .then(data => {
                results1 = data;
              this.setState({ results2: data });

            this.setState({ isLoading: false })
            commentBox('5761512987688960-proj', {
                className: 'commentbox', // the class of divs to look for
                defaultBoxId: 'commentbox', // the default ID to associate to the div
                tlcParam: 'tlc', // used for identifying links to comments on your page
                backgroundColor: null, // default transparent
                textColor: null, // default black
                subtextColor: null, // default grey
                singleSignOn: null, // enables Single Sign-On (for Professional plans only)
            
                createBoxUrl(boxId, pageLocation) {
                    var comId =id;
                    if( id.includes("nytimes.com")){
                        
                        comId = id.split('com')[1]
                    }
                    pageLocation.search = comId // removes query string!
                    pageLocation.hash = boxId; // creates link to this specific Comment Box on your page
                    return comId; // return url string
                }
            });
            
            })
           
        }

        this.props.onToggle(false)
        

       
    }
    handleChange = desc => {
      
        document.getElementById("iconDown").style.display = 'none';
        document.getElementById("desc1").style.display = 'block';
        document.getElementById("iconUp").style.display = 'block';
        scroll.scrollToBottom({smooth: true})
        
    };
    handleChange1 = desc => {
        document.getElementById("desc1").style.display = 'none';
        document.getElementById("iconUp").style.display = 'none';
        document.getElementById("iconDown").style.display = 'block';
        scroll.scrollToTop({smooth: true})
    };
    bookMarkFunction = () =>{
        let bookMarks = []
        var changedBookMarks =[]
        var flag = false
        if( localStorage.getItem("cards")!= null && !localStorage.getItem("cards").includes('[object Object]')){
            bookMarks = JSON.parse(localStorage.getItem("cards"))
        for(var bookmark of bookMarks){
            if(bookmark.id == id){
                {
                    flag = true
                }
                
            }else{
            changedBookMarks.push(bookmark)  
            }  
        }}else{
            bookMarks = []
        }
        if(flag){
            this.setState({result : false})
            localStorage.setItem("cards",JSON.stringify(changedBookMarks))
            toast("Removing "+ results1.response.content.webTitle,{
                position :"top-center",
                hideProgressBar : true,
                transition :Zoom,
                autoClose: 2000, 
             
            });
        }else{
             toast("Saving "+ results1.response.content.webTitle,{
                position :"top-center",
                hideProgressBar : true, 
                transition : Zoom,
                autoClose: 2000, 
            });
            var result = results1.response.content
            var swit =""
            if(!id.includes('nytimes.com') ){
                swit = "GUARDIAN"
            }else{
                swit = "NYTIMES"
            }
            var url;
            if (result.blocks != null && result.blocks.main != null
                && result.blocks.main.elements != null && result.blocks.main.elements[0] != null && result.blocks.main.elements[0].assets != null && result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length - 1] != null && result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length - 1].file != null) {
                url = result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length - 1].file
            }
            else {
                url = 'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png'
            }
            var text = "";
            if( result.blocks != null && result.blocks.body != null && result.blocks.body[0] != null && result.blocks.body[0].bodyTextSummary!= null){
                text = result.blocks.body[0].bodyTextSummary
            }
           var sec = result.sectionId
           if(sec == null && sec =="None"){
                sec = null
           }

        bookMarks.push({
            section :sec ,
            switch : swit ,
            title : result.webTitle,
            url : result.webUrl ,
            img : url,
            id : id ,
            date : results1.response.content.webPublicationDate.split("T")[0]
        })
        
        localStorage.setItem("cards",JSON.stringify(bookMarks))
        this.setState({result : true})

    }

    }

    bookMarkNYFunction = () =>{
        let bookMarks = []
        var changedBookMarks =[]
        var flag = false
        if( localStorage.getItem("cards")!= null && !localStorage.getItem("cards").includes('[object Object]')){
            bookMarks = JSON.parse(localStorage.getItem("cards"))
        for(var bookmark of bookMarks){
            if(bookmark.id == id){
                {
                    flag = true
                }
                
            }
            else{
                changedBookMarks.push(bookmark)  
                }  
        }}else{
            bookMarks = []
        }
        if(flag){
            this.setState({result : false})
            localStorage.setItem("cards",JSON.stringify(changedBookMarks))
            toast("Removing "+ results1.response.docs[0].headline.main,{
                position :"top-center",
                hideProgressBar : true,
                transition :Zoom,
                autoClose: 2000, 
             
            });
        }else{
            toast("Saving "+ results1.response.docs[0].headline.main,{
                position :"top-center",
                hideProgressBar : true,
                transition :Zoom,
                autoClose: 2000, 
                
            });
            
            var result = results1.response.docs[0]
            var swit =""
            if(!id.includes('nytimes.com') ){
                swit = "GUARDIAN"
            }else{
                swit = "NYTIMES"
            }

            let url;
            if (result.multimedia != null ) {

                for ( var media of result.multimedia ){
                    if(media.url != null && media.width >= 2000){
                        url ='https://www.nytimes.com/' + media.url
                        break
                    }
                }
                if(url == null){
                    url = 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg'
                   
                }
            }
            else {
                url = 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg'
         
            }
        
        var sec="";
      
        if(result.news_desk != null && result.news_desk !="None"){
            sec = result.news_desk.toLowerCase()    
        }
    
        bookMarks.push({
            section :sec ,
            switch : swit ,
            title : result.headline.main,
            url : id,
            img : url,
            id : id ,
            date : results1.response.docs[0].pub_date.split("T")[0]
        })
        
        localStorage.setItem("cards",JSON.stringify(bookMarks))
        this.setState({result : true})

    }

    }
    componentDidUpdate(){
        ReactTooltip.rebuild()
      } 
    render() {
        var res = results1.response
        if( !id.includes('nytimes.com')){
        if (res != null && res.length != 0 && !this.state.isLoading && res.content!=null) {
            var result = res.content
            var section = result.sectionId
            var date = ""
            if(result.webPublicationDate !=null){
                date = result.webPublicationDate.split("T")[0]
            }
            var bookMarks = localStorage.getItem("cards")

            var BookmarkMarkComponent = FaRegBookmark;
            var divStyle = {
                marginLeft :'5%',
                marginRight :'2%',
                color :'red',
                marginTop :'0.3%'
            }
            
            if(bookMarks != null && !bookMarks.includes('[object Object]')){
                bookMarks = JSON.parse(bookMarks)
        
            for(var bookmark of bookMarks){
            
                if(bookmark.id == id){
                    BookmarkMarkComponent = FaBookmark;
                    divStyle = {
                        marginLeft :'5%',
                        marginRight :'2%',
                        color :'red',
                        marginTop :'0.3%'
                    }
                    break
                }
            
            }
        }
        

            var url;
            if (result.blocks != null && result.blocks.main != null
                && result.blocks.main.elements != null && result.blocks.main.elements[0] != null && result.blocks.main.elements[0].assets != null && result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length - 1] != null && result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length - 1].file != null) {
                url = result.blocks.main.elements[0].assets[result.blocks.main.elements[0].assets.length - 1].file
            }
            else {
                url = 'https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png'
            }
            var text = "";
            if( result.blocks != null && result.blocks.body != null && result.blocks.body[0] != null && result.blocks.body[0].bodyTextSummary!= null){
                text = result.blocks.body[0].bodyTextSummary
            }
            var flag = false
            if(text.length != 0){
                var sentenses = text.split(". ")
                var i =0
                var fourSentenses=""
                var extraSentenses=""
                if(sentenses.length > 4){
                for (var sentense of sentenses){
                    if(i<4){
                        fourSentenses = fourSentenses+ sentense +". "
                        i++
                    }else{
                        flag = true;
                        extraSentenses = extraSentenses +sentense+ ". "
                    }
                }
            }else{
                fourSentenses = text
            }}
            var textStyle ={
                
            }
            if(flag){
                textStyle = {
                    textAlign :'end',
                    width :'100%',
                }
            }else{
                textStyle = {
                    textAlign :'end',
                    width :'100%',
                    display:'none'
                }
            }
            return (
                <div>
                <Card style={{ boxShadow: '4px 4px 8px 4px rgba(192,192,192,0.6)', margin: '3%',padding :'2%' }}>
                    <div className="title" >
                        <Card.Title style={{ fontWeight: 'bold', width: '100%',fontSize :'20px'}}>
                            <i>{result.webTitle}</i></Card.Title>
                    </div>
                    <div style={{ display: "flex", width: '100%'}}>
                        <div style={{ width: "100%",fontSize :'16px' }}>
                            <Card.Text><i>{date}</i></Card.Text>
                        </div>
                        <div style = {{display :'flex',paddingBottom :'1%'}}>
                            
                            <FacebookShareButton
                                url={result.webUrl}
                                quote='#CSCI571_NewsApp'
                                className="Demo__some-network__share-button" data-tip = "Facebook">
                                <FacebookIcon size={25} round />
                                <ReactTooltip  />

                            </FacebookShareButton>

                            <TwitterShareButton
                                url={result.webUrl}
                                quote={result.webTitle}
                                hashtags={['CSCI571_NewsApp']}
                                className="Demo__some-network__share-button"
                                data-tip = "Twitter">
                                <TwitterIcon size={25} round />
                                <ReactTooltip  />
                            </TwitterShareButton>
                            <EmailShareButton

                                url={result.webUrl}
                                subject='#CSCI571_NewsApp'
                                className="Demo__some-network__share-button">
                                <EmailIcon size={25} round data-tip = "Email"/>
                                <ReactTooltip  />
                            </EmailShareButton>

                        </div>
                        <div style={divStyle} onClick = {this.bookMarkFunction}>
                                <BookmarkMarkComponent size = {20} data-tip = "Bookmark" />
                                <ReactTooltip  />
                            </div>
                        
                    </div>

                    <div className="img" style={{ width: '100%',paddingBottom :'1%' }}>
                        <Card.Img src={url} style={{ width: '100%' }}></Card.Img>
                    </div>
                    <div className="Data" style={{ width: "100%",fontSize :'16px',textAlign: 'justify'}}>
                    <div id = "desc">
                    {fourSentenses}
                    </div>
                    <div id = "iconDown" style = {textStyle} onClick = {()=>this.handleChange(text)}>
                        <MdKeyboardArrowDown  size={25}></MdKeyboardArrowDown>
                    </div>
                    <div id = "desc1" style = {{display:'none'}}>
                        <br/>
                    {extraSentenses}
                    </div>
                    <div id = "iconUp"  style = {{textAlign :'end',width :'100%',display:'none'}} onClick = {()=>this.handleChange1(text)} > 
                        <MdKeyboardArrowUp size = {25}></MdKeyboardArrowUp>
                    </div>
                    </div>

                </Card>
                 <div className="commentbox" style = {{ margin: '3%'}} />
                 </div>
            );
        }
        else if (this.state.isLoading) {
            return (
                <center>
                <div style={{ marginTop: '20%' }}>

                <BounceLoader size="3.5em" color="darkblue" />
                <h3>Loading</h3>
                </div>
          </center>
            )
        }
        else return <div></div>
    }else{
    if (res != null && res.docs != null && res.length != 0 && !this.state.isLoading && res.docs[0]!=null) {
            var result = res.docs[0]   
            var section = result.news_desk;
            var bookMarks = localStorage.getItem("cards")

            var BookmarkMarkComponent = FaRegBookmark;
            var divStyle = {
                marginLeft :'5%',
                marginRight :'2%',
                color :'red'
            }
            
            if(bookMarks != null && !bookMarks.includes('[object Object]')){
                bookMarks = JSON.parse(bookMarks)
        
            for(var bookmark of bookMarks){
            
                if(bookmark.id == id){
                    BookmarkMarkComponent = FaBookmark;
                    divStyle = {
                        marginLeft :'5%',
                        marginRight :'2%',
                        color :'red'
                    }
                    break
                }
            
            }
        }
        
            var title = ""
            if( result.headline != null ){
                title = result.headline.main
            }
            var date = ""
           
            if( result.pub_date!= null){
                date = result.pub_date.split("T")[0]
            }
            var url;
                if (result.multimedia != null ) {
                    for ( var media of result.multimedia ){
                        if(media.url != null && media.width >= 2000){
                            url = 'http://www.nytimes.com/'+media.url
                            break
                        }
                    }
                    if(url == null){
                        url = 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg'
                       
                    }
                }
                else {
                    url = 'https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg'
             
                }
                var text = result.abstract
                var flag = false
                if(text.length != 0){
                    var sentenses = text.split(". ")
                    var i =0
                    var fourSentenses=""
                    var  extraSentenses = ""
                    if(sentenses.length > 4){
                    for (var sentense of sentenses){
                        if(i<4){
                            fourSentenses = fourSentenses+ sentense +". "
                            i++
                        }else{
                            flag = true;
                            extraSentenses = extraSentenses +sentense+ ". "
                        }
                    }
                }else{
                    fourSentenses = text
                }}
                var textStyle ={
                    
                }
                if(flag){
                    textStyle = {
                        textAlign :'end',
                        width :'100%',
                    }
                }else{
                    textStyle = {
                        textAlign :'end',
                        width :'100%',
                        display:'none'
                    }
                }

            return (
                <div>
                <Card style={{ boxShadow: '4px 4px 8px 4px rgba(192,192,192,0.6)', margin: '3%',padding :'2%' }}>
                    <div className="title" >
                        <Card.Title  style={{ fontWeight: 'bold', width: '100%',fontSize :'20px'}}>
                            <i>{title}</i></Card.Title>
                    </div>
                    <div style={{ display: "flex", width: '100%'}}>
                    <div style={{ width: "100%",fontSize :'16px'  }}>
                            <Card.Text><i>{date}</i></Card.Text>
                        </div>
                        <div style = {{display :'flex',paddingBottom :'1%'}}>

                            <FacebookShareButton
                                url={result.web_url}
                                quote='#CSCI571_NewsApp'
                                className="Demo__some-network__share-button">
                                <FacebookIcon size={25} round data-tip ="Facebook"/>
                                <ReactTooltip  />
                            </FacebookShareButton>

                            <TwitterShareButton
                                url={result.web_url}
                                hashtags={['CSCI571_NewsApp']}
                                className="Demo__some-network__share-button"
                                data-tip ="Twitter">
                                <ReactTooltip  />
                                <TwitterIcon size={25} round  />
                            </TwitterShareButton>
                            <EmailShareButton
                                url={result.web_url}
                                subject='#CSCI571_NewsApp'
                                className="Demo__some-network__share-button"
                                 data-tip ="Email">
                                    <ReactTooltip  />
                                <EmailIcon size={25} round />
                            </EmailShareButton>
                           

                        </div>
                        <div style={divStyle} onClick = {this.bookMarkNYFunction}>
                                <BookmarkMarkComponent size = {20} data-tip ="Bookmark" />
                                <ReactTooltip  />
                            </div>
                    </div>


                    <div className="img" style={{ width: '100%',paddingBottom :'1%' }}>
                        <Card.Img src={url} style={{ width: '100%' }}></Card.Img>
                    </div>
                    <div className="Data" style={{ width: "100%",fontSize :'16px',textAlign: 'justify'}}>
                    <div id = "desc">
                    {fourSentenses}
                    </div>
                    <div id = "iconDown" style = {textStyle} onClick = {()=>this.handleChange(text)}>
                        <MdKeyboardArrowDown  size={25}></MdKeyboardArrowDown>
                    </div>
                    <div id = "desc1" style = {{display:'none'}}>
                    <br/>
                    {extraSentenses}
                    </div>
                    <div id = "iconUp"  style = {{textAlign :'end',width :'100%',display:'none'}} onClick = {()=>this.handleChange1(text)} > 
                        <MdKeyboardArrowUp size = {25}></MdKeyboardArrowUp>
                    </div>
                    </div>
                
                </Card>
                 <div className="commentbox" style = {{ margin: '3% '}} />
                 </div>
            );
        }
        else if (this.state.isLoading) {
            return (
                <center>
                <div style={{ marginTop: '20%' }}>

                    <BounceLoader size="3.5em" color="darkblue" />
                        <h3>Loading</h3>
                </div>
          </center>
            )
        }
        else return <div></div>
    }
    }
}