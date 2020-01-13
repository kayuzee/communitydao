import React from "react";
import { ContractData } from "@drizzle/react-components";

class SubmissionSearch extends React.Component {
    constructor(props) {
      super(props);
      this.state = {value: ''};
      this.handleChange = this.handleChange.bind(this);
      this.handleSubmit = this.handleSubmit.bind(this);
    }
  
    handleChange(event) {
      this.setState({value: event.target.value});
    }
  
    handleSubmit(event) {
      alert('A name was submitted: ' + this.state.value);
      event.preventDefault();
    }
  
    render() {
      return (
        <form onSubmit={this.handleSubmit}>
          <label>
            Name:
            <input type="text" value={this.state.value} onChange={this.handleChange} />
          </label>
          <input type="submit" value="Submit" />
          <h1>{this.state.value}</h1>
          <ContractData contract="CommunityDAO" method="getSubmission" methodArgs={[ "0x8c4ee1d053c63e188d08b266fcdb86cab456861f" ]}/>
        </form>
        
        
      );
    }
  }
  export default SubmissionSearch; // Don’t forget to use export default!