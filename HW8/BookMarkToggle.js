import React,{Component} from 'react'
import {FaRegBookmark} from 'react-icons/fa'
import {FaBookmark} from 'react-icons/fa'
import ReactTooltip from 'react-tooltip'

export default class BookMarkToggle extends React.Component{
state = {value :null}

componentWillReceiveProps(props){
    this.setState({value :props.onBookmark})

   
}
componentWillMount(){
    this.setState({value :this.props.onBookmark})
    
}
componentDidUpdate(){
    ReactTooltip.rebuild()  

} 
onClick = () =>{

    this.setState({value :true})
    ReactTooltip.rebuild()  
  }
    render()
{
    var B="";
    if(this.state.value == true){
         B= FaBookmark
    }else{
        B = FaRegBookmark
    }
    return (
        <span>
        <B size = {20} style = {{marginRight : '3%'}} onClick = {this.onClick}>
        </B>
        
        </span>
        
    )
}}