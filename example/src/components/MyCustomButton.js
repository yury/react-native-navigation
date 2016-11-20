import React, {Component} from 'react';
import {
  Image,
  ActivityIndicator,
} from 'react-native';

export default class MyCustomButton extends Component {
  constructor(props) {
    super(props);
    this.state = {isAnimating: true};
  }

  componentDidMount() {
    setTimeout(() => {
      this.setState({isAnimating: false});
    }, 2000);
  }

  render() {
    return (
      <Image
        style={{width: 35, height: 35}}
        source={{uri: 'http://daynin.github.io/clojurescript-presentation/img/react-logo.png'}}
      >
        <ActivityIndicator
          animating={this.state.isAnimating}
          style={{alignItems: 'center',
            justifyContent: 'center', marginTop: 8}}
          size="small"
          color="#ffffff"
        />
      </Image>
    );
  }
}