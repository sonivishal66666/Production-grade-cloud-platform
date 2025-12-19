import React, { useState, useEffect } from 'react';

function App() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch('/api/data')
      .then(res => res.json())
      .then(data => setData(data))
      .catch(err => console.error(err));
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Cloud Platform Demo</h1>
        <p>
          Backend Status: {data ? "Connected" : "Loading..."}
        </p>
        {data && <pre>{JSON.dumps(data, null, 2)}</pre>}
      </header>
    </div>
  );
}

export default App;
