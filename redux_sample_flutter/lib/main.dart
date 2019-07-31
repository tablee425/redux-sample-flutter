import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_sample_flutter/redux/middleware_counter.dart';
import 'package:redux_sample_flutter/redux/reducer_counter.dart';
import 'package:redux_sample_flutter/redux/state_counter.dart';
import 'package:redux_sample_flutter/redux/view_model_counter.dart';

void main() {
  Store<CounterState> store = Store<CounterState>(counterReducer, middleware: [CounterMiddleware()], initialState: CounterState(0));
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<CounterState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CounterState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Redux Sample'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('You have pushed the button this many times:'),
                StoreConnector<CounterState, CounterViewModel>(
                  converter: (store) {
                    return CounterViewModel(state: store.state);
                  },
                  builder: (context, CounterViewModel model) {
                    return Text(model.state.counter.toString(), style: TextStyle(fontSize: 36));
                  },
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: buildIncreaseButton()),
          Align(alignment: Alignment.bottomLeft, child: buildDecreaseButton()),
          Align(alignment: Alignment.bottomCenter, child: buildResetButton()),
        ],
      ),
    );
  }

  buildIncreaseButton() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: StoreConnector<CounterState, CounterViewModel>(
        converter: (store) {
          return CounterViewModel(
            state: store.state,
            onIncreaseCounter: () => store.dispatch(CounterActions.Increment),
          );
        },
        builder: (context, CounterViewModel model) => FloatingActionButton(
          onPressed: model.onIncreaseCounter,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  buildDecreaseButton() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: StoreConnector<CounterState, CounterViewModel>(
        converter: (store) {
          return CounterViewModel(
            state: store.state,
            onDecreaseCounter: () => store.dispatch(CounterActions.Decrement),
          );
        },
        builder: (context, CounterViewModel model) => FloatingActionButton(
          onPressed: model.onDecreaseCounter,
          child: Icon(Icons.remove),
        ),
      ),
    );
  }

  buildResetButton() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: StoreConnector<CounterState, CounterViewModel>(
        converter: (store) {
          return CounterViewModel(
            state: store.state,
            onResetCounter: () => store.dispatch(CounterActions.ResetCounter),
          );
        },
        builder: (context, CounterViewModel model) => FloatingActionButton(
          onPressed: model.onResetCounter,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
