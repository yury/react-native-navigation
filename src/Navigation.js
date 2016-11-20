/*eslint-disable*/
import React from 'react';
import {AppRegistry, View} from 'react-native';
import platformSpecific from './deprecated/platformSpecificDeprecated';
import Screen from './Screen';
import CustomNavButton from './CustomNavButton/CustomNavButton'

import PropRegistry from './PropRegistry';

const registeredScreens = {};

function registerScreen(screenID, generator) {
  registeredScreens[screenID] = generator;
  AppRegistry.registerComponent(screenID, generator);
}

function registerComponent(screenID, generator, store = undefined, Provider = undefined) {
  if (store && Provider) {
    return _registerComponentRedux(screenID, generator, store, Provider);
  } else {
    return _registerComponentNoRedux(screenID, generator);
  }
}

function _prepareCustomButtons(buttonsArray, resultCustomButtonsArray) {
  if (buttonsArray) {
    buttonsArray.map((button) => {
      if(button.customButton) {
        resultCustomButtonsArray.push(
          <CustomNavButton key={button.id}
                           buttonId={button.id}
                           callbackId={button.onPress}
                           style={{position: 'absolute'}}>
            {button.customButton()}
          </CustomNavButton>
        );
      }
    });
  }
}

function _renderCustomNavButtons(navigatorButtons) {
  const customButtons = [];
  if(navigatorButtons) {
    _prepareCustomButtons(navigatorButtons.rightButtons, customButtons);
    _prepareCustomButtons(navigatorButtons.leftButtons, customButtons);
  }
  return customButtons;
}

function _setCustomButtons(navigator, navigatorButtons) {
  if (navigatorButtons && (navigatorButtons.rightButtons || navigatorButtons.leftButtons)) {
    setTimeout(() => {
      navigator.setButtons({
        rightButtons: navigatorButtons.rightButtons,
        leftButtons: navigatorButtons.leftButtons
      });
    }, 0);
  }
}

function _registerComponentNoRedux(screenID, generator) {
  const generatorWrapper = function() {
    const InternalComponent = generator();
    return class extends Screen {
      static navigatorStyle = InternalComponent.navigatorStyle || {};
      static navigatorButtons = InternalComponent.navigatorButtons || {};

      constructor(props) {
        super(props);
        this.state = {
          internalProps: {...props, ...PropRegistry.load(props.screenInstanceID)}
        }
      }

      componentDidMount() {
        _setCustomButtons(this.navigator, InternalComponent.navigatorButtons)
      }

      componentWillReceiveProps(nextProps) {
        this.setState({
          internalProps: {...PropRegistry.load(this.props.screenInstanceID), ...nextProps}
        })
      }

      render() {
        return (
          <View>
            {_renderCustomNavButtons(InternalComponent.navigatorButtons)}
            <InternalComponent navigator={this.navigator} {...this.state.internalProps} />
          </View>
        );
      }
    };
  };
  registerScreen(screenID, generatorWrapper);
  return generatorWrapper;
}

function _registerComponentRedux(screenID, generator, store, Provider) {
  const generatorWrapper = function() {
    const InternalComponent = generator();
    return class extends Screen {
      static navigatorStyle = InternalComponent.navigatorStyle || {};
      static navigatorButtons = InternalComponent.navigatorButtons || {};

      constructor(props) {
        super(props);
        this.state = {
          internalProps: {...props, ...PropRegistry.load(props.screenInstanceID)}
        }
      }

      componentDidMount() {
        _setCustomButtons(this.navigator, InternalComponent.navigatorButtons)
      }

      componentWillReceiveProps(nextProps) {
        this.setState({
          internalProps: {...PropRegistry.load(this.props.screenInstanceID), ...nextProps}
        })
      }

      render() {
        return (
          <Provider store={store}>
            {_renderCustomNavButtons(InternalComponent.navigatorButtons)}
            <InternalComponent navigator={this.navigator} {...this.state.internalProps} />
          </Provider>
        );
      }
    };
  };
  registerScreen(screenID, generatorWrapper);
  return generatorWrapper;
}

function getRegisteredScreen(screenID) {
  const generator = registeredScreens[screenID];
  if (!generator) {
    console.error(`Navigation.getRegisteredScreen: ${screenID} used but not yet registered`);
    return undefined;
  }
  return generator();
}

function showModal(params = {}) {
  return platformSpecific.showModal(params);
}

function dismissModal(params = {}) {
  return platformSpecific.dismissModal(params);
}

function dismissAllModals(params = {}) {
  return platformSpecific.dismissAllModals(params);
}

function showLightBox(params = {}) {
  return platformSpecific.showLightBox(params);
}

function dismissLightBox(params = {}) {
  return platformSpecific.dismissLightBox(params);
}

function showInAppNotification(params = {}) {
  return platformSpecific.showInAppNotification(params);
}

function dismissInAppNotification(params = {}) {
  return platformSpecific.dismissInAppNotification(params);
}

function startTabBasedApp(params) {
  return platformSpecific.startTabBasedApp(params);
}

function startSingleScreenApp(params) {
  return platformSpecific.startSingleScreenApp(params);
}

export default {
  getRegisteredScreen,
  registerComponent,
  showModal: showModal,
  dismissModal: dismissModal,
  dismissAllModals: dismissAllModals,
  showLightBox: showLightBox,
  dismissLightBox: dismissLightBox,
  showInAppNotification: showInAppNotification,
  dismissInAppNotification: dismissInAppNotification,
  startTabBasedApp: startTabBasedApp,
  startSingleScreenApp: startSingleScreenApp
};
