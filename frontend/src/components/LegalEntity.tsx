import * as React from "react";

import { LegalEntityProps } from "../types";

const LegalEntity: React.FC<LegalEntityProps> = (props: LegalEntityProps) => {
  return (
    <>
      <p>Entity Name: {props.name}</p>
      <p>Entity Location: {props.state}, {props.country}</p>
      <p>Inbound Contributions: ${props.totalInboundContributions}</p>
      <p>Outbound Contributions: ${props.totalOutboundContributions}</p>
    </>
  );
}

export default LegalEntity
