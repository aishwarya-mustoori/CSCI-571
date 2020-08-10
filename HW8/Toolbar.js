import React from 'react'
import './toolbar.css'
import Autosuggest from './AutoSuggest.js';
import SwitchE from "./Switch.js";
import BookMarkToggle from './BookMarkToggle.js'
import ReactTooltip from 'react-tooltip'
import 'bootstrap/dist/css/bootstrap.css';

import { Route } from 'react-router'
import HomeResultsNY from './HomeResultsNY.js';
import HomeResultsGa from './HomeResultsGa.js';
import DetailedArticle from './DetailedArticle.js';
import BookMark from './Bookmark.js'

import { Navbar, Nav } from 'react-bootstrap';
import { BrowserRouter as Router, Link } from 'react-router-dom'
import { NavLink, Switch } from 'react-router-dom';
import QuerySearch from './QuerySearch.js'

class toolbar extends React.Component {
  state = { toggleValue: localStorage.getItem("toggleValue"),values : null};

  handleValue = (checked) => {
    localStorage.setItem("toggleValue", checked)
    if (checked == null)
      this.setState({ toggleValue: true })
    else {
      this.setState({ toggleValue: checked })
    }
  }
  componentDidMount(){
    this.setState({values:true})
  }
  handleValue1 = (value) => {
    this.setState({values:true})
  }

  changeToggle = (props) => {
    this.setState({values:true})
   
  }
  componentDidUpdate(){
    ReactTooltip.hide()

} 
 

  render() {
    
    var MainComponent;
    var value
    var bookValue =null;
    var divStyle = {}
    if(window.location.href.indexOf("/search")  <= -1  && window.location.href.indexOf("/Favorites") <= -1 && window.location.href.indexOf("/article") <= -1 ){
      value = true
      divStyle = {
        color: "white", 
        fontSize: "17px",
        marginLeft :'0.3em !important',
        display :'block',
        marginTop :'2%'
      }
    }else {
     value = false;
     divStyle = {
      color: "white", 
      marginLeft :'0.3em !important',
      fontSize: "17px",
      display :'none',
      marginTop :'2%'
    }
    }
    if( window.location.href.indexOf("/Favorites") >-1 ){
      bookValue = true
    }else {
      bookValue = false;
    }

    if (localStorage.getItem("toggleValue") == "false") {
      MainComponent = HomeResultsNY
    } else {
      MainComponent = HomeResultsGa
    } 


    return (
      <div>
        <Router>
          <div className="toolbar">
          <Navbar expand="md">
              <div className="container autosuggest" >
                <Autosuggest onValue = {this.handleValue1} ></Autosuggest>
              </div>
              
              <Navbar.Toggle aria-controls="basic-navbar-nav" className="navbar-dark" />
              <Navbar.Collapse id="basic-navbar-nav">
                
                <Nav className="mr-auto left" >
                  <NavLink exact to="/" activeStyle={{ color: 'white', opacity: '1' ,fontSize :'15px'}} style={{ color: 'white', opacity: '0.5',fontSize :'15px' }} >Home</  NavLink >
                  <NavLink to="world" activeStyle={{ color: 'white', opacity: '1' ,fontSize :'15px'}} style={{ color: 'white', opacity: '0.5',fontSize :'15px' }} >World</NavLink>
                  <NavLink to="politics" activeStyle={{ color: 'white', opacity: '1' ,fontSize :'15px'}} style={{ color: 'white', opacity: '0.5' ,fontSize :'15px'}} >Politics</NavLink>
                  <NavLink to="business" activeStyle={{ color: 'white', opacity: '1',fontSize :'15px' }} style={{ color: 'white', opacity: '0.5' ,fontSize :'15px'}} >Business</NavLink>
                  <NavLink to="technology" activeStyle={{ color: 'white', opacity: '1' ,fontSize :'15px'}} style={{ color: 'white', opacity: '0.5',fontSize :'15px' }}>Technology</NavLink>
                  <NavLink to="sports" activeStyle={{ color: 'white', opacity: '1',fontSize :'15px' }} style={{ color: 'white', opacity: '0.5' ,fontSize :'15px'}}>Sports</NavLink>
                </Nav>
                <Nav className ="ml-auto">
                <NavLink to="Favorites" style={{ color: 'white',marginRight :'10%',marginTop :'2%',width:'10%'}} data-tip ="Bookmark" data-place="bottom" >
                  <span data-tip ="Bookmark" data-place="bottom" >
                  <BookMarkToggle onBookmark = {bookValue}  />
                  </span>
                  <ReactTooltip  />
                  </NavLink>
                  
                <span style={divStyle}>
                    NYTimes 
                  </span>
                  <SwitchE onToggleValue={this.handleValue} onShow = {value}></SwitchE>
                  <span style={divStyle}>
                    Guardian
                  </span>

                </Nav>
                
              </Navbar.Collapse>
            </Navbar>

          </div>
          <div>

            <Switch>
              <Route exact path="/" render ={(props) => <MainComponent {...props} onToggle={this.changeToggle} /> }></Route> 
              <Route exact path="/search" component={QuerySearch}></Route> 
              <Route exact path="/article" render ={(props) => <DetailedArticle {...props} onToggle={this.changeToggle} /> } >
             
              </Route>
              <Route exact path="/Favorites" render ={(props) => <BookMark {...props} onToggle={this.changeToggle} />}></Route>
              <Route exact path ="/world" render ={(props) => <MainComponent {...props} onToggle={this.changeToggle} /> }></Route> 
              <Route exact path ="/politics" render ={(props) => <MainComponent {...props} onToggle={this.changeToggle} /> }></Route> 
              <Route exact path ="/technology" render ={(props) => <MainComponent {...props} onToggle={this.changeToggle} /> }></Route> 
              <Route exact path ="/sports" render ={(props) => <MainComponent {...props} onToggle={this.changeToggle} /> }></Route> 
              <Route exact path ="/business" render ={(props) => <MainComponent {...props} onToggle={this.changeToggle} /> }></Route> 

            </Switch>

          </div>
        </Router>
      </div>

    )
  };
}
export default (toolbar)
