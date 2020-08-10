import React, { Component } from "react";
import Switch from "react-switch";
import  {Nav }from 'react-bootstrap';

export default class SwitchE extends Component {
  constructor() {
    super();
    if (localStorage.getItem("toggleValue") == "false")
      this.state = { checked: false };
    else
      this.state = { checked: true };
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(checked) {

    this.setState({ checked });
    this.props.onToggleValue(checked)
    localStorage.setItem("toggleValue", checked)

  }

  render() {
    if(this.props.onShow == false){
      return <div></div>
    }
    else{
    return (
      <span style = {{marginRight :"0.8em",marginLeft :"0.8em",marginTop :'2%'}}>
        <Switch onChange={this.handleChange} checked={this.state.checked}
          onColor="#2693e6"
          uncheckedIcon={false}
          checkedIcon={false}
          height={20}
          width={40}
          className="react-switch" />
          
    </span>
    );
  }}
}