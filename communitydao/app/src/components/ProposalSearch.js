import React from "react";
import { ContractData } from "@drizzle/react-components";

class ProposalSearch extends React.Component {
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
          <ContractData contract="CommunityDAO" method="proposals" methodArgs={[ this.state.value ]} />
        </form>
        
        
      );
    }
  }
  export default ProposalSearch; // Don’t forget to use export default!