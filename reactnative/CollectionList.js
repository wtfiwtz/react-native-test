var React = require('react-native');
var {
    StyleSheet,
    ListView,
    View,
    TouchableHighlight,
    Image,
    Text
} = React;

var ItemList = require('./ItemList.js');

var CollectionList = React.createClass({

    //_handleBackButtonPress: function() {
    //  this.props.navigator.pop();
    //},
    //
    //_handleNextButtonPress: function() {
    //  this.props.navigator.push(nextRoute);
    //},

    getInitialState: function() {
        return {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            loaded: false,
        };
        //return {
        //  collections: null,
        //};
    },

    fetchData: function() {
        fetch("http://10.211.55.2:3000" /* this.props.rest_url */ + "/websites/watches.json")
            .then((response) => response.json())
            .then((responseData) => {
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRows(responseData.collections),
                    loaded: true,
                    //collections: responseData.collections,
                });
            })
            .done();
    },

    componentDidMount: function() {
        this.fetchData();
    },

    render: function() {
        if (!this.state.loaded) {
            return this.renderLoadingView();
        }

        //var collections = this.state.collections;
        return this.renderCollections();
    },

    renderLoadingView: function() {
        return (
            <View style={styles.container}>
                <Text>
                    Loading collections...
                </Text>
            </View>
        )
    },

    renderCollections: function() {
        return (
            <ListView
                dataSource={this.state.dataSource}
                renderRow={this.renderCollection}
                style={styles.listView}
                automaticallyAdjustContentInsets={false}
                />
        );
    },

    collectionSelected: function() {
        this.props.navigator.push({
            component: ItemList,
            title: 'Item List',
            passProps: {
                rest_url: this.props.rest_url,
                collection_id: 'worldofwoodtype',
            }
        });
    },

    renderCollection: function(collection) {

        var collection_url = collection.hero_photo ? collection.hero_photo.url : "/blah.jpg";
        return (
            <TouchableHighlight onPress={this.collectionSelected}>
                <View style={styles.container}>
                    <Image
                        source={{uri: collection_url}}
                        style={styles.thumbnail}
                        />
                    <View style={styles.rightContainer}>
                        <Text style={styles.title}>{collection.name}</Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    }


});

module.exports = CollectionList;

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
