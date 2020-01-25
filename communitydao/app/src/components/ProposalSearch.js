import React from "react";
import { ContractData } from "@drizzle/react-components";
import { Input, Button } from 'rimble-ui';
class ProposalSearch extends React.Component {
    constructor(props) {
      super(props);
      this.state = {value: []};
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
            <Input type="search" required={true} placeholder="e.g. ProposalID" value={this.state.value} onChange={this.handleChange}/>
          </label>
          <Button type="submit" value="Submit">Submit</Button>
         
          <ContractData contract="CommunityDAO" method="proposals" methodArgs={[ this.state.value ]} />
        </form>
        
        
      );
    }
  }
  export default ProposalSearch; // Don’t forget to use export default!