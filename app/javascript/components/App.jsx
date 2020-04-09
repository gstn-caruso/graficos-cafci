import React, {Component} from 'react';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, Label,
} from 'recharts';

export default class App extends Component {

  state = {data: []};

  componentDidMount() {
    fetch('/api/fondos')
      .then(response => response.json()
        .then(content => this.setState({data: content}))
      )
  }

  nombresDeFondos = () => {
    const nombres = this.state.data.flatMap(fci => {
      return Object.keys(fci);
    });

    return [...new Set(nombres)].filter(nombre => nombre !== 'fecha');
  };

  render() {
    return <LineChart width={1300} height={800} data={this.state.data}
                      margin={{top: 5, right: 30, left: 20, bottom: 5}}>
      <XAxis dataKey="fecha"/>
      <YAxis />
      <CartesianGrid strokeDasharray="3 3"/>
      <Tooltip/>
      <Legend/>
      {this.nombresDeFondos().map((nombre, index) =>
        <Line type="monotone" dataKey={`${nombre}`} key={index}/>
      )}
    </LineChart>
  }
};
