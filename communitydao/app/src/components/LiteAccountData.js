import { drizzleConnect } from "@drizzle/react-plugin";
import React, { Component } from "react";
import PropTypes from "prop-types";

class LiteAccountData extends Component {
  constructor(props) {
    super(props);

    this.precisionRound = this.precisionRound.bind(this);
  }

  precisionRound(number, precision) {
    var factor = Math.pow(10, precision);
    return Math.round(number * factor) / factor;
  }

  render() {
    // No accounts found.
    if (Object.keys(this.props.accounts).length === 0) {
      return <span>Initializing...</span>;
    }

    // Get account address and balance.
    const address = this.props.accounts[this.props.accountIndex];
    
    if (this.props.render) {
      return this.props.render({
        address,
      });
    }

    return (
      <div>
        <h4>{address}</h4>
      </div>
    );
  }
}

LiteAccountData.contextTypes = {
  drizzle: PropTypes.object,
};

LiteAccountData.propTypes = {
  accounts: PropTypes.objectOf(PropTypes.string),
  accountIndex: PropTypes.number.isRequired,
  render: PropTypes.func,
};

/*
 * Export connected component.
 */

const mapStateToProps = state => {
  return {
    accounts: state.accounts,
  };
};

export default drizzleConnect(LiteAccountData, mapStateToProps);
