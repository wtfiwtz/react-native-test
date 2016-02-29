/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
    AppRegistry,
    BackAndroid,
    StyleSheet,
    ToolbarAndroid,
    Image,
    ListView,
    TouchableHighlight,
    Text,
    View,
    Navigator,
    } = React;

var CollectionList = require('./CollectionList.js');

var _navigator;
BackAndroid.addEventListener('hardwareBackPress', () => {
  if (_navigator && _navigator.getCurrentRoutes().length > 1) {
    _navigator.pop();
    return true;
  }
  return false;
});

var RouteMapper = function(route, navigationOperations, onComponentRef) {

  var rest_url = "http://10.0.72.170:3000";

  _navigator = navigationOperations;
  if (route.name === 'search') {
    return (
        <SearchScreen navigator={navigationOperations} />
    );
  } else if (route.name === 'collectionList') {
    return (
        <View style={{flex: 1}}>
          <ToolbarAndroid
              actions={[{title: 'Settings', icon: require('image!abc'), show: 'always'}]}
              logo={require('image!abc')}
              navIcon={require('image!abc')}
              onIconClicked={navigationOperations.pop}
              style={styles.toolbar}
              titleColor="black"
              title="Toolbar Title" />
          <CollectionList
              style={{flex: 1}}
              navigator={navigationOperations}
              rest_url={rest_url}
              />
        </View>
    );
  }
};

var reactnative = React.createClass({

  rest_url: "http://10.0.72.170:3000",

  render: function() {
    var initialRoute = {name: 'collectionList'};
    return (
        <Navigator
            style={styles.container}
            initialRoute={initialRoute}
            configureScene={() => Navigator.SceneConfigs.FadeAndroid}
            renderScene={RouteMapper}
            restUrl={this.rest_url}
            />
    );
    //<Navigator ref="nav" initialRoute={{
    //    component: CollectionList,
    //    title: 'Collection List',
    //    passProps: {
    //      rest_url: this.rest_url,
    //    },
    //  }} />
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
  toolbar: {
    backgroundColor: '#a9a9a9',
    height: 56,
  },
});

AppRegistry.registerComponent('reactnative', () => reactnative);
