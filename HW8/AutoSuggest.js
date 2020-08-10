import React from 'react';
import AsyncSelect from 'react-select/async';
import axios from 'axios';
import createHistory from 'history/createBrowserHistory';
import _ from "lodash";



import { withRouter } from 'react-router-dom'

const history = createHistory();



class Autosuggest extends React.Component {
    state = { selectedOption: this.props.queryValue };
componentWillReceiveProps(props){
    if(window.location.href.indexOf("/search")  <= -1 ){
        this.setState({selectedOption:""})
   }
}

 loadOptionsChange = async (newValue) => {
    if (!newValue) {
        return Promise.resolve([]);
    }
    var results1 = []
    var results2 = []
    var response = await axios.get(
        `https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=${newValue}`,
        {
            headers: {

                "Ocp-Apim-Subscription-Key": "b6e4106b94bf492881a1c5acb58445d6"
            }
        }
    )
    results1 = response.data

    const resultsRaw = results1.suggestionGroups[0].searchSuggestions;
    results2 = resultsRaw.map(result => ({ label: result.displayText, value: result.url }));

    return Promise.resolve(results2)
};

    handleChange = selectedOption => {
        this.setState({ selectedOption });
                this.props.onValue(true);
        this.props.history.push("/search?q=" + selectedOption.label);
        history.push("/search?q=" + selectedOption.label)
    };

    render() {
        return (
            <AsyncSelect
                value={this.state.selectedOption}
                placeholder="Enter Keyword .."
                loadOptions={_.debounce(this.loadOptionsChange,100, {
                    leading: true
                  })}
                onChange={this.handleChange}
                
                cacheOptions={true}
                style={{
                    margin: '0.2%',
                    padding :'0px'
                }}
                noOptionsMessage = {() => 'No Match'}

            />
        );
    }
}
export default withRouter(Autosuggest)


