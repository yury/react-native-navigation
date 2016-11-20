import React, {PropTypes} from 'react';
import { requireNativeComponent } from 'react-native';

export default class CustomNavButton extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (<RNNCustomNavButton {...this.props}/>);
  }
}

CustomNavButton.propTypes = {
  buttonId: PropTypes.string,
  callbackId: PropTypes.string,
};

var RNNCustomNavButton = requireNativeComponent(
  'RNNCustomNavButton',
  CustomNavButton
);