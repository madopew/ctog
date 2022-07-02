import React, {useState} from 'react';
import './App.css';
import GraphDrawer, {Graph} from './components/GraphDrawer/GraphDrawer';
import axios from "axios";

function App() {
  const [code, setCode] = useState('');
  const [graphData, setGraphData] = useState<Graph[]>([]);
  const [graphIndex, setGraphIndex] = useState(0);

  const handleSubmitCode = () => {
    axios('http://localhost:8080/api/v1/graph/', {
      method: 'POST',
      data: code,
      headers: {
        'Content-Type': 'text/plain'
      }
    })
      .then(res => {
        setGraphData(res.data);
        setGraphIndex(graphIndex + 1);
      })
      .catch(err => {
        console.log(err);
      });
  }

  return (
    <div className="App">
      <textarea value={code} onChange={(e) => setCode(e.target.value)} cols={40} rows={20}/>
      <button onClick={handleSubmitCode}>Send</button>
      {graphData.map(graph => (
        <GraphDrawer key={graphIndex} data={graph}/>
      ))}
    </div>
  );
}

export default App;
