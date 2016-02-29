/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Image,
  ListView,
  TouchableHighlight,
  Text,
  View,
  NavigatorIOS,
} = React;

var CollectionList = require('./CollectionList.js');

var reactnative = React.createClass({

  rest_url: "http://10.211.55.2:3000",

  render: function() {
    return (
      <NavigatorIOS ref="nav" style={styles.wrapper} itemWrapperStyle={styles.navWrap} initialRoute={{
        component: CollectionList,
        title: 'Collection List',
        passProps: {
          rest_url: this.rest_url,
        },
      }} />
    );
  },

});

var styles = StyleSheet.create({
  wrapper: {
    flex: 1,
  },
  navWrap: {
    flex: 1,
    marginTop: 70,
  },
  container: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  thumbnail: {
    width: 200,
    height: 150,
  },
  rightContainer: {
    flex: 1,
  },
  listView: {
    paddingTop: 20,
    backgroundColor: '#F5FCFF',
  },
});

AppRegistry.registerComponent('reactnative', () => reactnative);
