import React, { useState, useEffect } from 'react';
import ReactLoading from 'react-loading';
import { SankeyNode, SankeyLink } from 'reaviz';
import { Sankey } from 'reaviz';
// import Sankey from './CircularSankey'
import chroma from 'chroma-js';

const MoneyFlowChart = () => {
  const [loading,   setLoading]   = useState(true);
  const [filter,    setFilter]    = useState('all');
  const [dataState, setDataState] = useState();
  const [nodes,     setNodes]     = useState({ candidates: [], committees: [] });

  const onFilterChange = ({ target: { value }}) => { setFilter(value); }

  useEffect(() => {
    const fetchData = async () => {
      const candidateResponse = await fetch('http://localhost:3000/api/v1/candidates.json');
      const committeeResponse = await fetch('http://localhost:3000/api/v1/committees.json');

      const candidates = await candidateResponse.json();
      const committees = await committeeResponse.json();

      setNodes({ candidates, committees });
    }

    fetchData().catch(console.error)
  }, []);

  useEffect(() => {
    setLoading(true);

    const fetchData = async () => {
      const response = await fetch(`http://localhost:3000/api/v1/money_flow.json?filter=${filter}`);
      const data     = await response.json();
      setDataState(data);
      setLoading(false);
    }

    fetchData().catch(console.error)
  }, [filter]);

  const onNodeClick = (id) => setFilter(id);

  if (loading) {
    return <ReactLoading type="spin" color={chroma.random().hex()} height={100} width={100} />;
  }

  return (
    <>
      <select value={filter} style={{ margin: '2rem auto', maxWidth: '50%' }} onChange={onFilterChange}>
        <option value="all">All</option>
        <optgroup label="Committees">
          {nodes.committees.map((n) => (<option value={n.key} key={n.key}>{n.name}</option>))}
        </optgroup>
        <optgroup label="Candidates">
          {nodes.candidates.map((n) => (<option value={n.key} key={n.key}>{n.name}</option>))}
        </optgroup>
      </select>
      <div style={{ margin: '2rem auto', maxWidth: '90%' }}>
        <Sankey
          justification='left'
          height={dataState.nodes.length * 50}
          width={1000}
          nodes={dataState.nodes.map(({ id, title }) => (<SankeyNode key={id} id={id} title={title} color={chroma.random().hex()} onClick={() => onNodeClick(id)} />))}
          links={dataState.links.map((link) => <SankeyLink {...link} key={`${link.source}-${link.target}`} gradient={true} />)}
        />
      </div>
    </>
  );
}

export default MoneyFlowChart;
