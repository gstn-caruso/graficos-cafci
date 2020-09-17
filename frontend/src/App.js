import React, {Component} from 'react';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
} from 'recharts';
import distinctColors from "distinct-colors";

export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {data: []};
  }

  componentDidMount() {
    this.obtenerRendimientos();
  }

  obtenerRendimientos = () => {
    fetch('/api/fondos')
      .then(response => response.json()
        .then(content => this.setState({data: content}))
      );
  };

  nombresDeFondos = () => {
    const nombres = this.state.data.flatMap(fci => {
      return Object.keys(fci);
    });

    return [...new Set(nombres)].filter(nombre => nombre !== 'fecha');
  };

  coloresParaFondos = () => {
    const cantidadDeFondos = this.nombresDeFondos().length + 1;
    return distinctColors({count: cantidadDeFondos}).map(color => color.toString())
  };

  numeroADinero = (value) => `$${value.toLocaleString()}`;

  render() {
    return <ResponsiveContainer width={1300} height={800}>
      <LineChart data={this.state.data}
                 margin={{top: 5, right: 30, left: 20, bottom: 5}}>
        <XAxis dataKey="fecha"/>
        <YAxis/>
        <CartesianGrid strokeDasharray="5 10"/>
        <Tooltip formatter={this.numeroADinero}/>
        {this.nombresDeFondos().map((nombre, index) => {
            const color = this.coloresParaFondos()[index];
            return <Line type="monotone"
                         dataKey={`${nombre}`}
                         key={index}
                         stroke={color}
                         dot={false}
            />;
          }
        )}
      </LineChart>
    </ResponsiveContainer>

  }
};
