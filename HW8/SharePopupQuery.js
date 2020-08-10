import React, { Component } from 'react';
import {
  FacebookShareButton,
  TwitterShareButton,
  EmailShareButton,
  EmailIcon,
  FacebookIcon,
  TwitterIcon
} from 'react-share';
import { Modal } from 'react-bootstrap';
import { MdShare } from 'react-icons/md';


export default class SharepopupQuery extends Component {

  constructor(props){
    super(props);
    this.state = {show: false};
    this.open1 = this.open1.bind(this);
    this.close1 = this.close1.bind(this);
  }
  close1 = function(){
    this.setState({show:false})
  }
  open1 = function(){
    this.setState({show:true})
  }
  render() {
    return (
      <span onClick ={e=>e.stopPropagation()}>
        <MdShare onClick = {this.open1}></MdShare>
      <Modal show = {this.state.show} onHide = {this.close1} style={{opacity:1}}> 
        <Modal.Header closeButton>
        <Modal.Title>
        <div style = {{fontSize :'18px',fontWeight :'700'}}>
          {this.props.where}
        </div>
        <div style = {{fontSize :'16px',fontWeight :'600'}}>
          {this.props.title}
        </div>
        </Modal.Title>
        </Modal.Header>
    <Modal.Body>
    <center><div style ={{fontSize :'16px',fontWeight :'600'}}>Share via</div>
        
        <div style={{ display: 'flex' }}>
          <div style={{ width: "33%" }}>
            <FacebookShareButton
              url={this.props.url}
              hashtag='#CSCI571_NewsApp'
              className="Demo__some-network__share-button">
              <FacebookIcon size={32} round />

            </FacebookShareButton>
          </div>
          <div style={{ width: "33%" }}>
            <TwitterShareButton
              url={this.props.url}
              quote={this.props.title}
              hashtags={['CSCI571_NewsApp']}
              className="Demo__some-network__share-button"
            >
              <TwitterIcon size={32} round />
            </TwitterShareButton>
          </div>

          <div style={{ width: "33%" }}>
            <EmailShareButton

              url={this.props.url}
              subject='#CSCI571_NewsApp'
              className="Demo__some-network__share-button">
              <EmailIcon size={32} round />
            </EmailShareButton>
          </div>
        </div>
        </center>
      </Modal.Body>
      </Modal>
      </span>
    );
  }
}

