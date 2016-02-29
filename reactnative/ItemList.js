
var React = require('react-native');
var {
    StyleSheet,
    ListView,
    View,
    TouchableHighlight,
    Image,
    Text
} = React;

var ItemList = React.createClass({

    getInitialState: function() {
        return {
            foldersDataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            itemsDataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            loaded: false,
        };
        //return {
        //  collections: null,
        //};
    },

    fetchData: function() {
        fetch("http://10.211.55.2:3000" /* this.props.rest_url */ + "/collections/" + this.props.collection_id + ".json")
            .then((response) => response.json())
            .then((responseData) => {
                this.setState({
                    foldersDataSource: this.state.foldersDataSource.cloneWithRows(responseData.folders),
                    itemsDataSource: this.state.itemsDataSource.cloneWithRows(responseData.items),
                    loaded: true,
                    //collections: responseData.collections,
                });
            })
            .done();
    },

    componentDidMount: function() {
        this.fetchData();
    },

    renderLoadingView: function() {
        return (
            <View style={styles.container}>
                <Text>
                    Loading items...
                </Text>
            </View>
        )
    },

    renderItems: function() {

        return (
            <ListView
                dataSource={this.state.itemsDataSource}
                renderRow={this.renderItem}
                style={styles.listView}
                automaticallyAdjustContentInsets={false}
                />
        );

        //return (
        //    <View>
        //      {/*<Text>Folders</Text>
        //      <ListView
        //          dataSource={this.state.foldersDataSource}
        //          renderRow={this.renderFolder}
        //          style={styles.listView}
        //          automaticallyAdjustContentInsets={false}
        //          />*/}
        //      <Text>Items</Text>
        //    </View>
        //);
    },

    itemSelected: function() {
        alert('clicked');
    },

    renderFolder: function(folder) {
        var folder_url = folder.hero_photo ? folder.hero_photo.url : "/blah.jpg";
        return (
            <TouchableHighlight onPress={this.itemSelected}>
                <View style={styles.container}>
                    <Image
                        source={{uri: folder_url}}
                        style={styles.thumbnail}
                        />
                    <View style={styles.rightContainer}>
                        <Text style={styles.title}>{folder.name}</Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    },

    renderItem: function(item) {
        var item_url = item.photos.length > 0 ? item.photos[0].url : "/blah.jpg";
        return (
            <TouchableHighlight onPress={this.itemSelected}>
                <View style={styles.container}>
                    <Image
                        source={{uri: item_url}}
                        style={styles.thumbnail}
                        />
                    <View style={styles.rightContainer}>
                        <Text style={styles.title}>{item.title}</Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    },

    render: function() {
        if (!this.state.loaded) {
            return this.renderLoadingView();
        }

        //var collections = this.state.collections;
        return this.renderItems();
    }
});

module.exports = ItemList;

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
