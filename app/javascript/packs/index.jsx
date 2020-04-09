import React from 'react'
import ReactDOM from 'react-dom'

const Saludar = props => <div>Hola {props.nombre}!</div>;

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Saludar nombre="Reacts" />,
    document.body.appendChild(document.createElement('div')),
  )
});
