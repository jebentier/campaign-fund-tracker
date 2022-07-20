import React, { useState, useEffect } from 'react';
import ReactLoading from 'react-loading';
import { Group } from '@visx/group';
import { Text } from '@visx/text';
// import { scaleOrdinal, schemeCategory10, scaleSequential, interpolateCool } from 'd3-scale';
// import { format as d3format } from 'd3-format';
// import { sankeyJustify, sankeyLeft, sankeyRight } from 'd3-sankey-circular';
// import { extent } from 'd3-array';

import cx from 'classnames';
import { sankeyCircular as d3Sankey } from 'd3-sankey-circular';
import { HierarchyDefaultNode as DefaultNode } from '@visx/hierarchy';
import chroma from 'chroma-js';
import debounce from 'debounce';

import Select from 'react-select/async';

const Sankey = ({
  top,
  left,
  className,
  data,
  size,

  nodeId,
  nodeAlign,
  nodeWidth,
  nodePadding,
  nodePaddingRatio,
  extent,
  iterations,
  circularLinkGap,

  children,
  nodeComponent = DefaultNode,
  ...restProps
}) => {
  const sankey = d3Sankey();
  if (size) sankey.size(size);
  if (nodeId) sankey.nodeId(nodeId);
  if (nodeAlign) sankey.nodeAlign(nodeAlign);
  if (nodeWidth) sankey.nodeWidth(nodeWidth);
  if (nodePadding) sankey.nodePadding(nodePadding);
  if (nodePaddingRatio) sankey.nodePaddingRatio(nodePaddingRatio);
  if (extent) sankey.extent(extent);
  if (iterations) sankey.iterations(iterations);
  if (circularLinkGap) sankey.circularLinkGap(circularLinkGap);

  const sankeyData = sankey(data);

  if (!!children) {
    return (
      <Group top={top} left={left} className={cx('vx-sankey', className)}>
        {children({ data: sankeyData })}
      </Group>
    );
  }
}

class CircularSankey extends React.Component {
  render() {
    const {
      data,
      width,
      height,
      margin = {
        top: 0,
        left: 0,
        right: 50,
        bottom: 0
      }
    } = this.props;

    if (width < 10) return null;

    return (
      <svg width={width + margin.left + margin.right} height={height}>
        <Sankey
          top={margin.top}
          left={margin.left}
          data={data}
          size={[width, height]}
          nodeWidth={15}
          nodePadding={40}
          nodePaddingRatio={0.1}
          nodeId={d => d.id}
          iterations={32}
        >
          {({ data }) => (
            <Group>
              {data.nodes.map((node, i) => (
                <Group top={node.y0} left={node.x0} key={`node-${i}`}>
                  <rect
                    id={`rect-${i}`}
                    width={node.x1 - node.x0}
                    height={node.y1 - node.y0}
                    fill={chroma.random().hex()}
                    opacity={0.5}
                    stroke="white"
                    strokeWidth={2}
                  />

                  <Text
                    x={18}
                    y={((node.y1 - node.y0) / 2)}
                    verticalAnchor="middle"
                    style={{
                      font: '10px sans-serif'
                    }}
                  >
                    {node.title}
                  </Text>

                </Group>
              ))}

              <Group strokeOpacity={.2}>
                {data.links.map((link, i) => (
                  <path
                    key={`link-${i}`}
                    d={link.path}
                    stroke={link.circular ? 'red' : 'black'}
                    strokeWidth={Math.max(1, link.width)}
                    opacity={0.7}
                    fill="none"
                  />
                ))}
              </Group>
            </Group>
          )}
        </Sankey>
      </svg>
    );
  }
}

const CircularMoneyFlowChart = () => {
  const [loading,      setLoading]      = useState(true);
  const [filter,       setFilter]       = useState({ value: 'all', label: 'All' });
  const [dataState,    setDataState]    = useState();

  const onFilterChange = (value) => { setFilter(value); }
  const onNodeClick    = (id) => setFilter(id);

  useEffect(() => {
    setLoading(true);

    const fetchData = async () => {
      const response = await fetch(`http://localhost:3000/api/v1/money_flow.json?filter=${filter.value}`);
      const data     = await response.json();
      setDataState(data);
      setLoading(false);
    }

    fetchData().catch(console.error)
  }, [filter]);

  if (loading) {
    return <ReactLoading type="spin" color={chroma.random().hex()} height={100} width={100} />;
  }

  const groupStyles = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
  };

  const groupBadgeStyles = {
    backgroundColor: '#EBECF0',
    borderRadius: '2em',
    color: '#172B4D',
    display: 'inline-block',
    fontSize: 12,
    fontWeight: 'normal',
    lineHeight: '1',
    minWidth: 1,
    padding: '0.16666666666667em 0.5em',
    textAlign: 'center',
  };

  const formatGroupLabel = (data) => (
    <div style={groupStyles}>
      <span>{data.label}</span>
      <span style={groupBadgeStyles}>{data.options.length}</span>
    </div>
  )

  const loadOptions = (inputValue, callback) => {
    const fetchData = async () => {
      const candidateResponse = await fetch(`http://localhost:3000/api/v1/candidates.json?filter=${inputValue}`);
      const committeeResponse = await fetch(`http://localhost:3000/api/v1/committees.json?filter=${inputValue}`);

      const candidates = await candidateResponse.json();
      const committees = await committeeResponse.json();

      callback([
        { value: 'all', label: 'All' },
        { label: 'Candidates', options: candidates.map((n) => ({ value: n.key, label: n.name })) },
        { label: 'Committees', options: committees.map((n) => ({ value: n.key, label: n.name })) }
      ])
    }

    fetchData().catch(console.error)
  }

  return (
    <>
      <Select
        defaultValue={filter}
        loadOptions={debounce(loadOptions, 200)}
        formatGroupLabel={formatGroupLabel}
        onChange={onFilterChange}
      />
      <CircularSankey data={dataState} width={10000} height={dataState.nodes.length * 100} />
    </>
  )
}

export default CircularMoneyFlowChart;
