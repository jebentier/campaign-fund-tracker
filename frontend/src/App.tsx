import React from 'react';
import Box from '@mui/material/Box';
import Accordion from '@mui/material/Accordion';
import AccordionDetails from '@mui/material/AccordionDetails';
import AccordionSummary from '@mui/material/AccordionSummary';
import Typography from '@mui/material/Typography';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import InfiniteScroll from 'react-infinite-scroll-component';
import { useQuery, gql } from '@apollo/client';

import { LegalEntityProps } from './types';
import LegalEntity from './components/LegalEntity';

import './App.css';

const GET_COMMITTEES = gql`
  query GetCommittees($searchString: String, $first: Int, $cursor: String) {
    committees(searchString: $searchString, first: $first, after: $cursor) {
      nodes {
        id
        name
        type
        state
        country
        fecForiegnKey
        totalOutboundContributions
        totalInboundContributions
      }
      pageInfo {
        endCursor
        hasNextPage
      }
    }
  }
`;

interface GetCommitteesResponse {
  committees: {
    nodes: [LegalEntityProps];
    pageInfo: {
      endCursor: string;
      hasNextPage: boolean;
    };
  }
}

const App = () => {
  const [expanded, setExpanded] = React.useState<string | false>(false);
  const { data, error, loading, fetchMore } = useQuery(
    GET_COMMITTEES,
    { variables: { first: 50 } }
  );

  const updateResults = (previousResult: GetCommitteesResponse, { fetchMoreResult } : { fetchMoreResult: GetCommitteesResponse }) => {
    const newNodes = fetchMoreResult.committees.nodes;
    const pageInfo = fetchMoreResult.committees.pageInfo;

    return newNodes.length
      ? {
        committees: {
          nodes: [...previousResult.committees.nodes, ...newNodes],
          pageInfo
        }
      }
      : previousResult;
  }

  const loadMore = () => {
    fetchMore({
      variables: { cursor: data.committees.pageInfo.endCursor },
      updateQuery: updateResults
    }).catch(console.error);
  }

  const handleChange =
    (panel: string) => (event: React.SyntheticEvent, isExpanded: boolean) => {
      setExpanded(isExpanded ? panel : false);
    };


  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  const committees = data && data.committees && data.committees.nodes;
  const dataLength = (committees && committees.length) || 0;
  const hasNextPage = data && data.committees && data.committees.pageInfo && data.committees.pageInfo.hasNextPage;

  return (
    <Box sx={{ flexGrow: 1, padding: '2rem' }}>
      <InfiniteScroll
        dataLength={dataLength}
        next={loadMore}
        hasMore={hasNextPage}
        loader={<div>Loading More...</div>}
      >
        {committees.map((committee: LegalEntityProps) => (
          <Accordion key={committee.id} expanded={expanded === committee.id} onChange={handleChange(committee.id)}>
            <AccordionSummary
              expandIcon={<ExpandMoreIcon />}
              aria-controls="panel1bh-content"
              id="panel1bh-header"
            >
              <Typography sx={{ width: 'auto', flexShrink: 1, marginRight: '1rem' }}>
                {committee.name}
              </Typography>
              <Typography sx={{ flexShrink: 0, color: 'text.secondary', margin: 'auto 2rem auto auto' }}>{committee.state}, {committee.country}</Typography>
            </AccordionSummary>
            <AccordionDetails>
              <LegalEntity {...committee} />
            </AccordionDetails>
          </Accordion>
        ))}
      </InfiniteScroll>
    </Box>
  );
}

export default App;
